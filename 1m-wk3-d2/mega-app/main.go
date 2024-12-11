package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"time"

	"golang.org/x/exp/rand"
)

// ColorPicker prints a random color to the web page.
func ColorPicker(w http.ResponseWriter, r *http.Request) {
	colors := []string{"red", "blue", "green", "yellow", "purple", "orange"}
	rand.Seed(uint64(time.Now().UnixNano()))
	color := colors[rand.Intn(len(colors))]
	_, err := fmt.Fprintf(w, "Your color is: %s", color)
	log.Println("Selected color:", color)
	if err != nil {
		return
	}
}

func main() {
	// Get the PORT environment variable
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	// Format the port for the web server
	port = ":" + port
	// Check if the port is available
	_, err := http.Get("http://localhost" + port)
	if err == nil {
		log.Fatalf("Port %s is already in use\n", port)
		return
	}
	// Register the ColorPicker function to handle requests
	http.HandleFunc("/", ColorPicker)
	// Start the web server
	err = http.ListenAndServe(port, nil)
	if err != nil {
		log.Fatalf("failed to start webserver, %v", err)
		return
	}
	log.Println("Server running on", port)
}
