extends CoreAPI


class_name GifImage


signal changed()


const GIFExporter = preload("res://libs/core/modules/gif_exporter/exporter.gd")
const MedianCutQuantization = preload("res://libs/core/modules/gif_exporter/quantization/median_cut.gd")


var size:Vector2
var frames:Array[Dictionary]
var data:PackedByteArray
var frame_generate_time:int = -1


static func init(img_size:Vector2)->GifImage:
	if img_size.x < 0 or img_size.y < 0:
		GuiManager.console_print_error("无法创建GifImage图像实例，因为传入的图像大小不能小于0!")
		return null
	var ins:GifImage = GifImage.new()
	ins.size = img_size
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
	frames.append({"image":image,"delay_time":delay_time})
	data.resize(0)
	emit_signal("changed")
	return OK


func insert_frame(idx:int,image:Image,delay_time:float)->int:
	if idx <= frames.size():
		if !is_instance_valid(image):
			GuiManager.console_print_error("指定的图像实例无效，因此无法将其插入到Gif帧!")
			return ERR_INVALID_DATA
		if delay_time <= 0:
			GuiManager.console_print_error("指定的图像帧延迟时间需要大于0，因此无法将其插入到Gif帧!")
			return ERR_INVALID_PARAMETER
		if image.is_empty():
			GuiManager.console_print_error("无法将指定图像插入到Gif帧，请检查图像内容是否为空!")
			return ERR_INVALID_DATA
		frames.insert(idx,{"image":image,"delay_time":delay_time})
		data.resize(0)
		if idx == 0:
			frame_generate_time = -1
		emit_signal("changed")
		return OK
	else:
		GuiManager.console_print_error("指定的位置无效，因此无法将其插入到Gif帧!")
		return ERR_DOES_NOT_EXIST


func remove_frame(idx:int)->int:
	if idx <= frames.size()-1:
		frames.remove_at(idx)
		data.resize(0)
		if idx == 0:
			frame_generate_time = -1
		emit_signal("changed")
		return OK
	else:
		GuiManager.console_print_error("指定的位置无效，因此无法从Gif帧中将其移除!")
		return ERR_DOES_NOT_EXIST
		

func get_frame_image(idx:int)->Image:
	if idx <= frames.size()-1:
		return frames[idx].image
	else:
		return null
		
		
func get_frame_delay_time(idx:int)->float:
	if idx <= frames.size()-1:
		return frames[idx].delay_time
	else:
		return 0.0
		
		
func set_frame_image(idx:int,image:Image)->int:
	if idx <= frames.size()-1:
		if !is_instance_valid(image):
			GuiManager.console_print_error("指定的图像实例无效，因此无法将其设置到Gif帧!")
			return ERR_INVALID_DATA
		if image.is_empty():
			GuiManager.console_print_error("无法将指定图像设置到Gif帧，请检查图像内容是否为空!")
			return ERR_INVALID_DATA
		if frames[idx].image != image:
			data.resize(0)
			frames[idx].image = image
			if idx == 0:
				frame_generate_time = -1
			emit_signal("changed")
		return OK
	else:
		GuiManager.console_print_error("指定的位置无效，因此无法将指定的图像设置到Gif帧!")
		return ERR_DOES_NOT_EXIST
		
		
func set_frame_delay_time(idx:int,delay_time:float)->int:
	if idx <= frames.size()-1:
		if delay_time <= 0:
			GuiManager.console_print_error("指定的图像帧延迟时间需要大于0，因此无法将其添加到Gif帧!")
			return ERR_INVALID_PARAMETER
		if frames[idx].delay_time != delay_time:
			data.resize(0)
			frames[idx].delay_time = delay_time
			if idx == 0:
				frame_generate_time = -1
			emit_signal("changed")
		return OK
	else:
		GuiManager.console_print_error("指定的位置无效，因此无法将指定的延迟时间设置到Gif帧!")
		return ERR_DOES_NOT_EXIST


func clear_frames()->void:
	frames.clear()
	frame_generate_time = -1
	data.resize(0)
	emit_signal("changed")


func get_frames_count()->int:
	return frames.size()
	

func set_size(new_size:Vector2)->int:
	if new_size.x < 0 or new_size.y < 0:
		GuiManager.console_print_error("无法更改GifImage图像实例的大小，因为传入的图像大小不能小于0!")
		return ERR_INVALID_PARAMETER
	if size != new_size:
		size = new_size
		frame_generate_time = -1
		data.resize(0)
		emit_signal("changed")
	return OK


func get_size()->Vector2:
	return size


func get_playback_time()->float:
	if frames.is_empty():
		GuiManager.console_print_error("此Gif图像实例中不存在任何图像帧，因此无法获取总计的播放时长！")
		return 0.0
	var _time:float = 0.0
	for f_dic in frames:
		_time += f_dic.delay_time
	return _time


func save(path:String)->int:
	if frames.is_empty():
		GuiManager.console_print_error("此Gif图像实例中不存在任何图像帧，因此无法将其保存为文件！")
		return ERR_DOES_NOT_EXIST
	var file:File = File.new()
	var _err:int = file.open(path, File.WRITE)
	if _err == OK:
		file.store_buffer(await get_data())
		file.close()
		GuiManager.console_print_success("成功将Gif图像数据储存至文件 %s"% path)
	else:
		GuiManager.console_print_error("无法将指定Gif图像数据储存到文件 %s，请检查文件路径或权限是否正确!"% path)
	return _err


func get_data()->PackedByteArray:
	if frames.is_empty():
		GuiManager.console_print_error("此Gif图像实例中不存在任何图像帧，因此无法获取其图像数据！")
		return PackedByteArray([])
	if !data.is_empty():
		return data
	GuiManager.console_print_warning("正在生成Gif图像数据，请稍候.....")
	var _start_time:int = Time.get_ticks_msec()
	var _thread:Thread = Thread.new()
	var _err:int = _thread.start(_export_data.bind(frames))
	if _err == OK:
		while _thread.is_alive():
			await GlobalManager.get_tree().process_frame
		data = _thread.wait_to_finish()
		var _end_time:int = Time.get_ticks_msec()
		var _passed_time:int = _end_time-_start_time
		frame_generate_time = int(round(float(_passed_time)/float(frames.size())))
		GuiManager.console_print_success("Gif图像数据生成完毕，正在返回生成的数据.....(总用时: %s秒)"% (float(_passed_time)/1000.0))
		return data
	else:
		GuiManager.console_print_error("无法创建用于生成Gif图像数据的线程，请再试一次!")
		return PackedByteArray([])


func get_generate_time()->float:
	if frames.is_empty():
		GuiManager.console_print_error("此Gif图像实例中不存在任何图像帧，因此无法获取预计的生成时长！")
		return 0.0
	if frame_generate_time == -1:
		if (await _test_generate_speed()) != OK:
			GuiManager.console_print_error("Gif图像生成速度测试失败，因此无法获取预计的生成时长！")
			return 0.0
	return float(frame_generate_time * frames.size())/1000.0


func _test_generate_speed()->int:
	GuiManager.console_print_warning("正在测试Gif图像数据的生成速度，请稍候.....")
	var _test_frames:Array = [frames[0]]
	var _start_time:int = Time.get_ticks_msec()
	var _thread:Thread = Thread.new()
	var _err:int = _thread.start(_export_data.bind(_test_frames))
	if _err == OK:
		while _thread.is_alive():
			await GlobalManager.get_tree().process_frame
		var _data:PackedByteArray = _thread.wait_to_finish()
		var _end_time:int = Time.get_ticks_msec()
		frame_generate_time = _end_time-_start_time
		GuiManager.console_print_success("Gif图像数据生成速度测试完毕！相关数据已保存至该Gif图像实例，以便用于预估生成时长！")
		return OK
	else:
		GuiManager.console_print_error("无法创建用于测试Gif图像数据生成速度的线程，请再试一次!")
		return ERR_CANT_CREATE


func _export_data(_img_frames:Array)->PackedByteArray:
	var _exporter:GIFExporter = GIFExporter.new(size.x,size.y)
	for _img_dic in _img_frames:
		var _img:Image = _img_dic.image
		var _delay:int = int(round(_img_dic.delay_time*100))
		_img.convert(Image.FORMAT_RGBA8)
		_exporter.add_frame(_img,_delay,MedianCutQuantization)
	return _exporter.export_file_data()
