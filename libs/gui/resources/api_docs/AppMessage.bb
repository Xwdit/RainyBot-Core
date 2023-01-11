[font_size=25][b][color=#70bafa]类:[/color] AppMessage[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:Message]Message[/url]


[b]RainyBot的App消息类，通常代表一个对应实例，此类消息常见于某些特殊App调用聊天软件进行分享的场景[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的App消息类，通常代表一个对应实例，此类消息常见于某些特殊App调用聊天软件进行分享的场景 
此类实例中储存了App消息的代码原文本，你也可以基于指定APP消息代码文本来构建一个此类实例


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa][url=api:AppMessage]AppMessage[/url][/color] ￿init￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	基于指定的App消息代码文本来手动构造一个AppMessage类的实例


	● [color=gray]static[/color] [color=#70bafa][url=api:AppMessage]AppMessage[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个AppMessage类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_app_text￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的App消息代码文本


	● [color=gray][hint=此函数无返回值]void[/hint][/color] ￿set_app_text￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	更改实例中储存的App消息代码文本


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式


