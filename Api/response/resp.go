package response

type Movie struct {
	Id           uint    `json:"id"`
	Name         string  `json:"name"`
	Type         string  `json:"type"`
	DirectorCast string  `json:"directorCast"`
	Desc         string  `json:"desc"`
	PeopleNum    uint    `json:"peopleNum"`
	PrizePool    float64 `json:"prizePool"`
	Heat         float32 `json:"heat"`
	Score        float32 `json:"score"`
	EndTime      string  `json:"endTime"`
}

type MoviePageResult struct {
	List     []Movie `json:"list"`
	Total    int64   `json:"total"`
	CurPage  int     `json:"curPage"`
	PageSize int     `json:"pageSize"`
}

type Comment struct {
	Id         uint    `json:"id"`
	UserId     int     `json:"userId"`
	MovieId    int     `json:"movieId"`
	Comment    string  `json:"comment"`
	EvaScore   float64 `json:"evaScore"`
	VoteNum    int     `json:"voteNum"`
	OpposeNum  int     `json:"opposeNum"`
	CreateTime string  `json:"createTime"`
}

type CommentPageResult struct {
	List     []Comment `json:"list"`
	Total    int64     `json:"total"`
	CurPage  int       `json:"curPage"`
	PageSize int       `json:"pageSize"`
}
