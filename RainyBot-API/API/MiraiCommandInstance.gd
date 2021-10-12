#命令实例类Api，请勿改动下方内容

extends Object #基于内部Object类构建

class_name MiraiCommandInstance #定义类名称

signal request_finished #命令请求完成时将发送此信号，用于判断是否可尝试获取回调结果

func finish(): #调用此函数来清理此实例，不返回任何值
	pass
	
func get_result(): #调用此函数来获取实例的返回结果，结果可能为 null(空) 或 Dictionary(字典) 类
	pass
