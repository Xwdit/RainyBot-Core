extends MessageAPI


class_name CacheMessage


var data_dic:Dictionary = {
	"type":"",
	"messageChain":[],
	"sender":{
		"id":-1,
		"nickname":"",
		"remark":""
	}
  }


static func init_meta(dic:Dictionary)->CacheMessage:
	var ins:CacheMessage = CacheMessage.new()
	ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func get_message_chain()->MessageChain:
	return MessageChain.init_meta(data_dic.messageChain)
	

func get_sender():
	match data_dic.type:
		"FriendMessage":
			return Member.init_meta(data_dic.sender)
		"GroupMessage","TempMessage":
			return GroupMember.init_meta(data_dic.sender)
		"StrangerMessage":
			return Member.init_meta(data_dic.sender,Member.Role.STRANGER)
		"OtherClientMessage":
			return OtherClient.init_meta(data_dic.sender)
		_:
			return null
