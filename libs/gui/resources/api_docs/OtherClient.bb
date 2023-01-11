[font_size=25][b][color=#70bafa]类:[/color] OtherClient[/b][/font_size]
[color=#70bafa]继承:[/color] RoleAPI


[b]RainyBot的其它客户端类，通常代表一个对应实例，实现了用于与其他客户端进行交互的各类功能[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的其它客户端类，通常代表一个对应实例，实现了用于与其他客户端进行交互的各类功能 [br]其他客户端的概念，指如当机器人后端使用手机协议登陆时，平板/PC/智能手表端此时即为其他客户端


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]OtherClient[/color] ￿init￿ [color=gray]([/color] [color=gray])[/color]

	手动构造一个OtherClient类的实例，用于主动进行与其他客户端的交互时使用


	● [color=gray]static[/color] [color=#70bafa]OtherClient[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个OtherClient类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Dictionary[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_id￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中其他客户端的客户端id


	● [color=#70bafa]String[/color] ￿get_platform￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中其他客户端的平台名(如"Windows")


	● [color=#70bafa]BotRequestResult[/color] ￿send_message￿ [color=gray]([/color] [color=#70bafa]Variant[/color] msg, [color=#70bafa]int[/color] quote_msgid[color=gray] = -1[/color], [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	向其它客户端发送消息,第二个参数为需要引用回复的消息id(可选) 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	传入的第一个参数可以是以下类型: 
	- 字符串(将自动构造为文本消息实例，解析其中的BotCode，并将其作为消息链中的唯一消息实例发送) 
	- 单个消息实例(将其作为消息链中的唯一消息实例发送) 
	- 消息链实例(将其内容复制并发送) 
	- 包含以上三种类型实例的数组(将按照上方规则将数组中的实例依次合并添加至一个消息链并发送) 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿send_nudge￿ [color=gray]([/color] [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	向其它客户端发送一个戳一戳消息， 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿recall_message￿ [color=gray]([/color] [color=#70bafa]int[/color] msg_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在其它客户端实例中将指定ID的消息撤回，仅可撤回机器人发送的消息 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]CacheMessage[/color] ￿get_cache_message￿ [color=gray]([/color] [color=#70bafa]int[/color] msg_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在其它客户端实例中获取指定ID的本地缓存消息，将返回一个[CacheMessage]类的实例 
	
	此函数必须配合await关键字进行使用，否则将会发生错误，且无法获取相关的信息 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


