[font_size=25][b][color=#70bafa]类:[/color] Event[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:EventAPI]EventAPI[/url]
[color=#70bafa]派生:[/color] [url=api:ActionEvent]ActionEvent[/url], [url=api:BotEvent]BotEvent[/url], [url=api:FriendEvent]FriendEvent[/url], [url=api:GroupEvent]GroupEvent[/url], [url=api:MessageEvent]MessageEvent[/url], [url=api:OtherClientEvent]OtherClientEvent[/url], [url=api:RequestEvent]RequestEvent[/url]


[b]RainyBot的事件类，各种事件类型将直接或间接继承此类[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


