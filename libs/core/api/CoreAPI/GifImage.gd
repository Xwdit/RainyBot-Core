extends Resource


class_name GifImage


const GIFExporter = preload("res://libs/core/modules/gif_exporter/exporter.gd")
const MedianCutQuantization = preload("res://libs/core/modules/gif_exporter/quantization/median_cut.gd")


var exporter:GIFExporter
var size:Vector2
var frames:Array[Image]


static func init(size:Vector2)->GifImage:
	var ins:GifImage = GifImage.new()
	ins.exporter = GIFExporter.new(size.x,size.y)
	ins.size = size
	return ins
	
	
func add_frame(image:Image,delay_time:float)->int:
	if !is_instance_valid(image):
		Console.print_error("指定的图像实例无效，因此无法将其添加到Gif帧!")
		return ERR_INVALID_DATA
	if delay_time <= 0:
		Console.print_error("指定的图像帧延迟时间需要大于0，因此无法将其添加到Gif帧!")
		return ERR_INVALID_PARAMETER
	var _img:Image = image.duplicate(true)
	_img.convert(Image.FORMAT_RGBA8)
	var _err:int = exporter.add_frame(_img,delay_time,MedianCutQuantization)
	if _err == OK:
		frames.append(_img)
		emit_changed()
		return OK
	else:
		Console.print_error("无法将指定图像添加到Gif帧，请检查图像内容是否为空!")
		return ERR_INVALID_DATA
	

func save(path:String)->int:
	var file:File = File.new()
	var _err:int = file.open(path, File.WRITE)
	if _err == OK:
		file.store_buffer(exporter.export_file_data())
		file.close()
	else:
		Console.print_error("无法将指定图像储存到文件 %s，请检查文件路径或权限是否正确!"% path)
	return _err


func get_data()->PackedByteArray:
	return exporter.export_file_data()


func get_size()->Vector2:
	return size


func get_frames()->Array[Image]:
	return frames


func get_frames_count()->int:
	return frames.size()
