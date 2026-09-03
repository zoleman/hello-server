package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
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

	port := os.Getenv("APP_PORT")
		if port == "" {
			port = "8080"
		}

	server := &http.Server{
		Addr: ":" + port,
	}

	serverErrors := make(chan error, 1)

	go func() {
		fmt.Printf("Server listening on http://localhost:%s\n", port)
		serverErrors <- server.ListenAndServe()
	}()

	shutdown := make(chan os.Signal, 1)
	signal.Notify(shutdown, os.Interrupt, syscall.SIGTERM)

	select {
	case err := <-serverErrors:
		if err != nil && err != http.ErrServerClosed {
			fmt.Printf("Server error: %v\n", err)
		}

	case sig := <-shutdown:
		fmt.Printf("Received %s, shutting down gracefully...\n", sig)

		ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
		defer cancel()

		if err := server.Shutdown(ctx); err != nil {
			fmt.Printf("Graceful shutdown failed: %v\n", err)
		}

		fmt.Println("Server stopped")
	}
}
