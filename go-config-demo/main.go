package main

import (
	"fmt"
	"net/http"
)

func main() {
	config := LoadConfig()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "AppName: %s\nPort: %s\nDBHost: %s\nDBPort: %s\n",
			config.AppName,
			config.Port,
			config.DBHost,
			config.DBPort,
		)
	})

	fmt.Println("server start on port:", config.Port)
	http.ListenAndServe(":"+config.Port, nil)
}