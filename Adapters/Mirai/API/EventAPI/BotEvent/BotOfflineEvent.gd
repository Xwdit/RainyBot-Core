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


static func init_meta(dic:Dictionary,reason:int)->BotOfflineEvent:
	var ins:BotOfflineEvent = BotOfflineEvent.new()
	ins.data_dic = dic
	ins.event_reason = reason
	return ins
	
	
func get_reason_type()->int:
	return event_reason


func is_reason_type(reason:int)->bool:
	return reason == event_reason
