package app

import (
	"github.com/gin-gonic/gin"

	"ldap-api/pkg/e"
)

type Gin struct {
	C *gin.Context
}

// 返回结果
// swagger:response ldap_response
type SwaggerWapper struct {
	// The error message
	// in: body
	Body Response
}

type Response struct {
	// 返回的code码
	// Required: true
	Code int         `json:"code"`
	// 返回的message
	// Required: true
	Msg  string      `json:"msg"`
	// 返回的数据
	// Required: false
	Data interface{} `json:"data"`
}

func (g *Gin) Response(httpCode, errCode int, data interface{}) {
	g.C.JSON(httpCode, Response{
		Code: httpCode,
		Msg: e.GetMsg(errCode),
		Data: data,
	})
	return
}
