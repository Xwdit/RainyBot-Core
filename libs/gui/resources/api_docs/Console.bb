[font_size=25][b][color=#70bafa]类:[/color] Console[/b][/font_size]
[color=#70bafa]继承:[/color] CoreAPI


[b]RainyBot控制台类，包含了各类与控制台输出直接相关的功能[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=gray]void[/color] ￿print_text￿ [color=gray]([/color] [color=#70bafa]Variant[/color] text [color=gray])[/color]

	在控制台中打印一个普通文本，可以传入任意类型值，将自动尝试转换为字符串


	● [color=gray]static[/color] [color=gray]void[/color] ￿print_error￿ [color=gray]([/color] [color=#70bafa]Variant[/color] text [color=gray])[/color]

	在控制台中打印一个错误文本，可以传入任意类型值，将自动尝试转换为字符串


	● [color=gray]static[/color] [color=gray]void[/color] ￿print_warning￿ [color=gray]([/color] [color=#70bafa]Variant[/color] text [color=gray])[/color]

	在控制台中打印一个警告文本，可以传入任意类型值，将自动尝试转换为字符串


	● [color=gray]static[/color] [color=gray]void[/color] ￿print_success￿ [color=gray]([/color] [color=#70bafa]Variant[/color] text [color=gray])[/color]

	在控制台中打印一个成功文本，可以传入任意类型值，将自动尝试转换为字符串


	● [color=gray]static[/color] [color=gray]void[/color] ￿save_log￿ [color=gray]([/color] [color=gray])[/color]

	将控制台的内容立刻保存为以当前日期与时间命名的日志文件


	● [color=gray]static[/color] [color=#70bafa]bool[/color] ￿popup_notification￿ [color=gray]([/color] [color=#70bafa]String[/color] text, [color=#70bafa]String[/color] title[color=gray] = "提示"[/color] [color=gray])[/color]

	在控制台弹出一个具有指定文本的提示框，并且可以指定一个可选的自定义窗口标题 
	
	配合await关键词使用可以在提示框的确认按钮被点击时返回true，直接关闭时返回false


	● [color=gray]static[/color] [color=#70bafa]bool[/color] ￿popup_confirm￿ [color=gray]([/color] [color=#70bafa]String[/color] text, [color=#70bafa]String[/color] title[color=gray] = "请确认"[/color] [color=gray])[/color]

	在控制台弹出一个具有指定文本的确认框，并且可以指定一个可选的自定义窗口标题 
	
	配合await关键词使用可以在确认框的确认按钮被点击时返回true，点击取消或直接关闭时返回false


	● [color=gray]static[/color] [color=gray]void[/color] ￿disable_sysout￿ [color=gray]([/color] [color=#70bafa]bool[/color] disabled [color=gray])[/color]

	临时禁用控制台中的系统消息输出，不影响插件通过[code]Console.print_[/code]系列函数进行的输出


