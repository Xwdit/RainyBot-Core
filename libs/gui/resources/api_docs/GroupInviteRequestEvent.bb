[font_size=25][b][color=#70bafa]类:[/color] GroupInviteRequestEvent[/b][/font_size]
[color=#70bafa]继承:[/color] RequestEvent


[b]RainyBot的邀请入群请求事件类，其实例记录了与一次邀请入群请求事件相关的数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿RespondType￿

	可用于回应请求的回应类型

		● ACCEPT [color=gray]= 0[/color]
		[color=gray]接受入群邀请[/color]

		● REFUSE [color=gray]= 1[/color]
		[color=gray]拒绝入群邀请[/color]



[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]GroupInviteRequestEvent[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]String[/color] ￿get_group_name￿ [color=gray]([/color] [color=gray])[/color]

	获取事件对应的被邀请加入的群的名称



