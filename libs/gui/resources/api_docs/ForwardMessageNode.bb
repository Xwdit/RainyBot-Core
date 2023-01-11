[font_size=25][b][color=#70bafa]类:[/color] ForwardMessageNode[/b][/font_size]
[color=#70bafa]继承:[/color] MessageAPI


[b]这是RainyBot的单条转发消息类，其实例储存了一系列合并转发消息中的单条消息的相关数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]ForwardMessageNode[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]int[/color] sender_id[color=gray] = -1[/color], [color=#70bafa]int[/color] time[color=gray] = 0[/color], [color=#70bafa]String[/color] sender_name[color=gray] = ""[/color], [color=#70bafa]MessageChain[/color] message_chain[color=gray] = null[/color] [color=gray])[/color]

	基于指定的参数来手动构造一个自定义的ForwardMessageNode类的实例 
	
	需要的参数从左到右分别为: 被转发的消息的发送者ID,被转发的消息的发送时间戳，被转发的消息的发送者名称，被转发的消息的内容消息链


	● [color=gray]static[/color] [color=#70bafa]ForwardMessageNode[/color] ￿init_id￿ [color=gray]([/color] [color=#70bafa]int[/color] message_id [color=gray])[/color]

	基于指定的已存在的消息ID来手动构造一个ForwardMessageNode类的实例


	● [color=gray]static[/color] [color=#70bafa]ForwardMessageNode[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Dictionary[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_sender_id￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的消息的发送者的ID


	● [color=gray]void[/color] ￿set_sender_id￿ [color=gray]([/color] [color=#70bafa]int[/color] id [color=gray])[/color]

	设置此实例对应的消息的发送者的ID


	● [color=#70bafa]int[/color] ￿get_timestamp￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的消息的发送时间戳


	● [color=gray]void[/color] ￿set_timestamp￿ [color=gray]([/color] [color=#70bafa]int[/color] time [color=gray])[/color]

	设置此实例对应的消息的发送时间戳


	● [color=#70bafa]String[/color] ￿get_sender_name￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的消息的发送者的名称


	● [color=gray]void[/color] ￿set_sender_name￿ [color=gray]([/color] [color=#70bafa]int[/color] name [color=gray])[/color]

	设置此实例对应的消息的发送者的名称


	● [color=#70bafa]MessageChain[/color] ￿get_message_chain￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的消息的消息链实例


	● [color=gray]void[/color] ￿set_message_chain￿ [color=gray]([/color] [color=#70bafa]MessageChain[/color] msg_chain [color=gray])[/color]

	设置此实例对应的消息的消息链实例


	● [color=#70bafa]int[/color] ￿get_message_id￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的消息的ID


	● [color=gray]void[/color] ￿set_message_id￿ [color=gray]([/color] [color=#70bafa]int[/color] id [color=gray])[/color]

	设置此实例对应的消息的ID



