extends Message


class_name ImageMessage


var data_dic:Dictionary = {
	"type": "Image",
	"imageId": null,
	"url": null,
	"path": null,
	"base64": null,
	"height": null,
	"width": null,
	"size": null,
	"isEmoji": null,
	"imageType": null
}


static func init(image:Image)->ImageMessage:
	if is_instance_valid(image):
		var f_path:String = GlobalManager.cache_path + "image_cache_%s.png" % randi()
		var err:int = image.save_png(f_path)
		if !err:
			var ins:ImageMessage = ImageMessage.new()
			var dic:Dictionary = ins.data_dic
			dic.path = f_path
			GuiManager.console_print_success("成功将Image图像实例缓存至文件并构造为图像消息: %s"% f_path)
			return ins
		else:
			GuiManager.console_print_error("无法将Image图像实例缓存至文件 %s，因此无法构造为图像消息，请检查路径或权限是否有误!"% f_path)
	else:
		GuiManager.console_print_error("传入的实例无效，因此无法将指定的图像实例构造为图像消息!")
	return null


static func init_gif(gif_image:GifImage)->ImageMessage:
	if is_instance_valid(gif_image):
		var f_path:String = GlobalManager.cache_path + "gif_image_cache_%s.gif" % randi()
		var err:int = await gif_image.save(f_path)
		if !err:
			var ins:ImageMessage = ImageMessage.new()
			var dic:Dictionary = ins.data_dic
			dic.path = f_path
			GuiManager.console_print_success("成功将GifImage图像实例缓存至文件并构造为图像消息: %s"% f_path)
			return ins
		else:
			GuiManager.console_print_error("无法将GifImage图像实例缓存至文件 %s，因此无法构造为图像消息，请检查路径或权限是否有误!"% f_path)
	else:
		GuiManager.console_print_error("传入的实例无效，因此无法将指定的GifImage图像实例构造为图像消息!")
	return null


static func init_id(image_id:String)->ImageMessage:
	var ins:ImageMessage = ImageMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.imageId = image_id
	return ins


static func init_url(image_url:String)->ImageMessage:
	var ins:ImageMessage = ImageMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.url = image_url
	return ins


static func init_path(image_path:String)->ImageMessage:
	var ins:ImageMessage = ImageMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.path = image_path
	return ins


static func init_base64(image_base64:String)->ImageMessage:
	var ins:ImageMessage = ImageMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.base64 = image_base64
	return ins


static func init_meta(dic:Dictionary)->ImageMessage:
	var ins:ImageMessage = ImageMessage.new()
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


func get_image_height()->int:
	return data_dic.height
	
	
func get_image_width()->int:
	return data_dic.width
	
	
func get_image_size()->float:
	return data_dic.size


func get_image_type()->String:
	return data_dic.imageType


func is_emoji()->bool:
	return data_dic.isEmoji


func get_as_text()->String:
	return "[图片:"+get_image_id()+"]"
