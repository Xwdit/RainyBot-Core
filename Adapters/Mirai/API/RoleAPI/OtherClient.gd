extends RoleAPI


class_name OtherClient


var data_dic:Dictionary = {
	"id": -1,
	"platform": ""
}


static func init()->OtherClient:
	var ins:OtherClient = OtherClient.new()
	ins.data_dic["id"] = BotAdapter.get_bot_id()
	return ins
	

static func init_meta(dic:Dictionary)->OtherClient:
	var ins:OtherClient = OtherClient.new()
	ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic
	
	
func get_id()->int:
	return data_dic.id
	
	
func get_platform()->String:
	return data_dic.platform


func send_message(msg,quote_msgid:int=-1)->BotRequestResult:
	var _chain = []
	if msg is String:
		_chain.append(BotCodeMessage.init(msg).get_metadata())
	elif msg is Message:
		_chain.append(msg.get_metadata())
	elif msg is MessageChain:
		_chain = msg.get_metadata()
	var _req_dic = {
		"target":get_id(),
		"messageChain":_chain,
		"quote":quote_msgid if quote_msgid != -1 else null
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendFriendMessage",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins


func send_nudge()->BotRequestResult:
	var _req_dic = {
		"target":get_id(),
		"subject":get_id(),
		"kind":"Friend"
	}
	var _result:Dictionary = await BotAdapter.send_bot_request("sendNudge",null,_req_dic)
	var _ins:BotRequestResult = BotRequestResult.init_meta(_result)
	return _ins
