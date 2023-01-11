[font_size=25][b][color=#70bafa]类:[/color] NudgeEvent[/b][/font_size]
[color=#70bafa]继承:[/color] ActionEvent


[b]RainyBot的戳一戳事件类，记录了聊天中的一个戳一戳事件的相关数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿SubjectType￿

	戳一戳事件发生的上下文位置类型，可以是好友聊天或群聊

		● FRIEND [color=gray]= 0[/color]
		[color=gray]事件发生在好友聊天中[/color]

		● GROUP [color=gray]= 1[/color]
		[color=gray]事件发生在群组聊天中[/color]



[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]NudgeEvent[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_sender_id￿ [color=gray]([/color] [color=gray])[/color]

	获取戳一戳事件的发送者ID


	● [color=#70bafa]int[/color] ￿get_subject_id￿ [color=gray]([/color] [color=gray])[/color]

	获取戳一戳事件发生的上下文ID，例如在群聊中时应为群号


	● [color=#70bafa]int[/color] ￿get_target_id￿ [color=gray]([/color] [color=gray])[/color]

	获取戳一戳事件的接收者(目标)的ID


	● [color=#70bafa]int[/color] ￿get_subject_type￿ [color=gray]([/color] [color=gray])[/color]

	获取戳一戳事件发生的上下文位置类型，可用类型请参见上方的SubjectType枚举


	● [color=#70bafa]bool[/color] ￿is_subject_type￿ [color=gray]([/color] [color=#70bafa]int[/color] type [color=gray])[/color]

	用于判断戳一戳事件是否发生在指定的上下文位置类型


	● [color=#70bafa]String[/color] ￿get_action_text￿ [color=gray]([/color] [color=gray])[/color]

	获取戳一戳事件的动作文本


	● [color=#70bafa]String[/color] ￿get_suffix_text￿ [color=gray]([/color] [color=gray])[/color]

	获取戳一戳事件的后缀文本



