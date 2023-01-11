[font_size=25][b][color=#70bafa]类:[/color] AtMessage[/b][/font_size]
[color=#70bafa]继承:[/color] Message


[b]RainyBot的At消息类，通常代表一个对应实例，此类消息仅适用于群聊[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的At消息类，通常代表一个对应实例，此类消息仅适用于群聊 [br]此类实例代表在消息中At了某群组成员，你也可以主动构建此类实例以便进行此操作


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]AtMessage[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]int[/color] target_id [color=gray])[/color]

	手动构造一个AtMessage类的实例，以便在消息中At某群组成员 
	
	需要传入想要At的群组成员的ID作为参数


	● [color=gray]static[/color] [color=#70bafa]AtMessage[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个AtMessage类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_target_id￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的被At的群组成员的ID


	● [color=gray]void[/color] ￿set_target_id￿ [color=gray]([/color] [color=#70bafa]int[/color] target_id [color=gray])[/color]

	更改实例中储存的想要At的群组成员的ID


	● [color=#70bafa]String[/color] ￿get_display_text￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的被At的群组成员的显示信息(如@啦啦啦) 
	
	若为手动构造的实例，将始终返回空字符串


	● [color=#70bafa]String[/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式



