extends Message


class_name FlashImageMessage


var data_dic:Dictionary = {
	"type": "FlashImage",
	"imageId": null,
	"url": null,
	"path": null,
	"base64": null
}


static func init(image:Image)->FlashImageMessage:
	var f_path:String = GlobalManager.cache_path + "image_cache_%s.png" % randi()
	var err:int = image.save_png(f_path)
	if err == OK:
		Console.print_success("成功将图像实例缓存至文件: %s"% f_path)
	else:
		Console.print_error("无法将图像实例缓存至文件 %s，请检查路径或权限是否有误!"% f_path)
	var ins:FlashImageMessage = FlashImageMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.path = f_path
	return ins


static func init_id(image_id:String)->FlashImageMessage:
	var ins:FlashImageMessage = FlashImageMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.imageId = image_id
	return ins


static func init_url(image_url:String)->FlashImageMessage:
	var ins:FlashImageMessage = FlashImageMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.url = image_url
	return ins


static func init_path(image_path:String)->FlashImageMessage:
	var ins:FlashImageMessage = FlashImageMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.path = image_path
	return ins


static func init_base64(image_base64:String)->FlashImageMessage:
	var ins:FlashImageMessage = FlashImageMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.base64 = image_base64
	return ins


static func init_meta(dic:Dictionary)->FlashImageMessage:
	var ins:FlashImageMessage = FlashImageMessage.new()
	ins.data_dic = dic
	return ins

	
func get_image_id()->String:
	return data_dic.imageId
	
	
func set_image_id(image_id:String)->void:
	data_dic.imageId = image_id
	
	
func get_image_url()->String:
	return data_dic.url
	
	
func set_image_url(image_url:String)->void:
	data_dic.url = image_url
	
	
func get_image_path()->String:
	return data_dic.path
	
	
func set_image_path(image_path:String)->void:
	data_dic.path = image_path
	
	
func get_image_base64()->String:
	return data_dic.base64
	
	
func set_image_base64(image_base64:String)->void:
	data_dic.base64 = image_base64


func get_as_text()->String:
	return "[闪照:"+get_image_id()+"]"
