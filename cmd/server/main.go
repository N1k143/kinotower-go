package main

import (
	"github.com/N1k143/kinotower-go/internal/core/logger"
	core_server "github.com/N1k143/kinotower-go/internal/core/server"
)

func main() {
	if err := logger.Init("logs"); err != nil {
		panic("failed to init logger: " + err.Error())
	}

	logger.Log.Info("Starting server", "addr", ":8080")

	server := core_server.NewServer()

	if err := server.ListenAndServe(); err != nil {
		logger.Log.Error("Server stopped", "error", err)
	}
}
