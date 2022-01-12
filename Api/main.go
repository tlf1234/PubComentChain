package main

import (
	"flag"
	"github.com/jinzhu/configor"
	"github.com/tlf1234/PubComentChain/Api/entity"
	"log"

	web "github.com/tlf1234/PubComentChain/Api/service"
	"os"
)

// @title PubComentChain API
// @version 1.0
// @BasePath /
func main() {
	var (
		file = flag.String("c", "config.json", "configuration file")
	)
	entity.GlobalConf = entity.Config{}

	flag.Parse()

	if err := configor.Load(&entity.GlobalConf, *file); err != nil {
		log.Printf("Failed to unmarshal config file, got %v\n", err)
		os.Exit(1)
	}




	webConf := web.Config{
		Port: 7777,
	}

	web.Start(&webConf)
}
