[font_size=25][b][color=#70bafa]类:[/color] CacheMessage[/b][/font_size]
[color=#70bafa]继承:[/color] MessageAPI


[b]RainyBot的缓存消息类，通常代表一个对应实例，用于储存从机器人后端缓存中读取的消息的相关信息[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的缓存消息类，通常代表一个对应实例，用于储存从机器人后端缓存中读取的消息的相关信息 [br]此类实例中通常储存了消息对应的消息链，以及消息对应的发送者实例等信息


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]CacheMessage[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个CacheMessage类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Dictionary[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa]MessageChain[/color] ￿get_message_chain￿ [color=gray]([/color] [color=gray])[/color]

	获取缓存消息实例中储存的消息对应的消息链


	● [color=#70bafa]RoleAPI[/color] ￿get_sender￿ [color=gray]([/color] [color=gray])[/color]

	获取缓存消息实例中储存的消息对应的发送者实例 
	
	返回的类型不定，可能返回Member,GroupMember或OtherClient类的实例


