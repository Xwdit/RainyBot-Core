[font_size=25][b][color=#70bafa]类:[/color] MessageChain[/b][/font_size]
[color=#70bafa]继承:[/color] MessageAPI


[b]RainyBot的消息链类，通常代表一个对应实例，为多个不同类型的消息类实例依序拼接而成的单条消息[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的消息链类，通常代表一个对应实例，为多个不同类型的消息类实例依序拼接而成的单条消息 [br]例如当需要在一条消息中同时AT多个对象并附上一段文字，就需要构造并发送一个由多个AT类和一个文本类消息实例所组成的消息链 [br]你可以像数组/字典一样直接使用for x in x的语法来循环列表中的所有消息实例(将返回Message子类的实例)


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]MessageChain[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]Variant[/color] msg [color=gray])[/color]

	手动构造一个MessageChain类的实例，以便将多种消息合并为单条消息发送 
	
	传入的参数可以是以下类型: 
	- 字符串(将自动构造为文本消息实例，解析其中的BotCode，并将其作为消息链中的第一个消息实例) 
	- 单个消息实例(将其作为消息链中的第一个消息实例) 
	- 消息链实例(将其内容复制并添加到此消息链) 
	- 包含以上三种类型实例的数组(将按照上方规则将数组中的实例依次添加至此消息链) 
	- 已知的消息ID(以便对此ID关联的消息进行如撤回一类的操作)


	● [color=gray]static[/color] [color=#70bafa]MessageChain[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Array[/color] arr [color=gray])[/color]

	通过机器人协议后端的元数据数组构造一个MessageChain类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Array[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据数组，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Array[/color] arr [color=gray])[/color]

	使用指定数组覆盖实例中的元数据数组，仅当你知道自己在做什么时才使用


	● [color=#70bafa]MessageChain[/color] ￿append￿ [color=gray]([/color] [color=#70bafa]Variant[/color] msg [color=gray])[/color]

	将参数中的内容添加到此消息链实例中，并返回此消息链实例自身，以便于进行连续操作 
	
	可以进行如"MessageChain.init(TextMessage.init("你好")).append(AtMessage.init(12345)).append("啦啦啦")"一类的操作 
	
	传入的参数可以是以下类型: 
	- 字符串(将自动构造为文本消息实例，解析其中的BotCode，并将其作为消息链中的第一个消息实例) 
	- 单个消息实例(将其作为消息链中的第一个消息实例) 
	- 消息链实例(将其内容复制并添加到此消息链) 
	- 包含以上三种类型实例的数组(将按照上方规则将数组中的实例依次添加至此消息链)


	● [color=#70bafa]int[/color] ￿get_size￿ [color=gray]([/color] [color=gray])[/color]

	获取消息链实例中的消息实例的总数


	● [color=#70bafa]Message[/color] ￿get_message￿ [color=gray]([/color] [color=#70bafa]int[/color] index [color=gray])[/color]

	根据指定的序号来从消息链实例中获取对应的Message子类实例 
	
	若序号不存在则返回null


	● [color=#70bafa]Array[/color] ￿get_message_array￿ [color=gray]([/color] [color=#70bafa]Variant[/color] types[color=gray] = null[/color], [color=#70bafa]bool[/color] exclude[color=gray] = false[/color], [color=#70bafa]int[/color] max_size[color=gray] = -1[/color] [color=gray])[/color]

	根据指定的条件，来从消息链实例中获取由符合条件的消息类实例组成的数组 
	
	可以传入的参数从左到右分别为: 
	
	所需的单个Message子类或包含多种Message子类的数组(例如需要从消息链中获取所有的At类消息与Text类消息，则为[AtMessage,TextMessage]，为空将获取所有消息) 
	
	是否为排除模式(若为true，则将获取除上个参数的列表以外的所有消息类实例) 
	
	获取的消息数量的上限(若不为-1，则获取到的消息实例总数到达上限后将直接返回对应数组)


	● [color=#70bafa]String[/color] ￿get_message_text￿ [color=gray]([/color] [color=#70bafa]Variant[/color] types[color=gray] = null[/color], [color=#70bafa]bool[/color] exclude[color=gray] = false[/color] [color=gray])[/color]

	根据指定的条件，来从消息链实例中获取由符合条件的消息类实例转换并拼接而成的单个字符串 
	
	转换为字符串的具体行为请参见不同Message子类中的get_as_text()方法 
	
	可以传入的参数从左到右分别为: 
	
	所需的单个Message子类或包含多种Message子类的数组(例如需要从消息链中获取所有的At类消息与Text类消息，则为[AtMessage,TextMessage]，为空将获取所有消息) 
	
	是否为排除模式(若为true，则将获取除上个参数的列表以外的所有消息类实例)


	● [color=#70bafa]int[/color] ￿get_message_id￿ [color=gray]([/color] [color=gray])[/color]

	获取消息链实例的消息ID，若为手动且不基于ID构造的消息链实例，则始终返回0


	● [color=#70bafa]int[/color] ￿get_message_timestamp￿ [color=gray]([/color] [color=gray])[/color]

	获取消息链实例的发送时间戳，若为手动构造的消息链实例，则始终返回0


	● [color=#70bafa]bool[/color] ￿has_message_type￿ [color=gray]([/color] [color=#70bafa]Variant[/color] type [color=gray])[/color]

	判断消息链实例中是否存在指定类型的消息类实例 
	
	传入的参数可以是单个消息类型，也可以是包含了多种消息类型的数组，如[AtMessage,TextMessage] 
	
	若传入参数为数组，则仅当消息链中拥有数组中所有类型时才返回true


	● [color=#70bafa]bool[/color] ￿is_at_bot￿ [color=gray]([/color] [color=gray])[/color]

	用于快捷判断消息链实例中是否包含目标为机器人的AT类消息实例


