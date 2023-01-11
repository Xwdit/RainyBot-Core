[font_size=25][b][color=#70bafa]类:[/color] FriendMessageEvent[/b][/font_size]
[color=#70bafa]继承:[/color] MessageEvent


[b]RainyBot的好友消息事件类，其实例记录了与一次好友消息事件相关的数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]FriendMessageEvent[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Member[/color] ￿get_sender￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件对应的发送者的好友成员实例


