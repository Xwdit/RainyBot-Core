[font_size=25][b][color=#70bafa]类:[/color] BotCodeMessage[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:Message]Message[/url]


[b]RainyBot的BotCode消息类，通常代表一个对应实例，可用于快捷发送一段包含多种类型的消息[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的BotCode消息类，通常代表一个对应实例，可用于快捷发送一段包含多种类型的消息 
此类实例通常不会出现在消息链中，而是用于主动构建此类实例以便快捷发送消息


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:BotCodeMessage]BotCodeMessage[/url][/color] ￿init￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	基于包含BotCode的文本来构造BotCodeMessage的实例，以便快捷发送复杂消息


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:BotCodeMessage]BotCodeMessage[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个BotCodeMessage类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_code_text￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的BotCode文本


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_code_text￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	更改实例中储存的BotCode文本


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式


