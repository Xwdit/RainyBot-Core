extends BotAPI #继承自BotAPI类


## RainyBot的Bot类，负责处理与当前使用的机器人后端账号相关的各类功能
class_name Bot


## 获取当前正在使用的机器人后端账号
static func get_id()->int:
	return BotAdapter.get_bot_id()
	

static func is_bot_connected()->bool:
	return BotAdapter.is_bot_connected()
	

static func get_sent_message_count()->int:
	return BotAdapter.sent_message_count


static func get_group_message_count()->int:
	return BotAdapter.group_message_count
	
	
static func get_private_message_count()->int:
	return BotAdapter.private_message_count


static func get_avatar_url()->String:
	return "https://q1.qlogo.cn/g?b=qq&nk=%s&s=640"% get_id()


## 获取当前机器人账号的好友列表，需要与await关键词配合使用
static func get_friend_list(timeout:float=-INF)->MemberList:
	var _result:Dictionary = await BotAdapter.send_bot_request("friendList",null,null,timeout)
	var _arr:Array = _result.get("data",[])
	var _ins:MemberList = MemberList.init_meta(_arr)
	return _ins
	

## 获取当前机器人账号的群组列表，需要与await关键词配合使用
static func get_group_list(timeout:float=-INF)->GroupList:
	var _result:Dictionary = await BotAdapter.send_bot_request("groupList",null,null,timeout)
	var _arr:Array = _result.get("data",[])
	var _ins:GroupList = GroupList.init_meta(_arr)
	return _ins


## 获取当前机器人账号的资料卡，需要与await关键词配合使用
static func get_profile(timeout:float=-INF)->MemberProfile:
	var _result:Dictionary = await BotAdapter.send_bot_request("botProfile",null,null,timeout)
	var _ins:MemberProfile = MemberProfile.init_meta(_result)
	return _ins


## 从当前机器人账号的历史消息缓存中获取指定id的缓存消息，需要与await关键词配合使用
static func get_cache_message(msg_id:int,timeout:float=-INF)->CacheMessage:
	var _req_dic = {
		"id":msg_id
	}
	var _result_dic:Dictionary = await BotAdapter.send_bot_request("messageFromId",null,_req_dic,timeout)
	var ins = CacheMessage.init_meta(_result_dic.get("data",{}))
	return ins
