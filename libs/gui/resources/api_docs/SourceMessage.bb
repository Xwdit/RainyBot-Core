[font_size=25][b][color=#70bafa]类:[/color] SourceMessage[/b][/font_size]
[color=#70bafa]继承:[/color] Message


[b]RainyBot的消息链源消息类，其实例记录了某个接收到的消息链的消息ID，发送时间等数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]SourceMessage[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_message_id￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的消息链的ID


	● [color=#70bafa]int[/color] ￿get_timestamp￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的消息链的发送时间戳


	● [color=#70bafa]String[/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式


