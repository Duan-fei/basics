package main

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"os"
	"strconv"
	"strings"

	. "ldap-api/common"
	. "ldap-api/util"

	"ldap-api/routers"
)

func init() {
	if strings.EqualFold(Config.Log.Level, "DEBUG") {
		gin.SetMode(gin.DebugMode)
	} else {
		gin.SetMode(gin.ReleaseMode)
		if logfile, err := os.Create(Config.Gin.Logfile); err != nil {
			Logger.Fatal("create gin log file failed. ", err)
		} else {
			gin.DefaultWriter = logfile
		}
	}
}

func main() {
	router := routers.InitRouter()
	if router == nil {
		Logger.Fatal("got nil router")
		os.Exit(2)
	}
	fmt.Println("Listening on", Config.Port)
	err := router.Run(":" + strconv.Itoa(Config.Port))
	if err != nil {
		Logger.Fatal(err)
	}
}
