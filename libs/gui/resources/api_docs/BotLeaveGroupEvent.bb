[font_size=25][b][color=#70bafa]类:[/color] BotLeaveGroupEvent[/b][/font_size]
[color=#70bafa]继承:[/color] GroupBotEvent


[b]RainyBot的Bot自身退出群组事件类，记录了Bot退出某个群组相关事件的数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿ReasonType￿

	Bot退出群组的原因类型枚举

		● ACTIVE [color=gray]= 0[/color]
		[color=gray]Bot主动退出群组[/color]

		● KICK [color=gray]= 1[/color]
		[color=gray]Bot被踢出群组[/color]

		● DISBAND [color=gray]= 2[/color]
		[color=gray]Bot因群解散退出群组[/color]



[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]BotLeaveGroupEvent[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic, [color=#70bafa]int[/color] reason_type [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Member[/color] ￿get_operator￿ [color=gray]([/color] [color=gray])[/color]

	获取造成此事件的成员实例，可能是Bot自身，对应群的管理员，或对应群的群主


	● [color=#70bafa]Group[/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件对应的群组的实例


	● [color=#70bafa]int[/color] ￿get_reason_type￿ [color=gray]([/color] [color=gray])[/color]

	获取Bot退出群组的原因的类型，可用类型请参见此类的ReasonType枚举


	● [color=#70bafa]bool[/color] ￿is_reason_type￿ [color=gray]([/color] [color=#70bafa]int[/color] reason [color=gray])[/color]

	用于判断Bot退出群组的原因是否为指定的类型，可用类型请参见此类的ReasonType枚举



