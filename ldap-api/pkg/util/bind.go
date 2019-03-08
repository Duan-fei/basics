package util

import (
	"crypto/tls"
	"fmt"
	"gopkg.in/ldap.v3"
	"log"

	. "ldap-api/common"
)

func BindLDAP() *ldap.Conn {

	// 用来获取查询权限的 bind 用户
	BindUsername := Config.Ldap.BindDN
	BindPassword := Config.Ldap.BindPW

	l, err := ldap.Dial("tcp", fmt.Sprintf("%s:%d", Config.Ldap.BindAddr, Config.Ldap.BindPort))
	if err != nil {
		log.Fatal(err)
	}
	//defer l.Close()

	// Reconnect with TLS
	err = l.StartTLS(&tls.Config{InsecureSkipVerify: true})
	if err != nil {
		log.Fatal(err)
	}

	// First bind with a read only user
	err = l.Bind(BindUsername, BindPassword)
	if err != nil {
		log.Fatal(err)
	}
	return l
}
