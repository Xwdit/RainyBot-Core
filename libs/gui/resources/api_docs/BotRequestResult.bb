[font_size=25][b][color=#70bafa]类:[/color] BotRequestResult[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:BotAPI]BotAPI[/url]


[b]RainyBot的协议后端请求结果类，记录了向协议后端发送的某次请求/命令的结果数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿StatusCode￿

	请求结果的状态码，可用于对比判断请求结果的当前状态

		● SUCCESS [color=gray]= 0[/color]
		[color=gray]请求成功[/color]

		● WRONG_VERIFY_KEY [color=gray]= 1[/color]
		[color=gray]验证密钥错误[/color]

		● BOT_NOT_EXIST [color=gray]= 2[/color]
		[color=gray]请求的Bot不存在[/color]

		● SESSION_INVALID [color=gray]= 3[/color]
		[color=gray]会话无效[/color]

		● SESSION_NOT_ACTIVE [color=gray]= 4[/color]
		[color=gray]会话未活跃[/color]

		● TARGET_NOT_EXIST [color=gray]= 5[/color]
		[color=gray]目标不存在[/color]

		● FILE_NOT_EXIST [color=gray]= 6[/color]
		[color=gray]文件不存在[/color]

		● NO_PERMISSION [color=gray]= 10[/color]
		[color=gray]没有权限[/color]

		● BOT_MUTED [color=gray]= 20[/color]
		[color=gray]机器人被禁言[/color]

		● MESSAGE_TOO_LONG [color=gray]= 30[/color]
		[color=gray]消息长度超限[/color]

		● WRONG_USAGE [color=gray]= 400[/color]
		[color=gray]命令用法有误[/color]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa][url=api:BotRequestResult]BotRequestResult[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据数组构造一个BotRequestResult类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray][hint=此函数无返回值]void[/hint][/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_status_code￿ [color=gray]([/color] [color=gray])[/color]

	返回请求结果的状态码


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_status_msg￿ [color=gray]([/color] [color=gray])[/color]

	返回请求结果的状态信息文本


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_message_id￿ [color=gray]([/color] [color=gray])[/color]

	返回请求结果对应的消息ID


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿is_success￿ [color=gray]([/color] [color=gray])[/color]

	返回请求结果是否为成功


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿is_status￿ [color=gray]([/color] [color=#70bafa][url=godot:int]int[/url][/color] code [color=gray])[/color]

	判断请求结果是否为指定的结果


