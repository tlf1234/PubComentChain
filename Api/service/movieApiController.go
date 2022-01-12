package web

import (
	"github.com/go-chi/render"
	"github.com/tlf1234/PubComentChain/Api/entity"
	"github.com/tlf1234/PubComentChain/Api/response"
	"gorm.io/gorm"
	"net/http"
	"strconv"
)

type movieApiController struct {
	MysqlDao *gorm.DB
}

// RepairQuery
// Show godoc
// @Summary 电影信息
// @Accept  json
// @Produce  json
// @Success 200 {object} response.Response
// @Failure 404 {object} Error
// @Failure 500 {object} Error
// @Router /api/user/userInfo [get]
func (ctr movieApiController) movieInfo(w http.ResponseWriter, r *http.Request) {
	var (
		id string
	)
	params := r.URL.Query()
	if _, ok := params["id"]; ok {
		id = params["id"][0]
	}
	if id == "" {
		render.JSON(w, r, response.Response{Code: 1, Msg: "param error."})
		return
	}
	var movie entity.Movie
	ctr.MysqlDao.Model(&entity.Movie{}).Where("id=?", id).First(&movie)
	if movie.ID > 0 {
		movie := response.Movie{
			Id:           movie.ID,
			Name:         movie.Name,
			Type:         movie.Type,
			DirectorCast: movie.DirectorCast,
			Desc:         movie.Desc,
			PeopleNum:    movie.PeopleNum,
			PrizePool:    movie.PrizePool,
			Heat:         movie.Heat,
			Score:        movie.Score,
			EndTime:      movie.EndTime.Format("2006-01-02 15:04:05"),
		}
		render.JSON(w, r, response.Response{Data: movie})
		return
	}
	render.JSON(w, r, response.Response{Code: 1, Msg: "param error."})
}

// RepairQuery
// Show godoc
// @Summary 电影列表
// @Accept  json
// @Produce  json
// @Param query query string true "查询key"
// @Param page query int true "页码"
// @Param pageSize query int true "每页数据"
// @Success 200 {object} response.ElectricPageResult
// @Failure 404 {object} Error
// @Failure 500 {object} Error
// @Router /api/repair/repairQuery [get]
func (ctr movieApiController) MoviePageList(w http.ResponseWriter, r *http.Request) {
	params := r.URL.Query()
	var (
		page     int
		pageSize int
		query    string
	)
	page, pageSize = 1, 10
	r.ParseForm()
	if _, ok := params["query"]; ok {
		query = params["query"][0]
	}
	if _, ok := params["page"]; ok {
		page, _ = strconv.Atoi(params["page"][0])
		if page <= 0 {
			page = 1
		}
	}
	if _, ok := params["pageSize"]; ok {
		pageSize, _ = strconv.Atoi(params["pageSize"][0])
		if pageSize <= 0 {
			pageSize = 10
		}
	}
	chain := ctr.MysqlDao.Model(&entity.Movie{})
	totalChain := ctr.MysqlDao.Model(&entity.Movie{})
	if query != "" {
		chain = chain.Where("name like ? or director_cast like ? or type like ?",
			"%"+query+"%", "%"+query+"%", "%"+query+"%")
		totalChain = totalChain.Where("name like ? or director_cast like ? or type like ?",
			"%"+query+"%", "%"+query+"%", "%"+query+"%")
	}
	var movies []entity.Movie
	chain.Offset((page - 1) * pageSize).Limit(pageSize).Find(&movies)
	var count int64
	totalChain.Count(&count)
	var movieList []response.Movie
	for _, item := range movies {
		movie := response.Movie{
			Id:           item.ID,
			Name:         item.Name,
			Type:         item.Type,
			DirectorCast: item.DirectorCast,
			Desc:         item.Desc,
			PeopleNum:    item.PeopleNum,
			PrizePool:    item.PrizePool,
			Heat:         item.Heat,
			Score:        item.Score,
			EndTime:      item.EndTime.Format("2006-01-02 15:04:05"),
		}
		movieList = append(movieList, movie)
	}
	response := response.MoviePageResult{
		List:     movieList,
		Total:    count,
		CurPage:  page,
		PageSize: pageSize,
	}
	render.JSON(w, r, response)

}
