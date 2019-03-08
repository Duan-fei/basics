# dokcer-openvpn
---

- 此openvpn采用连接openldap方式登陆或者账号密码形式
- 采用统一客户端配置文件
- 可以自定义配置文件server.conf以及client.conf

---
#### **1. 参数的说明**
```
- AUTH_TYPE --采用哪种形式使用openvpn(如: "plain"使用账号密码，"openldap"使用openldap方式登入)
# openvpn配置
- OPENVPN_SERVER   --服务的服务地址以及分发给客户端的地址, 前面为ip地址后面为掩码, 以空格分隔. VPN网络使用的网段要避免和本地网段冲突.
- PUSH  --允许客户端访问的服务器地址(如: 172.31.0.0 255.255.0.0)
- CLIENTREMOTE --客户端需要连接的服务器端地址(如: 55.10.123.57)

# 配置连接ldap服务
- LDAP_SERVICE_URL  --访问的ldap服务器地址(如：ldap://ldap.example.com)
- LDAP_BIND_DN  --连接ldap的bind_dn(如："cn=admin,dc=example,dc=com")
- LDAP_PASSWORD  -- 连接ldap的bind_password(如："123456")
- LDAP_TLS --是否需要tls连接(如："yes" or "no")
- LDAP_BASE_DN  --搜索人员的路径(如："ou=users,dc=example,dc=com")
- LDAP_SEARCH_FILTER  --查询人员的条件(如："(uid=%u)")
- TLS_REQCERT  --设置ldap校验证书等级(如："never")

# 生成openvpn所需要的证书
- KEY_COUNTRT ——定义所在的国家(如: CN, 此变量需要注意长度一般为2位)
- KEY_PROVINCE ——定义所在的省份(如: BJ, 此变量需要注意长度一般为2位)
- KEY_CITY ——定义所在的城市(如: Beijing)
- KEY_ORG ——定义所在的组织(如: example)
- KEY_EMAIL ——定义邮箱地址(如: contact@example.com)
- KEY_OU ——定义所在的单位(如: example.inf)
- KEY_SIZE ——定义生成私钥的大小(一般为1024或者2048)
```

#### **2. 运行方式**
进入openvpn
> \$ docker built -t openvpn .  
> \$ docker-compose up -d 

**因需要生成证书等配置文件所以可能会需要等待3~5分钟**

#### **3. 其他**
```
# 如果采用账号密码
- 只需修改挂载的文件中的password添加账号密码即可连接(xxxx xxxx)
- 前为账号 后面为密码 以空格进行分隔

# 如果使用openldap
- 需要搭建起自己的ldap服务
```
#### **4. 示例**
如果在vagrant中运行openvpn, vagrant 虚拟机的内网网段是 10.0.2.0/24, 公网IP是 192.168.33.10, VPN 网络的网段是 172.19.0.0/16, 则对应的 docker-compose.yml 如下:

```shell
version: '3.2'
services:
    openvpn:
        image: openvpn
        container_name: openvpn
        network_mode: host
        restart: always
        volumes:
            - ./data:/etc/openvpn
        ports:
            - "1194"
        cap_add:
            - NET_ADMIN
        environment:
            AUTH_TYPE: "true"
            OPENVPN_SERVER: "172.17.0.0 255.255.0.0"  
            PUSH: "172.35.0.0 255.255.0.0"  
            CLIENTREMOTE: "192.168.0.1"  
            LDAP_SERVICE_URL: "ldap://0.0.0.0:389"
            LDAP_BIND_DN: "cn=admin,dc=example,dc=com"
            LDAP_PASSWORD: "123456"
            LDAP_TLS: "yes"
            LDAP_BASE_DN: "ou=users,dc=shannonai,dc=com"
            LDAP_SEARCH_FILTER: "(uid=%u)"
            TLS_REQCERT: "never"
            KEY_COUNTRY: "CN"  # The state abbreviations(for example: CN)
            KEY_PROVINCE: "BJ"  # Province shorthand(for example: BJ)
            KEY_CITY: "BeiJing"  # City(for example: BeiJing)
            KEY_ORG: "example INC"  # organisation(for example: shannon.ai)
            KEY_OU: "example.com"  # affiliated unit(for example: shannon.ai)
            KEY_EMAIL: "contact@example.com"  # Email(for example: contact@shannonai.com)
            KEY_SIZE: "1024"  # The private key size(for example: 2048)


```
