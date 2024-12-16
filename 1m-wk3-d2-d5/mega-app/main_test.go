package main

import (
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

// TestColorPicker tests the ColorPicker function.
func TestColorPickerHandler(t *testing.T) {
	// Create a new request
	req := httptest.NewRequest("GET", "/", nil)
	// Create a new response recorder
	rec := httptest.NewRecorder()
	// Call the ColorPicker function
	ColorPickerHandler(rec, req)
	// Get the response
	res := rec.Result()
	// Check the status code
	if res.StatusCode != http.StatusOK {
		t.Errorf("expected status OK; got %v", res.Status)
	}
	// Check the response body
	body, err := io.ReadAll(res.Body)
	if err != nil {
		t.Fatalf("could not read response body: %v", err)
	}
	expected := "Your color is: "
	if !strings.Contains(string(body), expected) {
		t.Errorf("expected body to contain %q; got %q", expected, string(body))
	}
}
