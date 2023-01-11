[font_size=25][b][color=#70bafa]类:[/color] GroupAnnounceInfo[/b][/font_size]
[color=#70bafa]继承:[/color] GroupAPI


[b]RainyBot的群公告信息类，其实例记录了一个已发送的群公告的相关信息[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的群公告信息类，其实例记录了一个已发送的群公告的相关信息 [br]此类实例通常不应被手动构造，而是由诸如获取群公告一类的方法返回


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]GroupAnnounceInfo[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Dictionary[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa]String[/color] ￿get_id￿ [color=gray]([/color] [color=gray])[/color]

	获取此群公告的唯一ID，可用于后续删除等操作


	● [color=#70bafa]Group[/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取此群公告相关的群的实例


	● [color=#70bafa]String[/color] ￿get_content￿ [color=gray]([/color] [color=gray])[/color]

	获取此群公告中包含的内容文本


	● [color=#70bafa]int[/color] ￿get_sender_id￿ [color=gray]([/color] [color=gray])[/color]

	获取此群公告的发送者的ID


	● [color=#70bafa]bool[/color] ￿is_all_confirmed￿ [color=gray]([/color] [color=gray])[/color]

	获取此群公告是否已被全体群成员确认


	● [color=#70bafa]int[/color] ￿get_confirmed_count￿ [color=gray]([/color] [color=gray])[/color]

	获取已确认此群公告的群成员人数


	● [color=#70bafa]int[/color] ￿get_public_timestamp￿ [color=gray]([/color] [color=gray])[/color]

	获取此群公告发布时间的时间戳


