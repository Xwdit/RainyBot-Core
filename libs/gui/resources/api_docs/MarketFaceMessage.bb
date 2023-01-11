[font_size=25][b][color=#70bafa]类:[/color] MarketFaceMessage[/b][/font_size]
[color=#70bafa]继承:[/color] Message


[b]RainyBot的商城表情消息类，其实例记录了与一个商城表情消息相关的各类数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]MarketFaceMessage[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_face_id￿ [color=gray]([/color] [color=gray])[/color]

	获取实例对应的商城表情的ID


	● [color=#70bafa]String[/color] ￿get_face_name￿ [color=gray]([/color] [color=gray])[/color]

	获取实例对应的商城表情的名称


	● [color=#70bafa]String[/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式



