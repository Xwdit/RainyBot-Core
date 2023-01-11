[font_size=25][b][color=#70bafa]类:[/color] GroupAnnounceInfoList[/b][/font_size]
[color=#70bafa]继承:[/color] GroupAPI


[b]RainyBot的群公告信息列表类，储存了从某个群组中获取的群公告的列表[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的群公告信息列表类，储存了从某个群组中获取的群公告的列表 [br]你可以像数组/字典一样直接使用for x in x的语法来循环列表中的所有公告信息(将返回[GroupAnnounceInfo]类实例)


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]GroupAnnounceInfoList[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Array[/color] arr [color=gray])[/color]

	通过机器人协议后端的元数据数组构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Array[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据数组，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Array[/color] arr [color=gray])[/color]

	使用指定字典覆盖实例中的元数据数组，仅当你知道自己在做什么时才使用


	● [color=#70bafa]GroupAnnounceInfo[/color] ￿get_from_index￿ [color=gray]([/color] [color=#70bafa]int[/color] index [color=gray])[/color]

	根据指定的序号来从群公告信息列表实例中获取对应的[GroupAnnounceInfo]实例 
	
	若序号不存在则返回null


	● [color=#70bafa]GroupAnnounceInfo[/color] ￿get_from_id￿ [color=gray]([/color] [color=#70bafa]int[/color] announce_id [color=gray])[/color]

	根据指定的群公告ID来从群公告信息列表实例中获取对应的[GroupAnnounceInfo]实例 
	
	若群公告ID不存在则返回null


	● [color=#70bafa]bool[/color] ￿has_announce￿ [color=gray]([/color] [color=#70bafa]int[/color] announce_id [color=gray])[/color]

	判断群公告信息列表实例中是否存在指定ID的群公告信息实例


	● [color=#70bafa]int[/color] ￿get_size￿ [color=gray]([/color] [color=gray])[/color]

	获取群公告信息列表实例中的群公告信息实例的总数


