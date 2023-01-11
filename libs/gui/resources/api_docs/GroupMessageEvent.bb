[font_size=25][b][color=#70bafa]类:[/color] GroupMessageEvent[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:MessageEvent]MessageEvent[/url]


[b]RainyBot的群组消息事件类，其实例记录了与一次群组消息事件相关的数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa][url=api:GroupMessageEvent]GroupMessageEvent[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=api:GroupMember]GroupMember[/url][/color] ￿get_sender￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件对应的发送者的群组成员实例


	● [color=#70bafa][url=api:Group]Group[/url][/color] ￿get_group￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件所对应的群组的实例


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_group_id￿ [color=gray]([/color] [color=gray])[/color]

	获取消息事件所对应的群组的ID


	● [color=#70bafa][url=api:BotRequestResult]BotRequestResult[/url][/color] ￿recall￿ [color=gray]([/color] [color=#70bafa][url=godot:float]float[/url][/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	撤回事件所对应的群消息，机器人需要在对应群组中为管理员或群组权限才能执行成功 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa][url=api:BotRequestResult]BotRequestResult[/url][/color] ￿set_essence￿ [color=gray]([/color] [color=#70bafa][url=godot:float]float[/url][/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	将事件所对应的群消息设置为精华消息，机器人需要在对应群组中为管理员或群组权限才能执行成功 
	
	配合await关键字可返回一个BotRequestResult类的实例，便于判断执行状态 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿is_at_bot￿ [color=gray]([/color] [color=gray])[/color]

	判断事件所对应的群消息中是否AT了机器人


