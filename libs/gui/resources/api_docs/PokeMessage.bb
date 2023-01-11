[font_size=25][b][color=#70bafa]类:[/color] PokeMessage[/b][/font_size]
[color=#70bafa]继承:[/color] Message


[b]RainyBot的戳一戳消息类，其实例记录了与一个戳一戳消息相关的各类数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿PokeType￿

	戳一戳消息的类型

		● POKE [color=gray]= 0[/color]
		[color=gray]戳一戳[/color]

		● SHOW_LOVE [color=gray]= 1[/color]
		[color=gray]比心[/color]

		● LIKE [color=gray]= 2[/color]
		[color=gray]点赞[/color]

		● HEART_BROKEN [color=gray]= 3[/color]
		[color=gray]心碎[/color]

		● SIX_SIX_SIX [color=gray]= 4[/color]
		[color=gray]六六六[/color]

		● FANG_DA_ZHAO [color=gray]= 5[/color]
		[color=gray]放大招[/color]



[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]PokeMessage[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]int[/color] type [color=gray])[/color]

	基于指定的戳一戳类型来手动构造一个PokeMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]PokeMessage[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_poke_type￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的戳一戳类型


	● [color=gray]void[/color] ￿set_poke_type￿ [color=gray]([/color] [color=#70bafa]int[/color] type [color=gray])[/color]

	设置此实例对应的戳一戳类型


	● [color=#70bafa]bool[/color] ￿is_poke_type￿ [color=gray]([/color] [color=#70bafa]int[/color] type [color=gray])[/color]

	判断此实例是否为指定的戳一戳类型


	● [color=#70bafa]String[/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式



