extends BotAPI #继承自BotAPI类


## RainyBot的Bot类，负责处理与当前使用的机器人后端账号相关的各类功能
class_name Bot


## 获取当前正在使用的机器人后端账号
static func get_id()->int:
	return BotAdapter.get_bot_id()
	

## 获取当前机器人账号的好友列表，需要与await关键词配合使用
static func get_friend_list()->MemberList:
	var _result:Dictionary = await BotAdapter.send_bot_request("friendList",null,null)
	var _arr:Array = _result["data"]
	var _ins:MemberList = MemberList.init_meta(_arr)
	return _ins
	

## 获取当前机器人账号的群组列表，需要与await关键词配合使用
static func get_group_list()->GroupList:
	var _result:Dictionary = await BotAdapter.send_bot_request("groupList",null,null)
	var _arr:Array = _result["data"]
	var _ins:GroupList = GroupList.init_meta(_arr)
	return _ins


## 获取当前机器人账号的资料卡，需要与await关键词配合使用
static func get_profile()->MemberProfile:
	var _result:Dictionary = await BotAdapter.send_bot_request("botProfile",null,null)
	var _ins:MemberProfile = MemberProfile.init_meta(_result)
	return _ins


## 从当前机器人账号的历史消息缓存中获取指定id的缓存消息，需要与await关键词配合使用
static func get_cache_message(msg_id:int)->CacheMessage:
	var _req_dic = {
		"id":msg_id
	}
	var _result_dic:Dictionary = await BotAdapter.send_bot_request("messageFromId",null,_req_dic)
	var ins = CacheMessage.init_meta(_result_dic["data"])
	return ins
