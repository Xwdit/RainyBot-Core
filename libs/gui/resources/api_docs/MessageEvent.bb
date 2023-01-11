[font_size=25][b][color=#70bafa]类:[/color] MessageEvent[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:Event]Event[/url]
[color=#70bafa]派生:[/color] [url=api:FriendMessageEvent]FriendMessageEvent[/url], [url=api:GroupMessageEvent]GroupMessageEvent[/url], [url=api:OtherClientMessageEvent]OtherClientMessageEvent[/url], [url=api:StrangerMessageEvent]StrangerMessageEvent[/url], [url=api:TempMessageEvent]TempMessageEvent[/url]


[b]RainyBot的消息事件类，与消息直接相关的各类事件通常直接或间接继承此类[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=#70bafa][url=api:MessageChain]MessageChain[/url][/color] ￿get_message_chain￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件所对应的消息内容的消息链实例


	● [color=#70bafa][url=godot:Array]Array[/url][/color] ￿get_message_array￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] types[color=gray] = null[/color], [color=#70bafa][url=godot:bool]bool[/url][/color] exclude[color=gray] = false[/color], [color=#70bafa][url=godot:int]int[/url][/color] max_size[color=gray] = -1[/color] [color=gray])[/color]

	根据指定的条件，来从消息事件包含的消息链实例中获取由符合条件的消息类实例组成的数组 
	
	可以传入的参数从左到右分别为: 
	
	所需的单个Message子类，或包含多种Message子类的数组(例如需要从消息链中获取所有的At类消息与Text类消息，则为[AtMessage,TextMessage]，为空将获取所有消息) 
	
	是否为排除模式(若为true，则将获取除上个参数的列表以外的所有消息类实例) 
	
	获取的消息数量的上限(若不为-1，则获取到的消息实例总数到达上限后将直接返回对应数组


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_message_text￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] types[color=gray] = null[/color], [color=#70bafa][url=godot:bool]bool[/url][/color] exclude[color=gray] = false[/color] [color=gray])[/color]

	根据指定的条件，来从消息事件包含的消息链实例中获取由符合条件的消息类实例转换并拼接而成的单个字符串 
	
	转换为字符串的具体行为请参见不同Message子类中的get_as_text()方法 
	
	可以传入的参数从左到右分别为: 
	
	所需的单个Message子类，或包含多种Message子类的数组(例如需要从消息链中获取所有的At类消息与Text类消息，则为[AtMessage,TextMessage]，为空将获取所有消息) 
	
	是否为排除模式(若为true，则将获取除上个参数的列表以外的所有消息类实例)


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_message_id￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件所对应的消息的ID


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_message_timestamp￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件所对应的消息的发送时间戳


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_sender_id￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件所对应的消息的发送者ID


	● [color=#70bafa][url=api:BotRequestResult]BotRequestResult[/url][/color] ￿reply￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] msg, [color=#70bafa][url=godot:bool]bool[/url][/color] quote[color=gray] = false[/color], [color=#70bafa][url=godot:bool]bool[/url][/color] at[color=gray] = false[/color], [color=#70bafa][url=godot:float]float[/url][/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于回应某个消息事件，同时可指定是否需要引用回复原消息，以及是否需要AT原发送者(仅在群消息事件有效) 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	传入的第一个参数可以是以下类型: 
	- 字符串(将自动构造为文本消息实例，解析其中的BotCode，并将其作为消息链中的唯一消息实例发送) 
	- 单个消息实例(将其作为消息链中的唯一消息实例发送) 
	- 消息链实例(将其内容复制并发送) 
	- 包含以上三种类型实例的数组(将按照上方规则将数组中的实例依次合并添加至一个消息链并发送) 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


