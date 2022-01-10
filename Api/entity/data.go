package entity

import "gorm.io/gorm"

type Config struct {
	Port uint   `json:"Port"`
	DSN  string `json:"DSN"`
	Env  string `json:"env"`
}

var GlobalConf Config

type User struct {
	gorm.Model
	Name string `gorm:"column:name;not null;type:varchar(128);default:''"`
	Sex  int    `gorm:"column:sex;not null;type:varchar(32);default:''"`
	Addr string `gorm:"column:address;not null;type:varchar(64);default:''"`
}

func (_ User) TableName() string {
	return "user"
}
