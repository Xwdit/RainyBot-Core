extends GroupBotEvent


class_name BotJoinGroupEvent


var data_dic:Dictionary = {
  "type": "BotJoinGroupEvent",
  "group": {
	"id": 0,
	"name": "",
	"permission": ""
  },
  "invitor": null
}


static func init_meta(dic:Dictionary)->BotJoinGroupEvent:
	var ins:BotJoinGroupEvent = BotJoinGroupEvent.new()
	ins.data_dic = dic
	return ins
	

func get_invitor()->Member:
	if data_dic.invitor == null:
		return null
	return Member.init_meta(data_dic.invitor)
	
	
func get_group()->Group:
	return Group.init_meta(data_dic.group)
