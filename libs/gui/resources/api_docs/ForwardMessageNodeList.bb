[font_size=25][b][color=#70bafa]类:[/color] ForwardMessageNodeList[/b][/font_size]
[color=#70bafa]继承:[/color] MessageAPI


[b]RainyBot的转发消息列表类，通常代表一个对应实例，储存了某条合并转发消息中的所有单条转发消息[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的转发消息列表类，通常代表一个对应实例，储存了某条合并转发消息中的所有单条转发消息 [br]你可以像数组/字典一样直接使用for x in x的语法来循环列表中的所有单条转发消息(将返回ForwardMessageNode类实例)


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]ForwardMessageNodeList[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]Variant[/color] msg_node [color=gray])[/color]

	手动构造一个ForwardMessageNodeList类的实例，以便将多个单条转发消息进行合并转发 
	
	传入的参数可以是以下类型: 
	- 单条转发消息实例(将其作为列表中的第一个单条转发消息实例) 
	- 包含单条转发消息实例的数组(将按照上方规则将数组中的实例依次添加至此转发列表)


	● [color=gray]static[/color] [color=#70bafa]ForwardMessageNodeList[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Array[/color] arr [color=gray])[/color]

	通过机器人协议后端的元数据数组构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Array[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据数组，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Array[/color] arr [color=gray])[/color]

	使用指定数组覆盖实例中的元数据数组，仅当你知道自己在做什么时才使用


	● [color=#70bafa]ForwardMessageNode[/color] ￿get_from_index￿ [color=gray]([/color] [color=#70bafa]int[/color] index [color=gray])[/color]

	根据指定的序号来从此实例中获取对应的ForwardMessageNode实例 
	
	若序号不存在则返回null


	● [color=#70bafa]int[/color] ￿get_size￿ [color=gray]([/color] [color=gray])[/color]

	获取转发消息列表中单条转发消息的总数


	● [color=#70bafa]ForwardMessageNodeList[/color] ￿append￿ [color=gray]([/color] [color=#70bafa]Variant[/color] msg_node [color=gray])[/color]

	将参数中的内容添加到此消息链实例中，并返回此消息链实例自身，以便于进行连续操作 
	
	传入的参数可以是以下类型: 
	- 单条转发消息实例(将其作为列表中的第一个单条转发消息实例) 
	- 包含单条转发消息实例的数组(将按照上方规则将数组中的实例依次添加至此转发列表)


	● [color=#70bafa]ForwardMessageNode[/color] ￿get_from_message_id￿ [color=gray]([/color] [color=#70bafa]int[/color] message_id [color=gray])[/color]

	基于指定的消息ID来查找并返回第一个找到的单条转发消息实例


	● [color=#70bafa]ForwardMessageNode[/color] ￿get_from_sender_id￿ [color=gray]([/color] [color=#70bafa]int[/color] sender_id [color=gray])[/color]

	基于指定的发送者ID来查找并返回第一个找到的单条转发消息实例


