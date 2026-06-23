package main

import "os"

type AppConfig struct {
	AppName string
	Port    string
	DBHost  string
	DBPort  string
}

func LoadConfig() AppConfig {
	return AppConfig{
		AppName: getEnv("APP_NAME", "go-config-demo"),
		Port:    getEnv("APP_PORT", "8080"),
		DBHost:  getEnv("DB_HOST", "localhost"),
		DBPort:  getEnv("DB_PORT", "3306"),
	}
}

func getEnv(key string, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}