extends Message


class_name XmlMessage


var data_dic:Dictionary = {
	"type": "Xml",
	"xml": ""
}


static func init(text:String)->XmlMessage:
	var ins:XmlMessage = XmlMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.xml = text
	return ins


static func init_meta(dic:Dictionary)->XmlMessage:
	if dic.has("type"):
		var ins:XmlMessage = XmlMessage.new()
		ins.data_dic = dic
		return ins
	else:
		return null

	
func get_xml_text()->String:
	return data_dic.xml
	
	
func set_xml_text(text:String)->void:
	data_dic.xml = text


func get_as_text()->String:
	return "[Xml]"
