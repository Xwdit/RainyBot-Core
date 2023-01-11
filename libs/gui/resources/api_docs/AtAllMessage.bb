[font_size=25][b][color=#70bafa]类:[/color] AtAllMessage[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:Message]Message[/url]


[b]RainyBot的At全体成员消息类，通常代表一个对应实例，此类消息仅适用于群聊[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的At全体成员消息类，通常代表一个对应实例，此类消息仅适用于群聊 
此类实例代表在消息中At了全体成员，你也可以主动构建此类实例以便进行此操作


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa][url=api:AtAllMessage]AtAllMessage[/url][/color] ￿init￿ [color=gray]([/color] [color=gray])[/color]

	手动构造一个AtAllMessage类的实例，以便在消息中At全体成员


	● [color=gray]static[/color] [color=#70bafa][url=api:AtAllMessage]AtAllMessage[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个AtAllMessage类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式


