extends RoleAPI


##
## RainyBot的其它客户端类，通常代表一个对应实例，实现了用于与其他客户端进行交互的各类功能
##
## 这是RainyBot的其它客户端类，通常代表一个对应实例，实现了用于与其他客户端进行交互的各类功能
## 其他客户端的概念，指如当机器人后端使用手机协议登陆时，平板/PC/智能手表端此时即为其他客户端
##
class_name OtherClient


var data_dic:Dictionary = {
	"id": -1,
	"platform": ""
}


## 手动构造一个OtherClient类的实例，用于主动进行与其他客户端的交互时使用
static func init()->OtherClient:
	var ins:OtherClient = OtherClient.new()
	ins.data_dic["id"] = BotAdapter.get_bot_id()
	return ins
	

## 通过机器人协议后端的元数据字典构造一个OtherClient类的实例，仅当你知道自己在做什么时才使用
static func init_meta(dic:Dictionary)->OtherClient:
	var ins:OtherClient = OtherClient.new()
	ins.data_dic = dic
	return ins


## 获取实例中的元数据字典，仅当你知道自己在做什么时才使用
func get_metadata()->Dictionary:
	return data_dic


## 使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用
func set_metadata(dic:Dictionary):
	data_dic = dic
	

## 获取实例中其他客户端的客户端id
func get_id()->int:
	return data_dic.id
	

## 获取实例中其他客户端的平台名(如"Windows")
func get_platform()->String:
	return data_dic.platform


## 向其它客户端发送单条Message类实例的消息,第二个参数为需要引用回复的消息id(可选)
## 配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态
func send_message(msg,quote_msgid:int=-1)->BotRequestResult:
	var _chain = []
	if msg is String:
		_chain.append(BotCodeMessage.init(msg).get_metadata())
	elif msg is Message:
		_chain.append(msg.get_metadata())
	elif msg is MessageChain:
		_chain = msg.get_metadata()
	elif msg is Array:
		_chain = MessageChain.init(msg).get_metadata()
	var _req_dic = {
		"target":get_id(),
		"messageChain":_chain,
		"quote":quote_msgid if quote_msgid != -1 else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendFriendMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


## 向其它客户端发送一个戳一戳消息
## 配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态
func send_nudge()->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"subject":get_id(),
		"kind":"Friend"
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendNudge",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
