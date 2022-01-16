package entity

import (
	"gorm.io/gorm"
	"time"
)

type Config struct {
	Port uint   `json:"Port"`
	DSN  string `json:"DSN"`
	Env  string `json:"env"`
}

var GlobalConf Config

type User struct {
	gorm.Model
	Name      string `gorm:"column:name;not null;type:varchar(128);default:''"`
	NickName  string `gorm:"column:nick_name;not null;type:varchar(128);default:''"`
	Sex       int    `gorm:"column:sex;not null;type:int(10);"`
	Address   string `gorm:"column:address;not null;type:varchar(64);default:'';uniqueIndex:idx_addr"`
	Birthdate string `gorm:"column:birthdate;not null;type:varchar(64);default:''"`
}

func (_ User) TableName() string {
	return "user"
}

type Movie struct {
	gorm.Model
	Name         string    `gorm:"column:name;not null;type:varchar(128);default:'';uniqueIndex:idx_name"`
	Pic          string    `gorm:"column:pic;type:longtext;"`
	Type         string    `gorm:"column:type;not null;type:varchar(128);default:''"`
	DirectorCast string    `gorm:"column:director_cast;not null;type:varchar(128);default:'';comment:'导演演员'"`
	Desc         string    `gorm:"column:type;not null;desc:varchar(128);default:'';comment:'概要'"`
	PeopleNum    uint      `gorm:"column:people_num;not null;type:int(16);default:0"`
	PrizePool    float64   `gorm:"column:prize_pool;not null;type:decimal(64,18);default:0.00"`
	Heat         float32   `gorm:"column:heat;not null;type:decimal(32,2);default:0.00;comment:'热度'"`
	Score        float32   `gorm:"column:score;not null;type:decimal(32,2);default:0.00;comment:'热度'"`
	EndTime      time.Time `gorm:"column:end_time;not null;type:datetime;"`
}

func (_ Movie) TableName() string {
	return "movie"
}

type TransactionRecord struct {
	gorm.Model
	UserId   int     `gorm:"column:people_num;not null;type:int(16);"`
	UserAddr string  `gorm:"column:user_addr;not null;type:varchar(128);default:''"`
	Number   float64 `gorm:"column:number;not null;type:decimal(64,18);default:0.00;comment:'数量'"`
	ToAddr   string  `gorm:"column:to_addr;not null;type:varchar(128);default:''"`
}

func (_ TransactionRecord) TableName() string {
	return "transaction_record"
}

type Comment struct {
	gorm.Model
	UserId    int     `gorm:"column:user_id;not null;type:int(16);"`
	Address   string  `gorm:"column:address;not null;type:varchar(128);default:'';"`
	MovieId   int     `gorm:"column:movie_id;not null;type:int(16);"`
	Comment   string  `gorm:"column:number;type:longtext;comment:'数量'"`
	EvaScore  float64 `gorm:"column:to_addr;not null;type:decimal(64,18);default:0.00;comment:'评分'"`
	VoteNum   int     `gorm:"column:to_addr;not null;type:int(16);default:0;comment:'投票数'"`
	OpposeNum int     `gorm:"column:to_addr;not null;type:int(16);default:0;comment:'反对数'"`
}

func (_ Comment) TableName() string {
	return "comment"
}
