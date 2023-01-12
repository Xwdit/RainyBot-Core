extends BotEvent


class_name BotOfflineEvent


enum ReasonType{
	ACTIVE,
	FORCE,
	DROPPED
}


var data_dic:Dictionary = {
	"type":"BotOfflineEvent",
	"qq":0
}

var event_reason:int = ReasonType.ACTIVE


static func init_meta(dic:Dictionary,reason_type:int)->BotOfflineEvent:
	if dic.has("type"):
		var ins:BotOfflineEvent = BotOfflineEvent.new()
		ins.data_dic = dic
		ins.event_reason = reason_type
		return ins
	else:
		return null
	
	
func get_reason_type()->int:
	return event_reason


func is_reason_type(reason:int)->bool:
	return reason == event_reason
