package e

var MsgFlags = map[int]string {
	SUCCESS : "OK",
	ERROR : "FAIL",
	INVALID_PARAMS : "请求参数错误或缺失",
	ERROR_NOT_EXIST_DN : "用户不存在或存在多个",
	ERROR_WRONG_PASSWORD : "用户密码错误",
	ERROR_UNKNOWN : "未知错误",
}

func GetMsg(code int) string {
	msg, ok := MsgFlags[code]
	if ok {
		return msg
	}
	return MsgFlags[ERROR]
}