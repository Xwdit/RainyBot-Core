[font_size=25][b][color=#70bafa]类:[/color] Group[/b][/font_size]
[color=#70bafa]继承:[/color] GroupAPI


[b]RainyBot的群组类，通常代表一个对应实例，实现了用于与群组进行交互的各类功能[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的群组类，通常代表一个对应实例，实现了用于与群组进行交互的各类功能 [br]绝大部分与群聊直接相关的操作都可以通过此类来进行


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]Group[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]int[/color] group_id [color=gray])[/color]

	手动构造一个Group类的实例，用于主动进行与群组的交互时使用 
	
	需要传入群聊的ID(群号)作为参数，以便进行各类操作


	● [color=gray]static[/color] [color=#70bafa]Group[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个Group类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Dictionary[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa]String[/color] ￿get_name￿ [color=gray]([/color] [color=gray])[/color]

	获取群聊实例的名称(群名称)，若为手动构造的实例，将始终返回空字符串


	● [color=#70bafa]int[/color] ￿get_id￿ [color=gray]([/color] [color=gray])[/color]

	获取群聊实例的ID(群号)


	● [color=#70bafa]int[/color] ￿get_bot_permission￿ [color=gray]([/color] [color=gray])[/color]

	获取机器人在群聊实例中的权限，若为手动构造的实例，将始终返回0 
	
	权限列表请参见GroupMember类中的Permission枚举


	● [color=#70bafa]String[/color] ￿get_avatar_url￿ [color=gray]([/color] [color=gray])[/color]

	获取群聊实例对应的群头像的图像链接，通常为jpg格式


	● [color=#70bafa]GroupMember[/color] ￿get_member￿ [color=gray]([/color] [color=#70bafa]int[/color] member_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	获取群聊实例中指定成员ID的GroupMember实例，需要配合await关键字使用 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]GroupMemberList[/color] ￿get_member_list￿ [color=gray]([/color] [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	获取群聊实例中所有成员列表的GroupMemberList实例，需要配合await关键字使用 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]MemberProfile[/color] ￿get_member_profile￿ [color=gray]([/color] [color=#70bafa]int[/color] member_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	获取群聊实例中指定成员ID相关资料的MemberProfile实例，需要配合await关键字使用 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿toggle_mute_all￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于切换群聊实例的全员禁言状态，所需的参数为是否启用全员禁言 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]GroupConfig[/color] ￿get_group_config￿ [color=gray]([/color] [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于获取与群聊实例的各类配置相关的GroupConfig实例，需要配合await关键字使用 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿set_group_config￿ [color=gray]([/color] [color=#70bafa]GroupConfig[/color] config, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于将群聊实例的各类配置替换为指定的GroupConfig实例中的配置 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿send_message￿ [color=gray]([/color] [color=#70bafa]Variant[/color] msg, [color=#70bafa]int[/color] quote_msgid[color=gray] = -1[/color], [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于向群聊实例发送消息，同时可指定一个需要引用回复的消息ID 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	传入的第一个参数可以是以下类型: 
	- 字符串(将自动构造为文本消息实例，解析其中的BotCode，并将其作为消息链中的唯一消息实例发送) 
	- 单个消息实例(将其作为消息链中的唯一消息实例发送) 
	- 消息链实例(将其内容复制并发送) 
	- 包含以上三种类型实例的数组(将按照上方规则将数组中的实例依次合并添加至一个消息链并发送) 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿send_nudge￿ [color=gray]([/color] [color=#70bafa]int[/color] member_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在群聊实例中向指定的成员ID发送一个戳一戳消息 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]GroupAnnounceInfoList[/color] ￿publish_announce￿ [color=gray]([/color] [color=#70bafa]GroupAnnounce[/color] announce, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在群聊实例中发布一个指定的群公告实例，群公告实例的相关用法请参见[GroupAnnounce]类文档 
	
	配合await关键字可返回一个包含了已发布的群公告的[GroupAnnounceInfoList]类实例，以便于进行后续操作 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿delete_announce￿ [color=gray]([/color] [color=#70bafa]int[/color] announce_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在群聊实例中删除一个指定ID的群公告 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]GroupAnnounceInfoList[/color] ￿get_announce_list￿ [color=gray]([/color] [color=#70bafa]int[/color] page_num[color=gray] = 0[/color], [color=#70bafa]int[/color] per_page_size[color=gray] = 10[/color], [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于获取在群聊实例中的群公告的列表，可指定页码，以及每页将包含的群公告的数量，将返回一个[GroupAnnounceInfoList]类的实例 
	
	此函数必须配合await关键字进行使用，否则将会发生错误，且无法获取相关的信息 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿quit￿ [color=gray]([/color] [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于让机器人主动退出群聊实例所对应的群聊 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿set_essence_message￿ [color=gray]([/color] [color=#70bafa]int[/color] msg_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在群聊实例中将指定ID的消息设置为精华消息 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿recall_message￿ [color=gray]([/color] [color=#70bafa]int[/color] msg_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在群聊实例中将指定ID的消息撤回，机器人需要为管理员或群主才可撤回他人消息 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]CacheMessage[/color] ￿get_cache_message￿ [color=gray]([/color] [color=#70bafa]int[/color] msg_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在群聊实例中获取指定ID的本地缓存消息，将返回一个[CacheMessage]类的实例 
	
	此函数必须配合await关键字进行使用，否则将会发生错误，且无法获取相关的信息 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间



