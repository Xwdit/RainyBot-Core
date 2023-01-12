extends BotEvent


class_name BotOnlineEvent


var data_dic:Dictionary = {
	"type":"BotOnlineEvent",
	"qq":0
}


static func init_meta(dic:Dictionary)->BotOnlineEvent:
	if !dic.is_empty() and dic.has("type"):
		var ins:BotOnlineEvent = BotOnlineEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null
