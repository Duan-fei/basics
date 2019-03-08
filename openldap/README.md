# dokcer-openldap
###

- LDAP（Lightweight Directory Access Protocol）是基于X.500标准的轻量级目录访问协议, 它是基于X.500标准的，但是简单多了并且可以根据需要
定制。与X.500不同，LDAP支持TCP/IP，这对访问Internet是必须的
- LDAP目录以树状的层次结构来存储数据
- LDAP协议的好处就是你公司的所有员工在所有这些工具里共享同一套用户名和密码，来人的时候新增一个用户就能自动访问所有系统，走人的时候一键删除就取消了
他对所有系统的访问权限，这就是LDAP


#### 1. Entry(条目)
**openldap分为两个部分, 其中第一个openldap作为目录访问协议, phpldapadmin作为可视化操作工具**
很庆幸,不需要操作很多命令我们只需要稍微知道一些基本的概念就可以掌握了，OpenLdap的数据存储就好像一棵树。条目，也叫记录项，是LDAP中最基本的颗粒，
就像字典中的词条，或者是数据库中的记录。通常对LDAP的添加、删除、更改、检索都是以条目为基本对象的。

> dc=shannon,dc=com 作为一个树的主干也就是BASE_DN
>
> ou=group 这个代表的一个组
>
> cn=wiki 可以作为为一个具体的人、项目、部门等
>
> 所以一条完整的dn(条目)可能长成这样 dn="cn=duanfei,ou=people,dc=shannon,dc=com"

##

#### 2. Attribute(属性)

每个条目都可以有很多属性（Attribute），比如常见的人都有姓名、地址、电话等属性。每个属性都有名称及对应的值，属性值可以有单个、多个，比如你有多个邮箱。

属性不是随便定义的，需要符合一定的规则，而这个规则可以通过schema制定。比如，如果一个entry没有包含在 inetorgperson 这个 schema 
中的objectClass: inetOrgPerson，那么就不能为它指定employeeNumber属性，因为employeeNumber是在inetOrgPerson中定义的。

LDAP为人员组织机构中常见的对象都设计了属性(比如commonName，surname)。下面有一些常用的别名：

|属性|别名|描述|举例|
|:------|:------|:------|:------|
|commonName|cn|姓名|duanfei|
|surname|sn|姓|duan|
|organizationalUnitName|ou|单位（部门）名称|develop|
|organization|o|组织（公司）名称|Shannon|
|telephoneNumber| |电话号码|15500055555|
|objectClass| |内置属性|account|


##

#### 3.ObjectClass
对象类是属性的集合，LDAP预想了很多人员组织机构中常见的对象，并将其封装成对象类。比如人员（person）含有姓（sn）、名（cn）、
电话(telephoneNumber)、密码(userPassword)等属性，单位职工(organizationalPerson)是人员(person)的继承类，除了上述属性之外还含有职务（title）、邮政编码（postalCode）、通信地址(postalAddress)等属性。

对象类有三种类型：结构类型（Structural）、抽象类型(Abstract)和辅助类型（Auxiliary）
每个条目最少有一个对象类。

**常用的属性**
> account
>
> organizationalUnit
>
> organizationalRole
>
> organizationalPerson
>
> inetOrgPerson
>
> posixGroup
>
> posixAccount


##

#### 4. 运行
ldap默认采用加密传输，端口号为636

在运行之前需要设置一些参数：
> SLAPD_DOMAIN： 这个参数表示的是整个树的基础, 就比如"shannon.com"
>
> SLAPD_PASSWORD： 这个则表示的是管理员的密码
>
> SLAPD_ADDITIONAL_SCHEMAS：表示启用memberof模块, memberof为固定写法

##

#### 5. 挂载
当服务运行之后，暴露了两个文件[data, conf],请保存两个文件，使下次重启容器后恢复所有数据

##

#### 6. 参考资料
> https://github.com/dinkel/docker-openldap
> https://github.com/osixia/docker-openldap
