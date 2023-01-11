[font_size=25][b][color=#70bafa]类:[/color] ForwardMessage[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:Message]Message[/url]


[b]RainyBot的转发消息类，其实例记录了与一个转发消息相关的各类数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa][url=api:ForwardMessage]ForwardMessage[/url][/color] ￿init￿ [color=gray]([/color] [color=#70bafa][url=api:ForwardMessageNodeList]ForwardMessageNodeList[/url][/color] node_list [color=gray])[/color]

	基于指定的转发消息列表实例来手动构造一个ForwardMessage实例


	● [color=gray]static[/color] [color=#70bafa][url=api:ForwardMessage]ForwardMessage[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=api:ForwardMessageNodeList]ForwardMessageNodeList[/url][/color] ￿get_node_list￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的转发消息列表实例


	● [color=gray][hint=此函数无返回值]void[/hint][/color] ￿set_node_list￿ [color=gray]([/color] [color=#70bafa][url=api:ForwardMessageNodeList]ForwardMessageNodeList[/url][/color] node_list [color=gray])[/color]

	设置此实例对应的转发消息列表实例


