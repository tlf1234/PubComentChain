package web

import (
	"github.com/go-chi/render"
	"github.com/tlf1234/PubComentChain/Api/entity"
	"github.com/tlf1234/PubComentChain/Api/response"
	"gorm.io/gorm"
	"net/http"
	"strconv"
)

type commentApiController struct {
	MysqlDao *gorm.DB
}

// RepairQuery
// Show godoc
// @Summary 创建评论
// @Accept  json
// @Produce  json
// @Param userId query string true "userId"
// @Param movieId query string true "movieId"
// @Param address query string true "address"
// @Param comment query int true "评论"
// @Success 200 {object} response.CommentPageResult
// @Failure 404 {object} Error
// @Failure 500 {object} Error
// @Router /api/comment/create [post]
func (ctr commentApiController) Create(w http.ResponseWriter, r *http.Request) {
	r.ParseForm()
	address := r.Form.Get("address")
	comment := r.Form.Get("comment")
	movieId := r.Form.Get("movieId")

	movieIdInt, _ := strconv.Atoi(movieId)

	if movieIdInt == 0 || comment == "" || address == "" {
		result := response.Response{Code: 1, Msg: "参数错误"}
		render.JSON(w, r, result)
		return
	}
	com := entity.Comment{
		Address: address,
		Comment: comment,
		MovieId: movieIdInt,
	}
	ctr.MysqlDao.Create(&com)
	result := response.Response{}
	render.JSON(w, r, result)

}

// RepairQuery
// Show godoc
// @Summary 评论列表
// @Accept  json
// @Produce  json
// @Param movieId query string true "movieId"
// @Param page query int true "页码"
// @Param pageSize query int true "每页数据"
// @Success 200 {object} response.CommentPageResult
// @Failure 404 {object} Error
// @Failure 500 {object} Error
// @Router /api/comment/pageListQuery [get]
func (ctr commentApiController) CommentPageList(w http.ResponseWriter, r *http.Request) {
	params := r.URL.Query()
	var (
		page     int
		pageSize int
		movieId  string
	)
	page, pageSize = 1, 10
	r.ParseForm()
	if _, ok := params["movieId"]; ok {
		movieId = params["movieId"][0]
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
	chain := ctr.MysqlDao.Model(&entity.Comment{})
	totalChain := ctr.MysqlDao.Model(&entity.Comment{})
	if movieId != "" {
		chain = chain.Where("movie_id = ?",
			movieId)
		totalChain = totalChain.Where("movie_id = ?",
			movieId)
	}
	var comments []entity.Comment
	chain.Offset((page - 1) * pageSize).Limit(pageSize).Find(&comments)
	var count int64
	totalChain.Count(&count)
	var commentList []response.Comment
	for _, item := range comments {
		comment := response.Comment{
			Id:         item.ID,
			Comment:    item.Comment,
			MovieId:    item.MovieId,
			EvaScore:   item.EvaScore,
			VoteNum:    item.VoteNum,
			OpposeNum:  item.OpposeNum,
			CreateTime: item.CreatedAt.Format("2006-01-02 15:04:05"),
		}
		commentList = append(commentList, comment)
	}
	response := response.CommentPageResult{
		List:     commentList,
		Total:    count,
		CurPage:  page,
		PageSize: pageSize,
	}
	render.JSON(w, r, response)

}
