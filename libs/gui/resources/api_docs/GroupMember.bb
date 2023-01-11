[font_size=25][b][color=#70bafa]类:[/color] GroupMember[/b][/font_size]
[color=#70bafa]继承:[/color] GroupAPI


[b]RainyBot的群成员类，通常代表一个对应实例，实现了用于与群组成员进行交互的各类功能[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的群成员类，通常代表一个对应实例，实现了用于与群组成员进行交互的各类功能 [br]绝大部分与群组中某位成员相关的操作都可以通过此类来进行


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿Permission￿

	这是代表了群成员权限的枚举，在进行权限相关操作时可在转为整数后用于对比 
	
	如"get_permission() == GroupMember.Permission.ADMINISTRATOR"可判断群成员是否为管理员

		● MEMBER [color=gray]= 0[/color]
		[color=gray]代表权限为群聊中的普通成员[/color]

		● ADMINISTRATOR [color=gray]= 1[/color]
		[color=gray]代表权限为群聊中的管理员[/color]

		● OWNER [color=gray]= 2[/color]
		[color=gray]代表权限为群聊中的群主[/color]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]GroupMember[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]int[/color] group_id, [color=#70bafa]int[/color] member_id [color=gray])[/color]

	手动构造一个GroupMember类的实例，用于主动进行与群成员的交互时使用 
	
	需要传入的参数分别为群成员所属群聊的ID(群号)，群成员自身的ID


	● [color=gray]static[/color] [color=#70bafa]GroupMember[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个GroupMember类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Dictionary[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_id￿ [color=gray]([/color] [color=gray])[/color]

	获取群成员实例的ID


	● [color=#70bafa]String[/color] ￿get_name￿ [color=gray]([/color] [color=gray])[/color]

	获取群成员实例在群聊中的名称(群昵称)，若为手动构造的实例，将始终返回空字符串


	● [color=#70bafa]String[/color] ￿get_special_title￿ [color=gray]([/color] [color=gray])[/color]

	获取群成员实例在群聊中的特别称号(群荣誉)，若为手动构造的实例，将始终返回空字符串


	● [color=#70bafa]int[/color] ￿get_permission￿ [color=gray]([/color] [color=gray])[/color]

	获取群成员实例在群聊中的权限，将返回一个对应Permission枚举的整数值 
	
	若为手动构造的实例，将始终返回0


	● [color=#70bafa]String[/color] ￿get_avatar_url￿ [color=gray]([/color] [color=gray])[/color]

	获取群成员实例对应账号的头像的图像链接，通常为jpg格式


	● [color=#70bafa]bool[/color] ￿is_permission￿ [color=gray]([/color] [color=#70bafa]int[/color] perm [color=gray])[/color]

	判断群成员实例的类型是否为指定的类型


	● [color=#70bafa]int[/color] ￿get_join_timestamp￿ [color=gray]([/color] [color=gray])[/color]

	获取群成员实例加入其所在群聊的时间戳，若为手动构造的实例，将始终返回0


	● [color=#70bafa]int[/color] ￿get_last_speak_timestamp￿ [color=gray]([/color] [color=gray])[/color]

	获取群成员实例在对应群聊中上次发言的时间戳，若为手动构造的实例，将始终返回0


	● [color=#70bafa]int[/color] ￿get_mute_time_remaining￿ [color=gray]([/color] [color=gray])[/color]

	获取群成员实例在对应群聊中剩余的禁言时间(秒)，若为手动构造的实例，将始终返回0


	● [color=#70bafa]Group[/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取群成员实例所在群聊的Group实例， 
	
	若为群成员为手动构造的实例，则返回的Group实例也等同于使用Group.init()手动构造的实例


	● [color=#70bafa]MemberProfile[/color] ￿get_profile￿ [color=gray]([/color] [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	获取记录了群成员实例相关资料的MemberProfile实例，需要配合await关键字使用 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿change_name￿ [color=gray]([/color] [color=#70bafa]String[/color] new_name, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	更改群成员实例在其对应群聊中的名称(群昵称) 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿change_special_title￿ [color=gray]([/color] [color=#70bafa]String[/color] new_title, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	更改群成员实例在其对应群聊中的特别称号(群荣誉) 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿toggle_admin￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	开关群成员实例在其对应群聊中的管理员权限，机器人需要为群主才可执行 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿kick￿ [color=gray]([/color] [color=#70bafa]String[/color] message[color=gray] = ""[/color], [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	将群成员实例移出其所在的对应群聊，机器人需要为管理员或群主才可执行 
	
	可传入一个消息参数作为移出群聊的理由，但可能不会被显示 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿mute￿ [color=gray]([/color] [color=#70bafa]int[/color] time[color=gray] = 1800[/color], [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	将群成员实例在其所在的群聊中禁言指定的秒数，机器人需要为管理员或群主才可执行 
	
	若不传入秒数则默认为禁言1800秒 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿unmute￿ [color=gray]([/color] [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	将群成员实例在其所在的群聊中解除禁言，机器人需要为管理员或群主才可执行 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿send_message￿ [color=gray]([/color] [color=#70bafa]Variant[/color] msg, [color=#70bafa]int[/color] quote_msgid[color=gray] = -1[/color], [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	通过群临时会话，向群成员实例私聊发送消息，同时可指定一个需要引用回复的消息ID 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	传入的第一个参数可以是以下类型: 
	- 字符串(将自动构造为文本消息实例，解析其中的BotCode，并将其作为消息链中的唯一消息实例发送) 
	- 单个消息实例(将其作为消息链中的唯一消息实例发送) 
	- 消息链实例(将其内容复制并发送) 
	- 包含以上三种类型实例的数组(将按照上方规则将数组中的实例依次合并添加至一个消息链并发送) 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿send_nudge￿ [color=gray]([/color] [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	通过群临时会话，向群成员实例私聊发送一个戳一戳消息 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]BotRequestResult[/color] ￿recall_message￿ [color=gray]([/color] [color=#70bafa]int[/color] msg_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在群成员实例中将指定ID的消息撤回，仅可撤回机器人发送的消息 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa]CacheMessage[/color] ￿get_cache_message￿ [color=gray]([/color] [color=#70bafa]int[/color] msg_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	用于在群成员实例中获取指定ID的本地缓存消息，将返回一个[CacheMessage]类的实例 
	
	此函数必须配合await关键字进行使用，否则将会发生错误，且无法获取相关的信息 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


