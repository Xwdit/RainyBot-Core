extends CoreAPI #继承自CoreAPI


## RainyBot控制台类，包含了各类与控制台输出直接相关的功能
class_name Console


## 在控制台中打印一个普通文本，可以传入任意类型值，将自动尝试转换为字符串
static func print_text(text):
	GuiManager.console_print_text(text)
	

## 在控制台中打印一个错误文本，可以传入任意类型值，将自动尝试转换为字符串
static func print_error(text):
	GuiManager.console_print_error(text)
	

## 在控制台中打印一个警告文本，可以传入任意类型值，将自动尝试转换为字符串
static func print_warning(text):
	GuiManager.console_print_warning(text)
	

## 在控制台中打印一个成功文本，可以传入任意类型值，将自动尝试转换为字符串
static func print_success(text):
	GuiManager.console_print_success(text)


## 将控制台的内容立刻保存为以当前日期与时间命名的日志文件
static func save_log(close:bool=false):
	GuiManager.console_save_log(close)
