extends Message


class_name FileMessage


var data_dic:Dictionary = {
	"type": "File",
	"id": "",
	"name": "",
	"size": 0
}


static func init_meta(dic:Dictionary)->FileMessage:
	if dic.has("type"):
		var ins:FileMessage = FileMessage.new()
		ins.data_dic = dic
		return ins
	else:
		return null


func get_file_id()->String:
	return data_dic.id


func get_file_name()->String:
	return data_dic.name


func get_file_size()->int:
	return data_dic.size


func get_as_text()->String:
	return "[文件"+get_file_name()+"]"
