package v1

import (
	"fmt"
	"github.com/gin-gonic/gin"
	"gopkg.in/ldap.v3"
	"ldap-api/pkg/e"
	"ldap-api/pkg/util"
	"net/http"

	"ldap-api/pkg/app"

    . "ldap-api/common"
)


// swagger:parameters login_ldap
type BarSliceParam struct {
	// 需要进行登录验证的uid
	//
	// Required: true
	// in: query
	Username string `json:"username"`
	// 需要进行登录验证的密码
	//
	// Required: true
	// in: query
	Password string `json:"password"`
}

// 对用户进行验证，验证成功即可登陆
func LoginLdap(c *gin.Context) {
	 // swagger:route GET /login login login_ldap
	 //
	 // ldap账号登录验证.
	 //
	 // 对ldap进行验证，正确返回时，会得到200和OK
	 //
	 //     Responses:
	 //		  200: ldap_response
	 // 	  400: ldap_response

	appG := app.Gin{C: c}
	username := c.Query("username")
	password := c.Query("password")
    baseDN := Config.Ldap.BaseDN

	if username == "" ||  password == ""{
		appG.Response(http.StatusBadRequest, e.INVALID_PARAMS, nil)
		return
	}

	l := util.BindLDAP()
	searchRequest := ldap.NewSearchRequest(
		// 这里是 basedn，我们将从这个节点开始搜索
		baseDN,
		// 这里几个参数分别是 scope, derefAliases, sizeLimit, timeLimit,  typesOnly
		ldap.ScopeWholeSubtree, ldap.NeverDerefAliases, 0, 0, false,
		// 这里是 LDAP 查询的 Filter, username 即我们需要认证的用户名
		fmt.Sprintf("(&(objectClass=organizationalPerson)(uid=%s))", username),
		// 这里是查询返回的属性，以数组形式提供。如果为空则会返回所有的属性
		[]string{"dn"},
		nil,
	)
	sr, err := l.Search(searchRequest)
	if err != nil {
		appG.Response(http.StatusBadRequest, e.ERROR_UNKNOWN, nil)
		return
	}
	if len(sr.Entries) != 1 {
		appG.Response(http.StatusBadRequest, e.ERROR_NOT_EXIST_DN, nil)
		return
	}
	userDN := sr.Entries[0].DN

	// Bind as the user to verify their password
	// 拿这个 dn 和他的密码去做 bind 验证
	err = l.Bind(userDN, password)
	if err != nil {
		appG.Response(http.StatusBadRequest, e.ERROR_WRONG_PASSWORD, nil)
		return
	}
	l.Close()
	appG.Response(http.StatusOK, e.SUCCESS, nil)
	return
}

