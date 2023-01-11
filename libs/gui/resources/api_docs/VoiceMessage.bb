[font_size=25][b][color=#70bafa]类:[/color] VoiceMessage[/b][/font_size]
[color=#70bafa]继承:[/color] Message


[b]RainyBot的语音消息类，其实例记录了与一个语音消息相关的各类数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]VoiceMessage[/color] ￿init_id￿ [color=gray]([/color] [color=#70bafa]String[/color] voice_id [color=gray])[/color]

	基于指定的语音ID来手动构造一个VoiceMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]VoiceMessage[/color] ￿init_url￿ [color=gray]([/color] [color=#70bafa]String[/color] voice_url [color=gray])[/color]

	基于指定的音频URL链接来手动构造一个VoiceMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]VoiceMessage[/color] ￿init_path￿ [color=gray]([/color] [color=#70bafa]String[/color] voice_path [color=gray])[/color]

	基于指定的本地音频路径来手动构造一个VoiceMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]VoiceMessage[/color] ￿init_base64￿ [color=gray]([/color] [color=#70bafa]String[/color] voice_base64 [color=gray])[/color]

	基于指定的音频Base64编码来手动构造一个VoiceMessage类的实例


	● [color=gray]static[/color] [color=#70bafa]VoiceMessage[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]String[/color] ￿get_voice_id￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的语音的ID


	● [color=gray]void[/color] ￿set_voice_id￿ [color=gray]([/color] [color=#70bafa]String[/color] voice_id [color=gray])[/color]

	设置此实例对应的语音的ID


	● [color=#70bafa]String[/color] ￿get_voice_url￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的音频的URL链接


	● [color=gray]void[/color] ￿set_voice_url￿ [color=gray]([/color] [color=#70bafa]String[/color] voice_url [color=gray])[/color]

	设置此实例对应的音频的URL链接


	● [color=#70bafa]String[/color] ￿get_voice_path￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的音频的本地路径


	● [color=gray]void[/color] ￿set_voice_path￿ [color=gray]([/color] [color=#70bafa]String[/color] voice_path [color=gray])[/color]

	设置此实例对应的音频的本地路径


	● [color=#70bafa]String[/color] ￿get_voice_base64￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的音频的Base64编码


	● [color=gray]void[/color] ￿set_voice_base64￿ [color=gray]([/color] [color=#70bafa]String[/color] voice_base64 [color=gray])[/color]

	设置此实例对应的音频的Base64编码


	● [color=#70bafa]int[/color] ￿get_voice_length￿ [color=gray]([/color] [color=gray])[/color]

	获取此示例对应的语音的长度(以秒为单位)


	● [color=#70bafa]String[/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式


