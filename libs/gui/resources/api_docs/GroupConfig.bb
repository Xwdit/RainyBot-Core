[font_size=25][b][color=#70bafa]类:[/color] GroupConfig[/b][/font_size]
[color=#70bafa]继承:[/color] GroupAPI


[b]RainyBot的群组配置类，通常代表一个对应实例，储存了与群组各类配置有关的信息[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的群组配置类，通常代表一个对应实例，储存了与群组各类配置有关的信息 [br]对此类实例中内容的更改不会直接影响群组的配置，需要在更改完成后于群组实例中将此类实例设定为群组配置


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]GroupConfig[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个GroupConfig类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Dictionary[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa]String[/color] ￿get_name￿ [color=gray]([/color] [color=gray])[/color]

	获取群组配置实例中储存的群名称


	● [color=#70bafa]String[/color] ￿get_announcement￿ [color=gray]([/color] [color=gray])[/color]

	获取群组配置实例中储存的入群公告


	● [color=#70bafa]bool[/color] ￿get_confess_talk￿ [color=gray]([/color] [color=gray])[/color]

	获取群组配置实例中储存的坦白说启用状态


	● [color=#70bafa]bool[/color] ￿get_allow_member_invite￿ [color=gray]([/color] [color=gray])[/color]

	获取群组配置实例中储存的允许邀请入群启用状态


	● [color=#70bafa]bool[/color] ￿get_auto_approve￿ [color=gray]([/color] [color=gray])[/color]

	获取群组配置实例中储存的自动入群审批启用状态


	● [color=#70bafa]bool[/color] ￿get_anonymous_chat￿ [color=gray]([/color] [color=gray])[/color]

	获取群组配置实例中储存的匿名聊天启用状态


	● [color=gray]void[/color] ￿set_name￿ [color=gray]([/color] [color=#70bafa]String[/color] name [color=gray])[/color]

	更改群组配置实例中储存的群名称


	● [color=gray]void[/color] ￿set_announcement￿ [color=gray]([/color] [color=#70bafa]String[/color] text [color=gray])[/color]

	更改群组配置实例中储存的入群公告


	● [color=gray]void[/color] ￿set_confess_talk￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled [color=gray])[/color]

	更改群组配置实例中储存的坦白说启用状态


	● [color=gray]void[/color] ￿set_allow_member_invite￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled [color=gray])[/color]

	更改群组配置实例中储存的允许邀请入群启用状态


	● [color=gray]void[/color] ￿set_auto_approve￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled [color=gray])[/color]

	更改群组配置实例中储存的自动入群审批启用状态


	● [color=gray]void[/color] ￿set_anonymous_chat￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled [color=gray])[/color]

	更改群组配置实例中储存的匿名聊天启用状态


