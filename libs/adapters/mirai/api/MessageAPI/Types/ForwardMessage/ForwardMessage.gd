extends Message


class_name ForwardMessage


var data_dic:Dictionary = {
	"type": "Forward",
	"nodeList": [
		{
			"senderId": -1,
			"time": 0,
			"senderName": "",
			"messageChain": [],
			"messageId": -1
		}
	] 
}


static func init(node_list:ForwardMessageNodeList)->ForwardMessage:
	if !is_instance_valid(node_list):
		return null
	var ins:ForwardMessage = ForwardMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.nodeList = node_list.get_metadata()
	return ins


static func init_meta(dic:Dictionary)->ForwardMessage:
	if !dic.is_empty() and dic.has("type"):
		var ins:ForwardMessage = ForwardMessage.new()
		ins.data_dic = dic
		return ins
	else:
		return null
	


func get_node_list()->ForwardMessageNodeList:
	return ForwardMessageNodeList.init_meta(data_dic.nodeList)
	
	
func set_node_list(node_list:ForwardMessageNodeList)->void:
	data_dic.nodeList = node_list.get_metadata()
	
