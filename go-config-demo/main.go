package main

import (
	"fmt"
	"net/http"
	"os"
)

func main() {
	config := LoadConfig()

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		hostname, _ := os.Hostname()

		fmt.Fprintf(w,
			"AppName: %s\nPort: %s\nDBHost: %s\nDBPort: %s\nHostname: %s\n",
			config.AppName,
			config.Port,
			config.DBHost,
			config.DBPort,
			hostname,
		)
	})

	fmt.Println("server start on port:", config.Port)

	if err := http.ListenAndServe(":"+config.Port, nil); err != nil {
		fmt.Println("server error:", err)
	}
}