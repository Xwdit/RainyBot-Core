extends MemberAPI


## RainyBot的个体成员类，通常代表一个对应实例，实现了用于与好友或单向好友(陌生人)进行交互的各类功能
##
## 这是RainyBot的个体成员类，通常代表一个对应实例，实现了用于与好友或单向好友(陌生人)进行交互的各类功能
## 绝大部分与好友/单向好友(陌生人)直接相关的操作都可以通过此类来进行
class_name Member


## 这是代表了个体成员类型的枚举，在进行类型判断相关操作时可用于对比
## 如"get_role() == Member.Role.FRIEND"可判断个体成员是否为好友
enum Role{
	FRIEND, #代表个体成员的类型为好友
	STRANGER #代表个体成员的类型为单向好友(陌生人)
}


var data_dic:Dictionary = {
	"id":-1,
	"nickname":"",
	"remark":""
}

var member_role:= Role.FRIEND


## 手动构造一个Member类的实例，用于主动进行与个体成员的交互时使用
## 需要传入的参数分别为个体成员的ID，个体成员的类型(可选，默认为Member.Role.FRIEND)
static func init(member_id:int,role:int=Role.FRIEND)->Member:
	var ins:Member = Member.new()
	var dic:Dictionary = ins.data_dic
	dic.id = member_id
	ins.member_role = role
	return ins
	

## 通过机器人协议后端的元数据字典构造一个Member类的实例，仅当你知道自己在做什么时才使用
static func init_meta(dic:Dictionary,role:int=Role.FRIEND)->Member:
	var ins:Member = Member.new()
	ins.data_dic = dic
	ins.member_role = role
	return ins


## 获取实例中的元数据字典，仅当你知道自己在做什么时才使用
func get_metadata()->Dictionary:
	return data_dic


## 使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用
func set_metadata(dic:Dictionary):
	data_dic = dic


## 获取个体成员实例的类型，将返回一个对应Role枚举的整数值
## 若为手动构造的实例，将始终返回0
func get_role()->int:
	return member_role
	

## 设置个体成员实例的类型
func set_role(role:int):
	member_role = role


## 判断个体成员实例是否为某类型
func is_role(role:int)->bool:
	return role == get_role()


## 获取个体成员实例的ID
func get_id()->int:
	return data_dic.id


## 获取个体成员实例的名称(昵称)，若为手动构造的实例，将始终返回空字符串
func get_name()->String:
	return data_dic.nickname
	

## 获取个体成员实例的备注，若为手动构造的实例，将始终返回空字符串
func get_remark()->String:
	return data_dic.remark
	
	
func get_avatar_url()->String:
	return "https://q1.qlogo.cn/g?b=qq&nk=%s&s=640"% get_id()
	

## 获取个体成员实例相关资料的MemberProfile实例，需要配合await关键字使用
func get_profile(timeout:float=-INF)->MemberProfile:
	var _req_dic = {
		"target":get_id(),
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("friendProfile",null,_req_dic,timeout)
	var _ins:MemberProfile = MemberProfile.init_meta(_result)
	return _ins


## 向个体成员实例发送单条继承于Message类的消息的实例，同时可指定一个需要引用回复的消息ID
## 配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态
func send_message(msg,quote_msgid:int=-1,timeout:float=-INF)->BotRequestResult:
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
	var _result:Dictionary = await BotAdapter.send_bot_request("sendFriendMessage",null,_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


## 向个体成员实例发送一个戳一戳消息
## 配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态
func send_nudge(timeout:float=-INF)->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"subject":get_id(),
		"kind":"Friend" if member_role == Role.FRIEND else "Stranger"
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendNudge",null,_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


## 解除与个体成员实例的好友/单向好友关系
## 配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态
func delete_friend(timeout:float=-INF)->BotRequestResult:
	var _req_dic = {
		"target":get_id()
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("deleteFriend",null,_req_dic,timeout)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
