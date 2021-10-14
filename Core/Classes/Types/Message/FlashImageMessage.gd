extends SingleMessage


class_name FlashImageMessage


func _init():
	data = {
		Interface.flash_image_message_data.ImageId:null,
		Interface.flash_image_message_data.Url:null,
		Interface.flash_image_message_data.Path:null,
		Interface.flash_image_message_data.Base64:null
	}


func set_image_id(img_id:String) -> void:
	data[Interface.flash_image_message_data.ImageId] = img_id

func get_image_id() -> String:
	return data[Interface.flash_image_message_data.ImageId]

func set_url(url:String) -> void:
	data[Interface.flash_image_message_data.Url] = url

func get_url() -> String:
	return data[Interface.flash_image_message_data.Url]
	
func set_path(path:String) -> void:
	data[Interface.flash_image_message_data.Path] = path

func get_path() -> String:
	return data[Interface.flash_image_message_data.Path]

func set_base64(base64:String) -> void:
	data[Interface.flash_image_message_data.Base64] = base64

func get_base64() -> String:
	return data[Interface.flash_image_message_data.Base64]
