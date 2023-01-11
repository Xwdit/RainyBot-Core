[font_size=25][b][color=#70bafa]类:[/color] MemberLeaveEvent[/b][/font_size]
[color=#70bafa]继承:[/color] GroupMemberEvent


[b]RainyBot的群成员退群类，其实例记录了与一次群成员退群事件相关的数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿ReasonType￿

	群成员退群的原因

		● QUIT [color=gray]= 0[/color]
		[color=gray]群成员自行主动退群[/color]

		● KICK [color=gray]= 1[/color]
		[color=gray]群成员被管理员/群主踢出群聊[/color]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]MemberLeaveEvent[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic, [color=#70bafa]int[/color] reason_type [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]GroupMember[/color] ￿get_member￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件对应的群成员实例


	● [color=#70bafa]GroupMember[/color] ￿get_operator￿ [color=gray]([/color] [color=gray])[/color]

	获取导致此事件的操作者的成员实例，可能是事件对应群组的管理员或群主，也可能是群成员自身


	● [color=#70bafa]Group[/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件所发生的群组实例


	● [color=#70bafa]int[/color] ￿get_reason_type￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件发生的原因类型，详见上方的ReasonType枚举


	● [color=#70bafa]bool[/color] ￿is_reason_type￿ [color=gray]([/color] [color=#70bafa]int[/color] reason [color=gray])[/color]

	判断此事件的发生是否为指定的原因类型


