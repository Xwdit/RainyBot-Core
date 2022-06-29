extends Resource


class_name GifImage


const GIFExporter = preload("res://libs/core/modules/gif_exporter/exporter.gd")
const MedianCutQuantization = preload("res://libs/core/modules/gif_exporter/quantization/median_cut.gd")


var size:Vector2
var frames:Array[Dictionary]


static func init(size:Vector2)->GifImage:
	if size.x < 0 or size.y < 0:
		Console.print_error("无法创建GifImage图像实例，因为传入的大小不能小于0!")
		return null
	var ins:GifImage = GifImage.new()
	ins.size = size
	return ins
	
	
func add_frame(image:Image,delay_time:float)->int:
	if !is_instance_valid(image):
		Console.print_error("指定的图像实例无效，因此无法将其添加到Gif帧!")
		return ERR_INVALID_DATA
	if delay_time <= 0:
		Console.print_error("指定的图像帧延迟时间需要大于0，因此无法将其添加到Gif帧!")
		return ERR_INVALID_PARAMETER
	if image.is_empty():
		Console.print_error("无法将指定图像添加到Gif帧，请检查图像内容是否为空!")
		return ERR_INVALID_DATA
	frames.append({"image":image,"delay_time":delay_time})
	emit_changed()
	return OK


func save(path:String)->int:
	var file:File = File.new()
	var _err:int = file.open(path, File.WRITE)
	if _err == OK:
		file.store_buffer(await get_data())
		file.close()
		Console.print_success("成功将Gif图像数据储存至文件 %s"% path)
	else:
		Console.print_error("无法将指定Gif图像数据储存到文件 %s，请检查文件路径或权限是否正确!"% path)
	return _err


func get_data()->PackedByteArray:
	Console.print_warning("正在生成Gif图像数据，请稍候.....")
	var _thread:Thread = Thread.new()
	var _err:int = _thread.start(_export_data)
	if _err == OK:
		while _thread.is_alive():
			await GlobalManager.get_tree().process_frame
		var _data:PackedByteArray = await _thread.wait_to_finish()
		Console.print_success("Gif图像数据生成完毕，正在返回生成的数据.....")
		return _data
	else:
		Console.print_error("无法创建用于生成Gif图像数据的线程，请再试一次!")
		return PackedByteArray()


func _export_data()->PackedByteArray:
	var _exporter:GIFExporter = GIFExporter.new(size.x,size.y)
	for _img_dic in frames:
		await GlobalManager.get_tree().process_frame
		var _img:Image = _img_dic.image
		var _delay:int = int(round(_img_dic.delay_time*100))
		_img.convert(Image.FORMAT_RGBA8)
		_exporter.add_frame(_img,_delay,MedianCutQuantization)
	return _exporter.export_file_data()


func get_size()->Vector2:
	return size


func get_frames()->Array[Dictionary]:
	return frames


func get_frames_count()->int:
	return frames.size()
