# self-service-password
###

- self-service-password的一套可视化自主密码修改服务


#### 1. 介绍
为了解放管理员的工作，让OpenLDAP用户可以自行进行密码的修改和重置，就需要我们来搭建一套自助修改密码系统。
我们使用的是开源的基于php语言开发的ldap自助修改密码系统Self Service Password


#### 2. 配置
在运行之前需要设置一些参数：
> LDAP_SERVICE： 连接ldap服务的地址，需要将地址和端口同时写出，如：ldaps/ldap://localhost:389/636
>
> LDAP_BINDDN： 连接ldap服务的DN，一般为admin，如cn=admin,dc=example,dc=com
>
> LDAP_BINDPW： 连接ldap服务的DN的密码，如：qwer1234
>
> LDAP_BASEDN： 设置连接的ldap的base路径，如dc=shannon,dc=com
> 
> LDAP_LOGIN_ATTR： 设置人员登录的属性，一般为cn或者uid
> 
> LDAP_FILTER： 设置ldap的过滤条件，如(\&(objectClass=inetOrgPerson)(cn={login}))，需要注意一点“&”需要转义所以需要加上"\"
>
> DEBUG： 调试模式，默认一般为false

ps：需要特别注意一点，设置参数的时候一定要将参数用""包起来

运行之后需要登陆的网址:
>> http://server:8888/ssp/


#### 3.参考文档
1. https://ltb-project.org/start

