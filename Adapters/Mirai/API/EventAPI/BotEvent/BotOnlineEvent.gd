extends BotEvent


class_name BotOnlineEvent


var data_dic:Dictionary = {
	"type":"BotOnlineEvent",
	"qq":0
}


static func init_meta(dic:Dictionary)->BotOnlineEvent:
	var ins:BotOnlineEvent = BotOnlineEvent.new()
	ins.data_dic = dic
	return ins
