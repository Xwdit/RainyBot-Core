[font_size=25][b][color=#70bafa]类:[/color] FriendRecallEvent[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:FriendEvent]FriendEvent[/url]


[b]RainyBot的好友消息撤回事件类，记录了某次好友消息撤回事件的相关数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa][url=api:FriendRecallEvent]FriendRecallEvent[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_sender_id￿ [color=gray]([/color] [color=gray])[/color]

	获取事件原消息发送者的ID


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_message_id￿ [color=gray]([/color] [color=gray])[/color]

	获取事件对应的原消息的ID


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_message_time￿ [color=gray]([/color] [color=gray])[/color]

	获取事件对应的原消息的发送时间


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_operator_id￿ [color=gray]([/color] [color=gray])[/color]

	获取造成此事件的成员的ID(通常为此事件对应的好友的ID或Bot自身的ID)


