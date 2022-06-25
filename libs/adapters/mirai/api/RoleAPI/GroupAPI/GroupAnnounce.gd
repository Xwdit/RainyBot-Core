extends GroupAPI


class_name GroupAnnounce


var data_dic:Dictionary = {
	"content":"",
	"sendToNewMember":false,
	"pinned":false,
	"showEditCard":false,
	"showPopup":false,
	"requireConfirmation":false,
	"imageUrl":"",
	"imagePath":"",
	"imageBase64":""
}


static func init(content:String)->GroupAnnounce:
	var ins:GroupAnnounce = GroupAnnounce.new()
	ins.data_dic["content"] = content
	return ins


static func init_meta(dic:Dictionary)->GroupAnnounce:
	var ins:GroupAnnounce = GroupAnnounce.new()
	if !dic.is_empty():
		ins.data_dic = dic
	return ins


func get_metadata()->Dictionary:
	return data_dic


func set_metadata(dic:Dictionary):
	data_dic = dic


func set_content(text:String)->void:
	data_dic["content"] = text


func get_content()->String:
	return data_dic["content"]


func set_send_to_new_member(enabled:bool)->void:
	data_dic["sendToNewMember"] = enabled


func is_send_to_new_member()->bool:
	return data_dic["sendToNewMember"]
	
	
func set_pinned(enabled:bool)->void:
	data_dic["pinned"] = enabled


func is_pinned()->bool:
	return data_dic["pinned"]
	
	
func set_show_edit_card(enabled:bool)->void:
	data_dic["showEditCard"] = enabled


func is_show_edit_card()->bool:
	return data_dic["showEditCard"]
	
	
func set_show_popup(enabled:bool)->void:
	data_dic["showPopup"] = enabled


func is_show_popup()->bool:
	return data_dic["showPopup"]
	
	
func set_require_confirm(enabled:bool)->void:
	data_dic["requireConfirmation"] = enabled


func is_require_confirm()->bool:
	return data_dic["requireConfirmation"]


func set_image_url(img_url:String)->void:
	data_dic["imageUrl"] = img_url


func get_image_url()->String:
	return data_dic["imageUrl"]
	
	
func set_image_path(img_path:String)->void:
	data_dic["imagePath"] = img_path


func get_image_path()->String:
	return data_dic["imagePath"]
	
	
func set_image_base64(img_base64:String)->void:
	data_dic["imageBase64"] = img_base64


func get_image_base64()->String:
	return data_dic["imageBase64"]
