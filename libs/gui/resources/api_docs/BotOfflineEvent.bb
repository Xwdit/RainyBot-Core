[font_size=25][b][color=#70bafa]类:[/color] BotOfflineEvent[/b][/font_size]
[color=#70bafa]继承:[/color] BotEvent


[b]RainyBot的机器人账号离线事件类，其实例记录了一次机器人账号离线事件的相关数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿ReasonType￿

	机器人账号的离线原因类型的枚举

		● ACTIVE [color=gray]= 0[/color]
		[color=gray]机器人账号主动离线[/color]

		● FORCE [color=gray]= 1[/color]
		[color=gray]机器人账号被挤下线(如其他客户端登录等情况)[/color]

		● DROPPED [color=gray]= 2[/color]
		[color=gray]机器人账号意外掉线(网络原因或服务器原因等)[/color]



[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]BotOfflineEvent[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic, [color=#70bafa]int[/color] reason_type [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_reason_type￿ [color=gray]([/color] [color=gray])[/color]

	获取机器人离线事件的原因类型，可用类型请参见此类的ReasonType枚举


	● [color=#70bafa]bool[/color] ￿is_reason_type￿ [color=gray]([/color] [color=#70bafa]int[/color] reason [color=gray])[/color]

	判定机器人离线事件是否是指定类型的原因，可用类型请参见此类的ReasonType枚举



