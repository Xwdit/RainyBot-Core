extends BotEvent


class_name BotReloginEvent


var data_dic:Dictionary = {
	"type":"BotReloginEvent",
	"qq":0
}


static func init_meta(dic:Dictionary)->BotReloginEvent:
	var ins:BotReloginEvent = BotReloginEvent.new()
	ins.data_dic = dic
	return ins
