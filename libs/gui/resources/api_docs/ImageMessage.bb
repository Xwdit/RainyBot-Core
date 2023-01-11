[font_size=25][b][color=#70bafa]类:[/color] ImageMessage[/b][/font_size]
[color=#70bafa]继承:[/color] Message


[b]RainyBot的图像消息类，其实例记录了与一个图像消息相关的各类数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]ImageMessage[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]Image[/color] image [color=gray])[/color]

	基于图像实例缓存并手动构造一个ImageMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]ImageMessage[/color] ￿init_gif￿ [color=gray]([/color] [color=#70bafa]GifImage[/color] gif_image [color=gray])[/color]

	基于Gif动图实例缓存并手动构造一个ImageMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]ImageMessage[/color] ￿init_id￿ [color=gray]([/color] [color=#70bafa]String[/color] image_id [color=gray])[/color]

	基于指定的图像ID来手动构造一个ImageMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]ImageMessage[/color] ￿init_url￿ [color=gray]([/color] [color=#70bafa]String[/color] image_url [color=gray])[/color]

	基于指定的URL地址来手动构造一个ImageMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]ImageMessage[/color] ￿init_path￿ [color=gray]([/color] [color=#70bafa]String[/color] image_path [color=gray])[/color]

	基于指定的本地文件路径来手动构造一个ImageMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]ImageMessage[/color] ￿init_base64￿ [color=gray]([/color] [color=#70bafa]String[/color] image_base64 [color=gray])[/color]

	基于指定的BASE64编码来手动构造一个ImageMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]ImageMessage[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]String[/color] ￿get_image_id￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的ID


	● [color=gray]void[/color] ￿set_image_id￿ [color=gray]([/color] [color=#70bafa]String[/color] image_id [color=gray])[/color]

	设置此实例对应的图像的ID


	● [color=#70bafa]String[/color] ￿get_image_url￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的URL链接


	● [color=gray]void[/color] ￿set_image_url￿ [color=gray]([/color] [color=#70bafa]String[/color] image_url [color=gray])[/color]

	设置此实例对应的图像的URL链接


	● [color=#70bafa]String[/color] ￿get_image_path￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的本地路径


	● [color=gray]void[/color] ￿set_image_path￿ [color=gray]([/color] [color=#70bafa]String[/color] image_path [color=gray])[/color]

	设置此实例对应的图像的本地路径


	● [color=#70bafa]String[/color] ￿get_image_base64￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的Base64编码


	● [color=gray]void[/color] ￿set_image_base64￿ [color=gray]([/color] [color=#70bafa]String[/color] image_base64 [color=gray])[/color]

	设置此实例对应的图像的Base64编码


	● [color=#70bafa]int[/color] ￿get_image_height￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的高度


	● [color=#70bafa]int[/color] ￿get_image_width￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的宽度


	● [color=#70bafa]float[/color] ￿get_image_size￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的文件大小


	● [color=#70bafa]String[/color] ￿get_image_type￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的类型文本


	● [color=#70bafa]bool[/color] ￿is_emoji￿ [color=gray]([/color] [color=gray])[/color]

	判断此实例对应的图像是否为表情


	● [color=#70bafa]String[/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式


