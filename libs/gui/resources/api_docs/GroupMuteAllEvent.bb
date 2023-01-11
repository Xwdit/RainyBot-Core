[font_size=25][b][color=#70bafa]类:[/color] GroupMuteAllEvent[/b][/font_size]
[color=#70bafa]继承:[/color] GroupEvent


[b]RainyBot的群组全员禁言状态变更类，其实例记录了与一次群组全员禁言状态变更事件相关的数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]GroupMuteAllEvent[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]bool[/color] ￿get_origin_state￿ [color=gray]([/color] [color=gray])[/color]

	获取变更前的全员禁言状态


	● [color=#70bafa]bool[/color] ￿get_current_state￿ [color=gray]([/color] [color=gray])[/color]

	获取变更后当前的全员禁言状态


	● [color=#70bafa]GroupMember[/color] ￿get_operator￿ [color=gray]([/color] [color=gray])[/color]

	获取导致此事件的操作者的成员实例，可能是事件对应群组的管理员或群主


	● [color=#70bafa]Group[/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件实例所对应的群组实例

