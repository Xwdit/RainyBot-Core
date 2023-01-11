[font_size=25][b][color=#70bafa]类:[/color] MemberProfile[/b][/font_size]
[color=#70bafa]继承:[/color] MemberAPI


[b]RainyBot的个体成员资料类，通常代表一个对应实例，储存了某个个体成员的相关资料[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的个体成员资料类，通常代表一个对应实例，储存了某个个体成员的相关资料 [br]当查询某群聊成员的相关资料时，不论其是否为机器人的个体成员，也将通过此类实例储存并返回其资料 [br]此类实例储存的资料包括但不限于昵称，邮箱，年龄，等级，签名，性别等


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿Sex￿

	这是代表了资料中性别的枚举，在进行性别判断相关操作时可在转为整数后用于对比 
	
	如"get_sex() == MemberProfile.Sex.MALE"可判断资料性别是否为男性

		● UNKNOWN [color=gray]= 0[/color]
		[color=gray]未知[/color]

		● MALE [color=gray]= 1[/color]
		[color=gray]男性[/color]

		● FEMALE [color=gray]= 2[/color]
		[color=gray]女性[/color]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]MemberProfile[/color] ￿init_user￿ [color=gray]([/color] [color=#70bafa]int[/color] user_id, [color=#70bafa]float[/color] timeout[color=gray] = inf_neg[/color] [color=gray])[/color]

	获取指定ID用户的资料数据并将其构造为一个MemberProfile类的实例，需要配合await关键字使用 
	
	可以通过指定timeout参数来自定义获取请求结果的超时时间，若不指定则默认将使用配置文件中设置的超时时间


	● [color=gray]static[/color] [color=#70bafa]MemberProfile[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个MemberProfile类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Dictionary[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa]String[/color] ￿get_nickname￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的昵称信息


	● [color=#70bafa]String[/color] ￿get_email￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的邮箱信息


	● [color=#70bafa]int[/color] ￿get_age￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的年龄信息


	● [color=#70bafa]int[/color] ￿get_level￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的等级信息


	● [color=#70bafa]String[/color] ￿get_sign￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的个性签名信息


	● [color=#70bafa]int[/color] ￿get_sex￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中储存的性别信息，将返回一个对应Sex枚举的整数值


	● [color=#70bafa]bool[/color] ￿is_sex￿ [color=gray]([/color] [color=#70bafa]int[/color] sex [color=gray])[/color]

	判断资料中的性别是不是指定类型的性别


