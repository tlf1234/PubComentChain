package web

import (
	"github.com/go-chi/render"
	"github.com/tlf1234/PubComentChain/Api/entity"
	"github.com/tlf1234/PubComentChain/Api/response"
	"gorm.io/gorm"
	"net/http"
)

type userApiController struct {
	MysqlDao *gorm.DB
}

// RepairQuery
// Show godoc
// @Summary 用户信息
// @Accept  json
// @Produce  json
// @Success 200 {object} response.Response
// @Failure 404 {object} Error
// @Failure 500 {object} Error
// @Router /api/user/userInfo [get]
func (ctr userApiController) UserInfo(w http.ResponseWriter, r *http.Request) {
	var (
		address string
	)
	params := r.URL.Query()
	if _, ok := params["address"]; ok {
		address = params["symbol"][0]
	}
	if address == "" {
		render.JSON(w, r, response.Response{Code: 1, Msg: "param error."})
	}
	var user entity.User
	ctr.MysqlDao.Model(&entity.User{}).Where("address=?", address).First(&user)
	if user.ID > 0 {
		render.JSON(w, r, response.Response{Data: user})
		return
	}
	render.JSON(w, r, response.Response{Code: 1, Msg: "param error."})
}
