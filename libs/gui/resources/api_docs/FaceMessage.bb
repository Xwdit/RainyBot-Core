[font_size=25][b][color=#70bafa]类:[/color] FaceMessage[/b][/font_size]
[color=#70bafa]继承:[/color] Message


[b]RainyBot的表情消息类，其实例记录了与一个表情消息相关的各类数据[/b]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray]static[/color] [color=#70bafa]FaceMessage[/color] ￿init￿ [color=gray]([/color] [color=#70bafa]Variant[/color] face [color=gray])[/color]

	用于手动构造一个表情消息实例；若传入的参数为整数，则基于表情ID进行构造；若为字符串，则基于表情名称进行构造


	● [color=gray]static[/color] [color=#70bafa]FaceMessage[/color] ￿init_meta￿ [color=gray]([/color] [color=#70bafa]Dictionary[/color] dic [color=gray])[/color]

	通过机器人协议后端的元数据字典构造一个此类的实例，仅当你知道自己在做什么时才使用


	● [color=#70bafa]int[/color] ￿get_face_id￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的表情的ID


	● [color=gray]void[/color] ￿set_face_id￿ [color=gray]([/color] [color=#70bafa]int[/color] face_id [color=gray])[/color]

	设置此实例对应的表情的ID


	● [color=#70bafa]String[/color] ￿get_face_name￿ [color=gray]([/color] [color=gray])[/color]

	获取此实例对应的表情的名称


	● [color=gray]void[/color] ￿set_face_name￿ [color=gray]([/color] [color=#70bafa]String[/color] face_name [color=gray])[/color]

	设置此实例对应的表情的名称


	● [color=#70bafa]String[/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此实例获取为字符串的形式



