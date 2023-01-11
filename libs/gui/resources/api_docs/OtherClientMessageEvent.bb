[font_size=25][b][color=#70bafa]类:[/color] OtherClientMessageEvent[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:MessageEvent]MessageEvent[/url]


[b]RainyBot的其它客户端消息事件类，其实例记录了与一次其它客户端消息事件相关的数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:OtherClientMessageEvent]OtherClientMessageEvent[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=api:OtherClient]OtherClient[/url][/color] ￿get_sender￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件对应的其它客户端的实例


