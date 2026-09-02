package main

import (
	"fmt"
	"net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello, World!")
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintln(w, "healthy")
}

func main() {
	http.HandleFunc("/health", healthHandler)
	http.HandleFunc("/", helloHandler)

	fmt.Println("Server listening on http://localhost:8080")

	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Println(err)
	}
}