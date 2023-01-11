[font_size=25][b][color=#70bafa]类:[/color] GroupAllowConfessTalkEvent[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:GroupEvent]GroupEvent[/url]


[b]RainyBot的群组坦白说允许状态变更类，其实例记录了与一次群组坦白说允许状态变更事件相关的数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa][url=api:GroupAllowConfessTalkEvent]GroupAllowConfessTalkEvent[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿get_origin_state￿ [color=gray]([/color] [color=gray])[/color]

	获取变更前的坦白说允许状态


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿get_current_state￿ [color=gray]([/color] [color=gray])[/color]

	获取变更后当前的坦白说允许状态


	● [color=#70bafa][url=api:GroupMember]GroupMember[/url][/color] ￿get_operator￿ [color=gray]([/color] [color=gray])[/color]

	获取导致此事件的操作者的成员实例，可能是事件对应群组的管理员或群主


	● [color=#70bafa][url=api:Group]Group[/url][/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件实例所对应的群组实例


