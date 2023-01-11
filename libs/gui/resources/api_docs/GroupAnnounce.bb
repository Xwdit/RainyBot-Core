[font_size=25][b][color=#70bafa]类:[/color] GroupAnnounce[/b][/font_size]
[color=#70bafa]继承:[/color] GroupAPI


[b]RainyBot的群公告类，其实例记录了一个将被用于发送的群公告的相关信息[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的群公告类，其实例记录了一个将被用于发送的群公告的相关信息 [br]此类实例通常需要被手动构造，以用于向某个特定群组中发送一条群公告


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]GroupAnnounce[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]String[/color] content [color=gray])[/color]

	基于指定的内容文本构造一个群公告实例，您可以稍后通过实例中的其它函数来设置此公告的更多属性


	● [color=gray]static[/color] [color=#70bafa]GroupAnnounce[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]Dictionary[/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray]void[/color] ￿set_content￿ [color=gray]([/color] [color=#70bafa]String[/color] text [color=gray])[/color]

	设置公告实例中的公告内容文本，此项为此实例可被正常发送的必要条件，因此不可为空


	● [color=#70bafa]String[/color] ￿get_content￿ [color=gray]([/color] [color=gray])[/color]

	获取公告实例中的公告内容文本


	● [color=gray]void[/color] ￿set_send_to_new_member￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled [color=gray])[/color]

	设置此公告实例是否向新成员展示


	● [color=#70bafa]bool[/color] ￿is_send_to_new_member￿ [color=gray]([/color] [color=gray])[/color]

	获取此公告实例是否向新成员展示


	● [color=gray]void[/color] ￿set_pinned￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled [color=gray])[/color]

	设置此公告实例是否在公告列表中置顶


	● [color=#70bafa]bool[/color] ￿is_pinned￿ [color=gray]([/color] [color=gray])[/color]

	获取此公告实例是否在公告列表中置顶


	● [color=gray]void[/color] ￿set_show_edit_card￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled [color=gray])[/color]

	设置此公告实例是否显示引导群员修改名片的选项


	● [color=#70bafa]bool[/color] ￿is_show_edit_card￿ [color=gray]([/color] [color=gray])[/color]

	获取此公告实例是否显示引导群员修改名片的选项


	● [color=gray]void[/color] ￿set_show_popup￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled [color=gray])[/color]

	设置此公告实例是否使用弹窗来展示


	● [color=#70bafa]bool[/color] ￿is_show_popup￿ [color=gray]([/color] [color=gray])[/color]

	获取此公告实例是否使用弹窗来展示


	● [color=gray]void[/color] ￿set_require_confirm￿ [color=gray]([/color] [color=#70bafa]bool[/color] enabled [color=gray])[/color]

	设置此公告实例是否需要群成员进行确认


	● [color=#70bafa]bool[/color] ￿is_require_confirm￿ [color=gray]([/color] [color=gray])[/color]

	获取此公告实例是否需要群成员进行确认


	● [color=gray]void[/color] ￿set_image_url￿ [color=gray]([/color] [color=#70bafa]String[/color] img_url [color=gray])[/color]

	设置此公告实例将包含的图像的url链接


	● [color=#70bafa]String[/color] ￿get_image_url￿ [color=gray]([/color] [color=gray])[/color]

	获取此公告实例将包含的图像的url链接


	● [color=gray]void[/color] ￿set_image_path￿ [color=gray]([/color] [color=#70bafa]String[/color] img_path [color=gray])[/color]

	设置此公告实例将包含的图像的本地绝对路径


	● [color=#70bafa]String[/color] ￿get_image_path￿ [color=gray]([/color] [color=gray])[/color]

	获取此公告实例将包含的图像的本地绝对路径


	● [color=gray]void[/color] ￿set_image_base64￿ [color=gray]([/color] [color=#70bafa]String[/color] img_base64 [color=gray])[/color]

	设置此公告实例将包含的图像的Base64编码


	● [color=#70bafa]String[/color] ￿get_image_base64￿ [color=gray]([/color] [color=gray])[/color]

	获取此公告实例将包含的图像的Base64编码



