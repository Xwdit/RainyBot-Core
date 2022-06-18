extends OtherClientEvent


class_name OtherClientOfflineEvent


var data_dic:Dictionary = {
	"type": "OtherClientOfflineEvent",
	"client": {
		"id": 0,
		"platform": "WINDOWS"
	}
}


static func init_meta(dic:Dictionary)->OtherClientOfflineEvent:
	var ins:OtherClientOfflineEvent = OtherClientOfflineEvent.new()
	ins.data_dic = dic
	return ins
