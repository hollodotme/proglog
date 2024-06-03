package main

import (
	"github.com/hollodotme/proglog/internal/server"
	"log"
)

func main() {
	srv := server.NewHTTPServer(":8085")
	log.Fatal(srv.ListenAndServe())
}
