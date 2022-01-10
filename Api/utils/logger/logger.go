package logger

import (
	"log"
)

// Info print log message
func Info(msg string, args ...interface{}) {
	log.Printf("[info] "+msg, args...)
}

// Warn print warn message
func Warn(msg string, args ...interface{}) {
	log.Printf("[warn] "+msg, args...)
}

// Debug print debug message
func Debug(msg string, args ...interface{}) {
	log.Printf("[debug] "+msg, args...)
}

// Error print error log
func Error(msg string, args ...interface{}) {
	log.Printf("[error] "+msg, args...)


}

