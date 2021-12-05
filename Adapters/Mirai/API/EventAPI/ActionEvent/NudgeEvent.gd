extends ActionEvent


class_name NudgeEvent


enum SubjectType {
	FRIEND,
	GROUP
}


var data_dic:Dictionary = {
	"type": "NudgeEvent",
	"fromId": 0,
	"subject": {
		"id": 0,
		"kind": ""
	},
	"action": "",
	"suffix": "",
	"target": 0
}


static func init_meta(dic:Dictionary)->NudgeEvent:
	var ins:NudgeEvent = NudgeEvent.new()
	ins.data_dic = dic
	return ins


func get_sender_id()->int:
	return data_dic.fromId
	
	
func get_subject_id()->int:
	return data_dic.subject.id
	
	
func get_target_id()->int:
	return data_dic.target
	
	
func get_subject_type()->int:
	if data_dic.subject.kind == "Friend":
		return SubjectType.FRIEND
	else:
		return SubjectType.GROUP


func is_subject_type(type:int)->bool:
	return get_subject_type() == type


func get_action_text()->String:
	return data_dic.action
	
	
func get_suffix_text()->String:
	return data_dic.suffix
