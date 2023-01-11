[font_size=25][b][color=#70bafa]类:[/color] TempMessageEvent[/b][/font_size]
[color=#70bafa]继承:[/color] MessageEvent


[b]RainyBot的群临时消息事件类，其实例记录了与一次群临时消息事件相关的数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]TempMessageEvent[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]GroupMember[/color] ￿get_sender￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件对应的发送者的群组成员实例


	● [color=#70bafa]Group[/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件所对应的来源群组的实例



