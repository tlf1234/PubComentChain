package response

type Response struct {
	Code int         `json:"code" example:"0"`
	Msg  string      `json:"msg" example:"成功"`
	Data interface{} `json:"data"`
}

