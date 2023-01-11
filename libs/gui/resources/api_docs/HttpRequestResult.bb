[font_size=25][b][color=#70bafa]类:[/color] HttpRequestResult[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:CoreAPI]CoreAPI[/url]


[b]RainyBot的Http请求结果类，可从其中快速获取某次Http请求的结果数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_request_url￿ [color=gray]([/color] [color=gray])[/color]

	获取此请求的URL字符串


	● [color=#70bafa][url=godot:Variant]Variant[/url][/color] ￿get_request_data￿ [color=gray]([/color] [color=gray])[/color]

	获取此请求的请求数据(字符串/字节数组)


	● [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] ￿get_request_data_dic￿ [color=gray]([/color] [color=gray])[/color]

	将此请求的请求数据解析为字典并返回


	● [color=#70bafa][url=godot:PackedStringArray]PackedStringArray[/url][/color] ￿get_request_headers￿ [color=gray]([/color] [color=gray])[/color]

	获取此请求的headers数组


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_result_status￿ [color=gray]([/color] [color=gray])[/color]

	获取此请求的结果状态


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_response_code￿ [color=gray]([/color] [color=gray])[/color]

	获取此请求的结果响应码


	● [color=#70bafa][url=godot:PackedStringArray]PackedStringArray[/url][/color] ￿get_headers￿ [color=gray]([/color] [color=gray])[/color]

	获取此请求的结果的headers


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	尝试将此请求的结果解析为字符串并返回


	● [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] ￿get_as_dic￿ [color=gray]([/color] [color=gray])[/color]

	尝试将此请求的结果解析为字典并返回


	● [color=#70bafa][url=godot:PackedByteArray]PackedByteArray[/url][/color] ￿get_as_byte￿ [color=gray]([/color] [color=gray])[/color]

	直接返回此请求的结果的二进制数据数组


	● [color=#70bafa][url=godot:Image]Image[/url][/color] ￿get_as_image￿ [color=gray]([/color] [color=gray])[/color]

	尝试自动判断此请求的结果的图像格式，解析并返回其图像实例，支持的图像格式为: [code]png,jpg,bmp,tga,webp[/code] 
	
	若图像的格式已知，建议使用[code]get_as_[格式]_image()[/code]系列函数以获得更好的性能 (如[get_as_png_image]函数)


	● [color=#70bafa][url=godot:Image]Image[/url][/color] ￿get_as_png_image￿ [color=gray]([/color] [color=gray])[/color]

	尝试将此请求的结果作为png格式解析并返回其图像实例


	● [color=#70bafa][url=godot:Image]Image[/url][/color] ￿get_as_jpg_image￿ [color=gray]([/color] [color=gray])[/color]

	尝试将此请求的结果作为jpg格式解析并返回其图像实例


	● [color=#70bafa][url=godot:Image]Image[/url][/color] ￿get_as_bmp_image￿ [color=gray]([/color] [color=gray])[/color]

	尝试将此请求的结果作为bmp格式解析并返回其图像实例


	● [color=#70bafa][url=godot:Image]Image[/url][/color] ￿get_as_tga_image￿ [color=gray]([/color] [color=gray])[/color]

	尝试将此请求的结果作为tga格式解析并返回其图像实例


	● [color=#70bafa][url=godot:Image]Image[/url][/color] ￿get_as_webp_image￿ [color=gray]([/color] [color=gray])[/color]

	尝试将此请求的结果作为webp格式解析并返回其图像实例


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿save_to_file￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] path [color=gray])[/color]

	尝试将此请求的结果的二进制数据保存到指定路径的文件


