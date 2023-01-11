[font_size=25][b][color=#70bafa]类:[/color] MemberHonorChangeEvent[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:GroupMemberEvent]GroupMemberEvent[/url]


[b]RainyBot的群成员荣誉变更类，其实例记录了与一次群成员荣誉变更事件相关的数据[/b]


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿ActionType￿

	群荣誉更改的操作类型

		● ACHIEVE [color=gray]= 0[/color]
		[color=gray]群成员获得了新的群荣誉[/color]

		● LOST [color=gray]= 1[/color]
		[color=gray]群成员失去了一个群荣誉[/color]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:MemberHonorChangeEvent]MemberHonorChangeEvent[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=api:GroupMember]GroupMember[/url][/color] ￿get_member￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件对应的群成员实例


	● [color=#70bafa][url=api:Group]Group[/url][/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件所发生的群组实例


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_honor_name￿ [color=gray]([/color] [color=gray])[/color]

	获取被变更的群荣誉的名称


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_action_type￿ [color=gray]([/color] [color=gray])[/color]

	获取本次事件的变更类型，详见上方的ActionType枚举


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿is_action_type￿ [color=gray]([/color] [color=#70bafa][url=godot:int]int[/url][/color] action [color=gray])[/color]

	用于判断本次事件是否为指定的变更类型


