package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace"
	"go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp"
	"go.opentelemetry.io/otel/propagation"
	"go.opentelemetry.io/otel/sdk/resource"
	"go.opentelemetry.io/otel/sdk/trace"
	semconv "go.opentelemetry.io/otel/semconv/v1.4.0"
	//"go.opentelemetry.io/otel/trace"
	"golang.org/x/exp/rand"
)

var port string
var colorRequestCount = promauto.NewCounter(
	prometheus.CounterOpts{
		Name: "color_request_count",
		Help: "Number of requests made to the color endpoint",
	},
)

func PortValidator(port string) (string, error) {
	port = os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	port = ":" + port
	_, err := http.Get("http://localhost" + port)
	if err == nil {
		return port, fmt.Errorf("port %s is already in use", port)
	}
	return port, nil
}

// initTracer creates a new instance of Jaeger tracer.
func initTracer() func() {
	client := otlptracehttp.NewClient(
		otlptracehttp.WithEndpoint("jaeger:4318"),
		otlptracehttp.WithInsecure(),
	)
	exporter, err := otlptrace.New(context.Background(), client)
	if err != nil {
		log.Fatalf("failed to create exporter: %v", err)
	}
	provider := trace.NewTracerProvider(
		trace.WithBatcher(exporter),
		trace.WithResource(resource.NewWithAttributes(
			semconv.SchemaURL,
			semconv.ServiceNameKey.String("colorpicker"),
		),
		),
	)
	otel.SetTracerProvider(provider)
	otel.SetTextMapPropagator(propagation.TraceContext{})
	return func() {
		if err := provider.Shutdown(context.Background()); err != nil {
			log.Fatalf("failed to shutdown provider: %v", err)
		}
	}
}

// ColorPickerHandler prints a random color to the web page.
func ColorPickerHandler(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	tracer := otel.Tracer("colorpicker")
	_, span := tracer.Start(ctx, "ColorPickerHandler")
	defer span.End()
	colorRequestCount.Inc()
	colors := []string{"red", "blue", "green", "yellow", "purple", "orange"}
	rand.Seed(uint64(time.Now().UnixNano()))
	color := colors[rand.Intn(len(colors))]
	_, err := fmt.Fprintf(w, "Your color is: %s", color)
	log.Println("Selected color:", color)
	if err != nil {
		return
	}
}

// HealthcheckHandler returns 200 OK status.
func HealthcheckHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintln(w, "Healthy")
	log.Println("Server is healthy")
}

// Call Registration Service
func RegisterService() {
	client := http.Client{}
	req, err := http.NewRequest("POST", "http://localhost:8081/register", nil)
	if err != nil {
		log.Fatalf("failed to create request, %v", err)
	}
	client.Do(req)
}

func main() {
	defer initTracer()()
	port, err := PortValidator(port)
	if err != nil {
		log.Fatalf("failed to validate port, %v", err)
		return
	}

	// Register the metrics handler
	http.Handle("/metrics", promhttp.Handler())

	// Register the ColorPickerHandler function to handle requests
	http.HandleFunc("/color", ColorPickerHandler)

	// Register the HealthcheckHandler function to handle requests
	http.HandleFunc("/health", HealthcheckHandler)

	err = http.ListenAndServe(port, nil)
	if err != nil {
		log.Fatalf("failed to start webserver, %v", err)
		return
	}
	log.Println("Server running on", port)
}
