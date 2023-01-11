[font_size=25][b][color=#70bafa]类:[/color] BotUnmuteEvent[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:GroupBotEvent]GroupBotEvent[/url]


[b]RainyBot的Bot自身在群组中被解除禁言事件类，其实例记录了与一次Bot自身在群组中被解除禁言事件相关的数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:BotUnmuteEvent]BotUnmuteEvent[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=api:GroupMember]GroupMember[/url][/color] ￿get_operator￿ [color=gray]([/color] [color=gray])[/color]

	获取导致此事件的操作者的成员实例，可能是事件对应群组的管理员或群主


	● [color=#70bafa][url=api:Group]Group[/url][/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取此事件实例所对应的群组实例


