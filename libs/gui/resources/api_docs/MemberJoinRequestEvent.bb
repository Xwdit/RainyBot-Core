[font_size=25][b][color=#70bafa]类:[/color] MemberJoinRequestEvent[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:RequestEvent]RequestEvent[/url]


[b]RainyBot的新成员入群请求事件类，其实例记录了与一次新成员入群请求事件相关的数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿RespondType￿

	可用于回应请求的回应类型

		● ACCEPT [color=gray]= 0[/color]
		[color=gray]允许新成员入群[/color]

		● REFUSE [color=gray]= 1[/color]
		[color=gray]拒绝新成员入群[/color]

		● IGNORE [color=gray]= 2[/color]
		[color=gray]忽略新成员的入群请求[/color]

		● REFUSE_BLACKLIST [color=gray]= 3[/color]
		[color=gray]拒绝新成员入群并加入黑名单[/color]

		● IGNORE_BLACKLIST [color=gray]= 4[/color]
		[color=gray]忽略新成员的入群请求并加入黑名单[/color]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:MemberJoinRequestEvent]MemberJoinRequestEvent[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_group_name￿ [color=gray]([/color] [color=gray])[/color]

	获取事件对应的新成员希望加入的群的名称


