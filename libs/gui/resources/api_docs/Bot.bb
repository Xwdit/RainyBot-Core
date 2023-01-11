[font_size=25][b][color=#70bafa]类:[/color] Bot[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:BotAPI]BotAPI[/url]


[b]RainyBot的Bot类，负责处理与当前使用的机器人后端账号相关的各类功能[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:int]int[/url][/color] ￿get_id￿ [color=gray]([/color] [color=gray])[/color]

	获取当前正在使用的机器人后端账号


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:bool]bool[/url][/color] ￿is_bot_connected￿ [color=gray]([/color] [color=gray])[/color]

	判断与机器人后端是否已建立连接


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:int]int[/url][/color] ￿get_sent_message_count￿ [color=gray]([/color] [color=gray])[/color]

	获取已通过机器人后端发送的消息的数量


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:int]int[/url][/color] ￿get_group_message_count￿ [color=gray]([/color] [color=gray])[/color]

	获取已通过机器人后端接收到的群聊消息的数量


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:int]int[/url][/color] ￿get_private_message_count￿ [color=gray]([/color] [color=gray])[/color]

	获取已通过机器人后端接收到的私聊消息的数量


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:String]String[/url][/color] ￿get_avatar_url￿ [color=gray]([/color] [color=gray])[/color]

	获取机器人后端账号的头像的图像链接，通常为jpg格式


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:MemberList]MemberList[/url][/color] ￿get_friend_list￿ [color=gray]([/color] [color=#70bafa][url=godot:float]float[/url][/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	获取当前机器人账号的好友列表，需要与await关键词配合使用 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:GroupList]GroupList[/url][/color] ￿get_group_list￿ [color=gray]([/color] [color=#70bafa][url=godot:float]float[/url][/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	获取当前机器人账号的群组列表，需要与await关键词配合使用 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:MemberProfile]MemberProfile[/url][/color] ￿get_profile￿ [color=gray]([/color] [color=#70bafa][url=godot:float]float[/url][/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	获取当前机器人账号的资料卡，需要与await关键词配合使用 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


