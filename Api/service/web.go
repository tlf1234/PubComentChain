package web

import (
	"fmt"
	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
	"github.com/tlf1234/PubComentChain/Api/entity"
	"github.com/tlf1234/PubComentChain/Api/utils/logger"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"log"
	"net/http"
)

// Config web interface configuration
type Config struct {
	Port uint `default:"8000"`
	DSN  string
}

// Start start web interface
func Start(config *Config) error {

	r := chi.NewRouter()

	r.Use(middleware.URLFormat)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)

	db, err := gorm.Open(mysql.Open(config.DSN), &gorm.Config{})
	if err != nil {
		logger.Error("failed to connect database, got error: %v", err)
	} else {
		db.AutoMigrate(&entity.User{})
	}

	r.Route("/api/user", func(r chi.Router) {
		userApiCtr := userApiController{MysqlDao: db}
		r.Get("/userInfo", userApiCtr.userInfo)
	})

	log.Printf("Admin listening on :%v...", config.Port)
	return http.ListenAndServe(fmt.Sprintf(":%v", config.Port), r)
}
