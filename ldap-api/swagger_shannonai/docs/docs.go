package docs

import (
	"bytes"
	"github.com/alecthomas/template"
	"io/ioutil"
	//"github.com/swagger_shannonai/swag"
	"ldap-api/swagger_shannonai/swag"
)

type swaggerInfo struct {
	Version     string
	Host        string
	BasePath    string
	Title       string
	Description string
}

// SwaggerInfo holds exported Swagger Info so clients can modify it
var SwaggerInfo swaggerInfo

type s struct{}

func (s *s) ReadDoc() string {
	content, err := ioutil.ReadFile("swagger.yaml")
	if err != nil {
		panic("read config file failed")
	}
	doc := string(content)
	t, err := template.New("swagger_info").Parse(doc)
	if err != nil {
		return doc
	}

	var tpl bytes.Buffer
	if err := t.Execute(&tpl, SwaggerInfo); err != nil {
		return doc
	}

	return tpl.String()
}

func init() {
	swag.Register(swag.Name, &s{})
}
