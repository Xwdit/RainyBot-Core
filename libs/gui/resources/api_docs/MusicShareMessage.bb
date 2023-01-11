[font_size=25][b][color=#70bafa]类:[/color] MusicShareMessage[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:Message]Message[/url]


[b]RainyBot的音乐分享消息类，其实例记录了与一个音乐分享消息相关的各类数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:MusicShareMessage]MusicShareMessage[/url][/color] ￿init￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] kind, [color=#70bafa][url=godot:String]String[/url][/color] title, [color=#70bafa][url=godot:String]String[/url][/color] summary, [color=#70bafa][url=godot:String]String[/url][/color] jump_url, [color=#70bafa][url=godot:String]String[/url][/color] picture_url, [color=#70bafa][url=godot:String]String[/url][/color] music_url, [color=#70bafa][url=godot:String]String[/url][/color] brief [color=gray])[/color]

	基于指定的参数来手动构造一个MusicShareMessage类的实例 
	
	需要的参数从左到右分别为: 类型，标题，概括，跳转链接，封面图像链接，音乐文件链接，简介


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:MusicShareMessage]MusicShareMessage[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_share_kind￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的分享类型


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_share_kind￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	设置此实例对应的分享类型


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_share_title￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的分享标题


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_share_title￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	设置此实例对应的分享标题


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_share_summary￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的分享概括


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_share_summary￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	设置此实例对应的分享概括


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_share_jump_url￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的分享跳转链接


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_share_jump_url￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	设置此实例对应的分享跳转链接


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_share_picture_url￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的分享封面图像链接


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_share_picture_url￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	设置此实例对应的分享封面图像链接


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_share_music_url￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的分享音乐文件链接


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_share_music_url￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	设置此实例对应的分享音乐文件链接


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_share_brief￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的分享简介


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_share_brief￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] text [color=gray])[/color]

	设置此实例对应的分享简介


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式


