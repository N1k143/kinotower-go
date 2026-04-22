package main

import (
	core_database "github.com/N1k143/kinotower-go/internal/core/database"
	core_logger "github.com/N1k143/kinotower-go/internal/core/logger"
	core_server "github.com/N1k143/kinotower-go/internal/core/server"
	_ "github.com/lib/pq"
)

func main() {
	if err := core_logger.Init("logs"); err != nil {
		panic("failed to init logger: " + err.Error())
	}
	db, err := core_database.NewDatabase()
	if err != nil {
		core_logger.Log.Error("Failed to connect to database", "error", err)
		return
	}
	defer db.Close()
	core_logger.Log.Info("Starting server", "addr", ":8080")

	server := core_server.NewServer(*db)

	if err := server.ListenAndServe(); err != nil {
		core_logger.Log.Error("Server stopped", "error", err)
	}
}
