package routers

import (
    // _ "github.com/go-swagger/go-swagger"

	"github.com/gin-contrib/static"
	"github.com/gin-gonic/gin"
	"ldap-api/swagger_shannonai"

	"ldap-api/routers/api/v1"

	_ "ldap-api/swagger_shannonai/docs"
)

func InitRouter() *gin.Engine {
	r := gin.Default()
	r.Use(static.Serve("/", static.LocalFile("./assets", true)))
	r.GET("/health", func(c *gin.Context) {
		c.String(200, "I'm ok")
	})
	r.NoRoute(func(c *gin.Context) {
		c.String(404, "Page not found")
	})
	apiV1 := r.Group("/api/v1")
	{
		// 校验用户是否可以登录
		apiV1.GET("/login", v1.LoginLdap)
		r.GET("/swagger/*any", swagger_shannonai.WrapHandler)
	}
	return r
}
