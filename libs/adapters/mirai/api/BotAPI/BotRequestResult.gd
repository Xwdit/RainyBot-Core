extends BotAPI


## RainyBot的协议后端请求结果类，记录了向协议后端发送的某次请求/命令的结果数据
class_name BotRequestResult


## 请求结果的状态码，可用于对比判断请求结果的当前状态
enum StatusCode{
	SUCCESS, ##请求成功
	WRONG_VERIFY_KEY, ##验证密钥错误
	BOT_NOT_EXIST, ##请求的Bot不存在
	SESSION_INVALID, ##会话无效
	SESSION_NOT_ACTIVE, ##会话未活跃
	TARGET_NOT_EXIST, ##目标不存在
	FILE_NOT_EXIST, ##文件不存在
	NO_PERMISSION = 10, ##没有权限
	BOT_MUTED = 20, ##机器人被禁言
	MESSAGE_TOO_LONG = 30, ##消息长度超限
	WRONG_USAGE = 400, ##命令用法有误
	FAILED = 500 ##请求失败或超时
}


var data_dic:Dictionary = {
	"code":int(StatusCode.FAILED),
	"msg":"",
	"messageId":-1
}


## 通过机器人协议后端的元数据数组构造一个BotRequestResult类的实例，仅当你知道自己在做什么时才使用
static func init_meta(dic:Dictionary)->BotRequestResult:
	if !dic.is_empty() and dic.has("code"):
		var ins:BotRequestResult = BotRequestResult.new()
		ins.data_dic = dic
		return ins
	else:
		return null


## 获取实例中的元数据字典，仅当你知道自己在做什么时才使用
func get_metadata()->Dictionary:
	return data_dic


## 使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用
func set_metadata(dic:Dictionary)->void:
	if !dic.is_empty() and dic.has("code"):
		data_dic = dic


## 返回请求结果的状态码
func get_status_code()->int:
	return data_dic.code
	

## 返回请求结果的状态信息文本
func get_status_msg()->String:
	return data_dic.msg
	

## 返回请求结果对应的消息ID
func get_message_id()->int:
	if data_dic.has("messageId"):
		return data_dic.messageId
	return 0


## 返回请求结果是否为成功
func is_success()->bool:
	return get_status_code() == int(StatusCode.SUCCESS)


## 判断请求结果是否为指定的结果
func is_status(code:int)->bool:
	return get_status_code() == code
