extends OtherClientEvent


class_name OtherClientOnlineEvent


var data_dic:Dictionary = {
	"type": "OtherClientOnlineEvent",
	"client": {
		"id": 0,
		"platform": "WINDOWS"
	},
	"kind": 0
}


static func init_meta(dic:Dictionary)->OtherClientOnlineEvent:
	if !dic.is_empty() and dic.has("type"):
		var ins:OtherClientOnlineEvent = OtherClientOnlineEvent.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_kind_id()->int:
	return data_dic.kind
