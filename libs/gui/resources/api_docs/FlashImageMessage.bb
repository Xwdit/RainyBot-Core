[font_size=25][b][color=#70bafa]类:[/color] FlashImageMessage[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:Message]Message[/url]


[b]RainyBot的闪图消息类，其实例记录了与一个闪图消息相关的各类数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:FlashImageMessage]FlashImageMessage[/url][/color] ￿init￿ [color=gray]([/color] [color=#70bafa][url=godot:Image]Image[/url][/color] image [color=gray])[/color]

	基于图像实例缓存并手动构造一个FlashImageMessage类的实例


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:FlashImageMessage]FlashImageMessage[/url][/color] ￿init_gif￿ [color=gray]([/color] [color=#70bafa][url=api:GifImage]GifImage[/url][/color] gif_image [color=gray])[/color]

	基于Gif动图实例缓存并手动构造一个FlashImageMessage类的实例


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:FlashImageMessage]FlashImageMessage[/url][/color] ￿init_id￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] image_id [color=gray])[/color]

	基于指定的图像ID来手动构造一个FlashImageMessage类的实例


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:FlashImageMessage]FlashImageMessage[/url][/color] ￿init_url￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] image_url [color=gray])[/color]

	基于指定的URL地址来手动构造一个FlashImageMessage类的实例


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:FlashImageMessage]FlashImageMessage[/url][/color] ￿init_path￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] image_path [color=gray])[/color]

	基于指定的本地文件路径来手动构造一个FlashImageMessage类的实例


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:FlashImageMessage]FlashImageMessage[/url][/color] ￿init_base64￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] image_base64 [color=gray])[/color]

	基于指定的BASE64编码来手动构造一个FlashImageMessage类的实例


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:FlashImageMessage]FlashImageMessage[/url][/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_image_id￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的ID


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_image_id￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] image_id [color=gray])[/color]

	设置此实例对应的图像的ID


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_image_url￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的URL链接


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_image_url￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] image_url [color=gray])[/color]

	设置此实例对应的图像的URL链接


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_image_path￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的本地路径


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_image_path￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] image_path [color=gray])[/color]

	设置此实例对应的图像的本地路径


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_image_base64￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的Base64编码


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_image_base64￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] image_base64 [color=gray])[/color]

	设置此实例对应的图像的Base64编码


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_image_height￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的高度


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_image_width￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的宽度


	● [color=#70bafa][url=godot:float]float[/url][/color] ￿get_image_size￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的文件大小


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_image_type￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的图像的类型文本


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿is_emoji￿ [color=gray]([/color] [color=gray])[/color]

	判断此实例对应的图像是否为表情


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式


