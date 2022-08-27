extends CoreAPI


class_name GifImage


signal changed()


var data:ImageFrames


static func init()->GifImage:
	var ins:GifImage = GifImage.new()
	ins.data = ImageFrames.new()
	return ins
	
	
func add_frame(image:Image,delay_time:float)->int:
	if !is_instance_valid(image):
		GuiManager.console_print_error("指定的图像实例无效，因此无法将其添加到Gif帧!")
		return ERR_INVALID_DATA
	if delay_time <= 0:
		GuiManager.console_print_error("指定的图像帧延迟时间需要大于0，因此无法将其添加到Gif帧!")
		return ERR_INVALID_PARAMETER
	if image.is_empty():
		GuiManager.console_print_error("无法将指定图像添加到Gif帧，请检查图像内容是否为空!")
		return ERR_INVALID_DATA
	data.add_frame(image,delay_time)
	emit_signal("changed")
	return OK


func insert_frame(idx:int,image:Image,delay_time:float)->int:
	if idx <= data.get_frame_count()-1:
		if !is_instance_valid(image):
			GuiManager.console_print_error("指定的图像实例无效，因此无法将其插入到Gif帧!")
			return ERR_INVALID_DATA
		if delay_time <= 0:
			GuiManager.console_print_error("指定的图像帧延迟时间需要大于0，因此无法将其插入到Gif帧!")
			return ERR_INVALID_PARAMETER
		if image.is_empty():
			GuiManager.console_print_error("无法将指定图像插入到Gif帧，请检查图像内容是否为空!")
			return ERR_INVALID_DATA
		data.insert_frame(idx,image,delay_time)
		emit_signal("changed")
		return OK
	else:
		GuiManager.console_print_error("指定的位置无效，因此无法将其插入到Gif帧!")
		return ERR_DOES_NOT_EXIST


func remove_frame(idx:int)->int:
	if idx <= data.get_frame_count()-1:
		data.remove_frame(idx)
		emit_signal("changed")
		return OK
	else:
		GuiManager.console_print_error("指定的位置无效，因此无法从Gif帧中将其移除!")
		return ERR_DOES_NOT_EXIST
		

func get_frame_image(idx:int)->Image:
	if idx <= data.get_frame_count()-1:
		return data.get_frame_image(idx)
	else:
		return null
		
		
func get_frame_delay_time(idx:int)->float:
	if idx <= data.get_frame_count()-1:
		return data.get_frame_delay(idx)
	else:
		return 0.0
		
		
func set_frame_image(idx:int,image:Image)->int:
	if idx <= data.get_frame_count()-1:
		if !is_instance_valid(image):
			GuiManager.console_print_error("指定的图像实例无效，因此无法将其设置到Gif帧!")
			return ERR_INVALID_DATA
		if image.is_empty():
			GuiManager.console_print_error("无法将指定图像设置到Gif帧，请检查图像内容是否为空!")
			return ERR_INVALID_DATA
		if data.get_frame_image(idx) != image:
			data.set_frame_image(idx,image)
			emit_signal("changed")
		return OK
	else:
		GuiManager.console_print_error("指定的位置无效，因此无法将指定的图像设置到Gif帧!")
		return ERR_DOES_NOT_EXIST
		
		
func set_frame_delay_time(idx:int,delay_time:float)->int:
	if idx <= data.get_frame_count()-1:
		if delay_time <= 0:
			GuiManager.console_print_error("指定的图像帧延迟时间需要大于0，因此无法将其添加到Gif帧!")
			return ERR_INVALID_PARAMETER
		if data.get_frame_delay(idx) != delay_time:
			data.set_frame_delay(idx,delay_time)
			emit_signal("changed")
		return OK
	else:
		GuiManager.console_print_error("指定的位置无效，因此无法将指定的延迟时间设置到Gif帧!")
		return ERR_DOES_NOT_EXIST


func clear_frames()->void:
	data.clear()
	emit_signal("changed")


func get_frames_count()->int:
	return data.get_frame_count()


func get_size()->Vector2:
	return data.get_bounding_rect().size


func get_playback_time()->float:
	if data.get_frame_count() == 0:
		GuiManager.console_print_error("此Gif图像实例中不存在任何图像帧，因此无法获取总计的播放时长！")
		return 0.0
	var _time:float = 0.0
	for i in data.get_frame_count():
		_time += data.get_frame_delay(i)
	return _time


func save(path:String,color_count:int=256)->int:
	if data.get_frame_count() == 0:
		GuiManager.console_print_error("此Gif图像实例中不存在任何图像帧，因此无法将其保存为文件！")
		return ERR_DOES_NOT_EXIST
	var _thread:Thread = Thread.new()
	var _err:int = _thread.start(data.save_gif.bind(path,color_count))
	if !_err:
		while _thread.is_alive():
			await GlobalManager.get_tree().process_frame
		var _gif_err = _thread.wait_to_finish()
		if !_gif_err:
			GuiManager.console_print_success("成功将Gif图像数据储存至文件 %s"% path)
		else:
			GuiManager.console_print_error("无法将指定Gif图像数据储存到文件 %s，请检查文件路径或权限是否正确!"% path)
		return _gif_err
	else:
		GuiManager.console_print_error("无法创建用于储存Gif图像数据的线程，请再试一次!")
	return _err
