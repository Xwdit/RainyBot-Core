[font_size=25][b][color=#70bafa]类:[/color] NewFriendRequestEvent[/b][/font_size]
[color=#70bafa]继承:[/color] RequestEvent


[b]RainyBot的添加好友请求事件类，其实例记录了与一次添加好友请求事件相关的数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿RespondType￿

	可用于回应请求的回应类型

		● ACCEPT [color=gray]= 0[/color]
		[color=gray]接受好友添加请求[/color]

		● REFUSE [color=gray]= 1[/color]
		[color=gray]拒绝好友添加请求[/color]

		● REFUSE_BLACKLIST [color=gray]= 2[/color]
		[color=gray]拒绝好友添加请求并加入黑名单[/color]



[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]NewFriendRequestEvent[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用



