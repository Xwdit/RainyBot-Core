extends SingleMessage


class_name FlashImageMessage


func _init():
	data = {
		"image_id":null,
		"url":null,
		"path":null,
		"base64":null
	}


func set_image_id(img_id:String) -> void:
	data.image_id = img_id

func get_image_id() -> String:
	return data.image_id

func set_url(url:String) -> void:
	data.url = url

func get_url() -> String:
	return data.url
	
func set_path(path:String) -> void:
	data.path = path

func get_path() -> String:
	return data.path

func set_base64(base64:String) -> void:
	data.base64 = base64

func get_base64() -> String:
	return data.base64
