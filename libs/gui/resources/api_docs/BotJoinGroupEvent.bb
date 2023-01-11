[font_size=25][b][color=#70bafa]类:[/color] BotJoinGroupEvent[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:GroupBotEvent]GroupBotEvent[/url]


[b]RainyBot的Bot自身加入群组事件，记录了Bot加入某个群组的事件的相关数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa][url=api:BotJoinGroupEvent]BotJoinGroupEvent[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=api:Member]Member[/url][/color] ￿get_invitor￿ [color=gray]([/color] [color=gray])[/color]

	获取邀请机器人加入群聊的邀请者的成员实例


	● [color=#70bafa][url=api:Group]Group[/url][/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件对应的	机器人所加入的群聊的实例


