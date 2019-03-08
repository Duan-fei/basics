## ServiceName: LDAP-API
基于Gin， ldap独立认证系统

## 请求方式:
- http://localhost:port/api/v1/login?username=xxx&password=xxx

## 数据卷:
- ./logs:/home/work/logs
- ./assets:/home/work/assets
- ./config.yaml:/home/work/config.yaml

> index.html, js 等静态文件要放在public中, 目录结构:
> ```
> /public
>       /index.html
>       /static/style.css
>       /static/script.js
> ```
