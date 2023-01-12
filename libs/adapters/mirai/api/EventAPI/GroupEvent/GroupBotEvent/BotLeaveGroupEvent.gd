extends GroupBotEvent


class_name BotLeaveGroupEvent


enum ReasonType{
	ACTIVE,
	KICK,
	DISBAND
}


var data_dic:Dictionary = {
  "type": "BotLeaveGroupEvent",
  "group": {
	"id": 0,
	"name": "",
	"permission": ""
  },
  "operator": null
}

var event_reason:int = ReasonType.ACTIVE


static func init_meta(dic:Dictionary,reason:int)->BotLeaveGroupEvent:
	if dic.has("type"):
		var ins:BotLeaveGroupEvent = BotLeaveGroupEvent.new()
		ins.data_dic = dic
		ins.event_reason = reason
		return ins
	else:
		return null
	

func get_operator()->Member:
	if data_dic.operator == null:
		return null
	return Member.init_meta(data_dic.operator)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.group)


func get_reason_type()->int:
	return event_reason
	
	
func is_reason_type(reason:int)->bool:
	return reason == event_reason
