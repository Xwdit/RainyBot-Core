[font_size=25][b][color=#70bafa]类:[/color] Plugin[/b][/font_size]
[color=#70bafa]继承:[/color] [url=godot:Node]Node[/url]


[b]RainyBot的插件类，代表一个实例，用于在插件中实现各类相关功能[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的插件类，代表一个插件实例，用于在插件中实现各类相关功能。所有插件应当继承此类，以便在RainyBot中正确加载与运行。


[font_size=25][color=#70bafa][b]枚举[/b][/color][/font_size]

	[color=#70bafa]enum[/color] ￿MatchMode￿

	关键词的匹配模式枚举，决定了触发某关键词判定的条件

		● BEGIN [color=gray]= 0[/color]
		[color=gray]仅当关键词位于消息开头时触发判定[/color]

		● BETWEEN [color=gray]= 1[/color]
		[color=gray]仅当关键词位于消息中间时触发判定[/color]

		● END [color=gray]= 2[/color]
		[color=gray]仅当关键词位于消息末尾时触发判定[/color]

		● INCLUDE [color=gray]= 3[/color]
		[color=gray]消息中只要包含关键词就触发判定[/color]

		● EXCLUDE [color=gray]= 4[/color]
		[color=gray]消息中只要不包含关键词就触发判定[/color]

		● EQUAL [color=gray]= 5[/color]
		[color=gray]消息与关键词完全匹配时触发判定[/color]

		● REGEX [color=gray]= 6[/color]
		[color=gray]消息满足正则表达式时触发判定（此时关键词内容应为一个正则表达式）[/color]


	[color=#70bafa]enum[/color] ￿BlockMode￿

	事件在处理时被标记为停止传递后的阻断模式枚举，决定了该事件将如何被阻断传递

		● DISABLE [color=gray]= 0[/color]
		[color=gray]即使标记为停止传递也不会进行阻断[/color]

		● EVENT [color=gray]= 1[/color]
		[color=gray]在当前插件中的所有该事件函数处理完毕后，将阻断传递，即不会传递给后续插件[/color]

		● FUNCTION [color=gray]= 2[/color]
		[color=gray]当前函数处理完毕后，阻断事件在当前插件内的传递，但后续插件仍会接收到事件[/color]

		● ALL [color=gray]= 3[/color]
		[color=gray]当前函数处理完毕后，将完全阻断事件传递，事件后续函数及其他插件均不会收到事件[/color]


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿_on_init￿ [color=gray]([/color] [color=gray])[/color]

	在插件中覆盖此虚函数，以便定义将在此插件的文件每次被读取时执行的操作 
	
	必须在此处使用[set_plugin_info]函数来设置插件信息，插件才能被正常识别与读取 
	
	例如：[code]set_plugin_info("example","示例插件","author","1.0","这是插件的介绍")[/code] 
	
	可以在此处初始化和使用一些基本变量，但不建议执行其它代码，可能会导致出现未知问题


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿_on_connect￿ [color=gray]([/color] [color=gray])[/color]

	在插件中覆盖此虚函数，以便定义RainyBot在与协议后端建立连接后插件将执行的操作 
	
	可以在此处进行一些与连接状态相关的操作，例如恢复连接后发送通知等


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿_on_load￿ [color=gray]([/color] [color=gray])[/color]

	在插件中覆盖此虚函数，以便定义插件在被加载完毕后执行的操作 
	
	可以在此处进行各类事件/关键词/命令的注册，以及配置/数据文件的初始化等


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿_on_ready￿ [color=gray]([/color] [color=gray])[/color]

	在插件中覆盖此虚函数，以便定义插件在所有其他插件加载完毕后执行的操作 
	
	可以在此处进行一些与其他插件交互相关的操作，例如获取某插件的实例等 
	
	注意：如果此插件硬性依赖某插件，推荐在插件信息中注册所依赖的插件，以确保其在此插件之前被正确加载


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿_on_process￿ [color=gray]([/color] [color=gray])[/color]

	在插件中覆盖此虚函数，以便定义插件运行中的每一秒将执行的操作 
	
	可在此处进行一些计时，或时间判定相关的操作，例如整点报时等


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿_on_error￿ [color=gray]([/color] [color=gray])[/color]

	在插件中覆盖此虚函数，以便定义在RainyBot检测到运行时错误后将执行的操作 
	
	可在此处进行一些与错误处理相关的操作，例如向指定QQ发送通知等 
	
	您可以使用[get_last_errors]函数来获取错误的详细内容


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿_on_disconnect￿ [color=gray]([/color] [color=gray])[/color]

	在插件中覆盖此虚函数，以便定义RainyBot在与协议后端断开建立连接后插件将执行的操作 
	
	可以在此处进行一些与连接状态相关的操作，例如断开连接后暂停某些任务的运行等


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿_on_unload￿ [color=gray]([/color] [color=gray])[/color]

	在插件中覆盖此虚函数，以便定义插件在即将被卸载时执行的操作 
	
	可在此处执行一些自定义保存或清理相关的操作，例如储存自定义的文件或清除缓存等 
	
	无需在此处取消注册事件/关键词/命令，或者对内置的配置/数据功能进行保存，插件卸载时将会自动进行处理


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_plugin_info￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] p_id, [color=#70bafa][url=godot:String]String[/url][/color] p_name, [color=#70bafa][url=godot:String]String[/url][/color] p_author, [color=#70bafa][url=godot:String]String[/url][/color] p_version, [color=#70bafa][url=godot:String]String[/url][/color] p_description, [color=#70bafa][url=godot:Variant]Variant[/url][/color] p_dependency[color=gray] = null[/color] [color=gray])[/color]

	用于设定插件的相关信息，需要在[_on_init]虚函数中执行以便RainyBot正确加载您的插件 
	
	需要的参数从左到右分别为插件ID(将强制转为小写，不可与其它已加载插件重复),插件名,插件作者,插件版本,插件描述,插件依赖(可选) 
	
	最后一项可选参数为此插件的依赖插件列表(数组)，需要以所依赖的插件的ID作为列表中的元素，如:[code]["example","example_1"][/code] 
	
	设置了插件依赖后，可以保证所依赖的插件一定在此插件之前被加载


	● [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] ￿get_plugin_info￿ [color=gray]([/color] [color=gray])[/color]

	用于获取插件的相关信息，将返回一个包含插件信息的字典 
	
	使用[code]id, name, author, version, description, dependency[/code]作为key即可从字典中获取对应信息


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_plugin_filename￿ [color=gray]([/color] [color=gray])[/color]

	用于获取插件对应的文件名，将返回插件文件的名称 (如[code]ChatBot.gd[/code])


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_plugin_filepath￿ [color=gray]([/color] [color=gray])[/color]

	用于获取插件对应的文件路径，将返回插件文件的绝对路径 (如 [code]D://RainyBot/plugins/ChatBot.gd[/code])


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:String]String[/url][/color] ￿get_plugin_path￿ [color=gray]([/color] [color=gray])[/color]

	用于获取RainyBot的插件文件夹的路径，将返回插件文件夹的绝对路径 (如 [code]D://RainyBot/plugins/[/code])


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿get_plugin_runtime￿ [color=gray]([/color] [color=gray])[/color]

	用于获取插件的已运行时间，默认情况下为插件成功加载以来经过的秒数


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:int]int[/url][/color] ￿get_global_runtime￿ [color=gray]([/color] [color=gray])[/color]

	用于获取RainyBot全局的已运行时间，默认情况下为RainyBot成功启动以来经过的秒数


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=api:Plugin]Plugin[/url][/color] ￿get_plugin_instance￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] plugin_id [color=gray])[/color]

	用于获取其他插件的实例引用，可用于插件之间的联动与数据互通等 
	
	需要传入其他插件的ID作为参数来获取其实例，若未找到插件则返回null


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:String]String[/url][/color] ￿get_data_path￿ [color=gray]([/color] [color=gray])[/color]

	用于获取RainyBot的数据文件夹的路径，将返回数据文件夹的绝对路径 (如 [code]D://RainyBot/data/[/code])


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_data_filepath￿ [color=gray]([/color] [color=gray])[/color]

	用于获取该插件对应的数据库文件的路径，即插件对应的.rdb格式文件的绝对路径


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:String]String[/url][/color] ￿get_config_path￿ [color=gray]([/color] [color=gray])[/color]

	用于获取RainyBot的配置文件夹的路径，将返回配置文件夹的绝对路径 (如 [code]D://RainyBot/config/[/code])


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_config_filepath￿ [color=gray]([/color] [color=gray])[/color]

	用于获取该插件对应的配置文件的路径，即插件对应的.json格式文件的绝对路径


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:String]String[/url][/color] ￿get_cache_path￿ [color=gray]([/color] [color=gray])[/color]

	用于获取RainyBot的缓存文件夹的路径，将返回缓存文件夹的绝对路径 (如 D://RainyBot/cache)


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_cache_filepath￿ [color=gray]([/color] [color=gray])[/color]

	用于获取该插件对应的缓存数据库文件的路径，即插件对应的.rca格式文件的绝对路径


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿is_config_loaded￿ [color=gray]([/color] [color=gray])[/color]

	用于检查插件对应的配置文件内容是否已被加载


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿is_data_loaded￿ [color=gray]([/color] [color=gray])[/color]

	用于检查插件对应的数据库文件内容是否已被加载


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿is_cache_loaded￿ [color=gray]([/color] [color=gray])[/color]

	用于检查插件对应的缓存数据库文件内容是否已被加载


	● [color=gray][hint=此方法调用时无需构造实例，可通过类名直接调用]static[/hint][/color] [color=#70bafa][url=godot:PackedStringArray]PackedStringArray[/url][/color] ￿get_last_errors￿ [color=gray]([/color] [color=gray])[/color]

	用于获取最近一次检测到的所有RainyBot运行时错误，将返回一个包含了这些错误的字符串数组 
	
	如果自RainyBot启动至今还没有检测到任何运行时错误，将返回一个空数组 
	
	当前版本中仅支持自动检测脚本运行时错误，若要获取其他类型的错误，请通过主菜单来访问内部日志进行查看


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿register_event￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] event, [color=#70bafa][url=godot:Variant]Variant[/url][/color] function, [color=#70bafa][url=godot:int]int[/url][/color] priority[color=gray] = 0[/color], [color=#70bafa][url=godot:int]int[/url][/color] block_mode[color=gray] = 3[/color] [color=gray])[/color]

	用于注册一个或多个事件并将其绑定到一个或多个函数，事件发生时将触发绑定的函数并传入事件实例 
	
	需要的参数从左到右分别为: 
	
	事件的类型: 
	- 此处可传入单个事件类型名，或一个包含了任意数量事件类型名的数组以批量注册事件 
	- 传入的事件需要直接或间接继承[Event]类，如[GroupMessageEvent](群消息事件)  
	
	事件绑定的函数名: 
	- 此处可传入单个函数名，或一个包含了任意数量函数名的数组以批量绑定函数 
	- 当对应事件发生时将依次传递并触发绑定的函数，绑定的函数需要定义一个参数用于接收事件实例  
	
	事件的全局优先级(可选,默认为0): 
	- 在多个插件同时注册了同一事件后，事件发生时将按照优先级由高到低的顺序传递事件到对应的插件 
	- 优先级相同时，将根据注册事件的时间顺序来依次传递事件  
	
	事件的阻断模式(可选,默认为BlockMode.ALL): 
	- 事件绑定的函数若返回true，将阻断事件被传递到后续函数或插件中 (异步函数无效) 
	- 阻断的具体行为将由阻断模式决定, 每种阻断模式的具体效果请参见上方的BlockMode枚举


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿unregister_event￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] event [color=gray])[/color]

	用于取消注册一个或多个事件，取消注册后插件将不再对此事件做出响应 
	
	此处可传入单个事件类型名，或一个包含了任意数量事件类型名的数组以批量取消注册事件


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿register_console_command￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] command, [color=#70bafa][url=godot:Variant]Variant[/url][/color] function, [color=#70bafa][url=godot:bool]bool[/url][/color] need_arguments[color=gray] = false[/color], [color=#70bafa][url=godot:Array]Array[/url][/color] usages[color=gray] = [][/color], [color=#70bafa][url=godot:bool]bool[/url][/color] need_connect[color=gray] = false[/color] [color=gray])[/color]

	用于注册一个控制台命令并将其绑定到指定函数，命令被执行时将触发此函数，并传入对应的命令名与参数数组 
	
	命令被注册后将会在帮助菜单中自动显示，无法注册已经存在的命令 
	
	绑定函数接收的参数数组中包含了以空格分隔的命令参数的列表，如命令 [code]plugins load xxx.gd[/code] ，传入的数组中将包含[code]["load","xxx.gd"][/code] 
	
	注册命令需要的参数从左到右分别为: 
	
	命令的名称: 
	- 即为在控制台触发此命令需要输入的内容，请勿包含空格，不可与已存在的命令重复；此处可传入单个命令名，或一个包含了任意数量命令名的数组以批量注册某个命令及其别称  
	
	命令触发的函数名: 
	- 当命令被执行时将触发的函数，此函数需要定义两个参数，分别用于接收命令名与传入的参数数组  
	
	命令是否强制要求传入参数(可选,默认为false): 
	- 若为true则在执行命令时必须传入参数，否则判定为用法错误)  
	
	命令的用法介绍(可选,默认为空数组): 
	- 将在使用help指令或命令用法错误时显示。数组中的每项需为字符串，代表着一个子命令的用法  
	
	命令是否需要在连接到协议后端后才能使用: 
	- 若为true则在未连接协议后端时无法在控制台调用此命令


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿unregister_console_command￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] command [color=gray])[/color]

	用于取消注册一个控制台命令，命令被取消注册后将无法在控制台被执行，且不会在帮助菜单中显示 
	
	需要传入对应的命令名来将其取消注册，无法取消注册不属于此插件的命令


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿register_keyword￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] keyword, [color=#70bafa][url=godot:Variant]Variant[/url][/color] function, [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] var_dic[color=gray] = {}[/color], [color=#70bafa][url=godot:int]int[/url][/color] match_mode[color=gray] = 0[/color], [color=#70bafa][url=godot:bool]bool[/url][/color] block[color=gray] = true[/color] [color=gray])[/color]

	用于注册一个或多个关键词并将其绑定到某个函数，关键词匹配时将触发绑定的函数并传入相关数据 
	
	注册的关键词不会自动进行匹配，而是需要手动调用或者在注册事件时将需要检测关键词的消息事件手动绑定到"[trigger_keyword]"函数即可 
	
	注册需要的参数从左到右分别为: 
	
	关键词的内容: 
	- 此处可传入单个关键词字符串，或一个包含了任意数量关键词字符串的数组以批量注册关键词 
	- 若关键词包含[code]{@}[/code]，则满足匹配条件的同时还需要At机器人才视为匹配成功 
	- 若匹配模式为正则表达式模式，则关键词需要为一个正则表达式  
	
	关键词绑定的函数名: 
	- 当对应关键词匹配成功后将调用此函数，并传入四个参数 
	- 传入的四个参数分别为：关键词文本，解析后的关键词文本，关键词参数(通常为原消息去掉关键词后的文本)，触发关键词的事件实例引用  
	
	动态解析字典: 
	- 此处可以传入一个字典的引用，字典中的键与值均需要为字符串类型 
	- 若关键词中包含如"{xxx}"格式的文本，并且字典中拥有"xxx"这个键，那么实际用于匹配的关键词中的"{xxx}"文本将会被替换成字典中"xxx"键对应的值 
	- 例如，若您希望在运行时更改某插件中机器人的唤醒词，则只需将"{name}"注册为关键词，并指定一个包含"name"键的字典作为动态解析字典 
	- 后续您只需更改该字典中的"name"键对应的值，即可实时变更唤醒机器人的关键词  
	
	关键词的匹配模式 
	- 在某个消息事件触发"[trigger_keyword]"函数后，将提取消息事件的文本并根据匹配模式进行匹配 
	- 只有满足匹配模式对应的条件的关键词才会触发绑定的函数，匹配模式的具体行为请参见上方的[MatchMode]枚举  
	
	关键词匹配成功后阻断对应事件的传递 (可选,默认为true): 
	- 若此项为true,则在成功匹配关键词后，被对应事件调用的"[trigger_keyword]"函数将返回true以尝试阻断事件的传递 
	- 若此项为false,但是关键词所触发的函数返回了true,那么被对应事件调用的"[trigger_keyword]"函数也将返回true以尝试阻断事件的传递 
	- 阻断的具体行为将由相关事件注册时设置的阻断模式决定


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿unregister_keyword￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] keyword [color=gray])[/color]

	用于取消注册一个关键词，关键词被取消注册后将不会被用于匹配 
	
	需要传入对应的关键词字符串来将其取消注册，无法取消注册不属于此插件的关键词


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿trigger_keyword￿ [color=gray]([/color] [color=#70bafa][url=api:Event]Event[/url][/color] event [color=gray])[/color]

	根据传入的消息事件来提取文本并从中匹配关键词 
	
	通常只需在注册消息事件时将其与事件直接绑定即可


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿init_plugin_config￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] default_config, [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] config_description[color=gray] = {}[/color] [color=gray])[/color]

	用于初始化插件的配置文件，并将其加载到内存中，以便在后续对其内容进行操作 
	
	对于数据的储存，建议使用插件数据库功能，可以提供更快的读写速度及更好的类型安全性，且可储存几乎任何类型的数据 
	
	执行此函数时，将会检测是否已存在此插件对应的配置文件，否则将会基于给定的默认配置字典来新建一个配置文件 
	
	需要的参数从左到右分别为: 
	
	默认配置的字典(即为新建配置文件时其中将包含的内容，RainyBot将以Json格式将其保存为配置文件) 
	
	[可选,默认为空字典]每个配置项的介绍(字典的key为配置项的名称,对应的值为此配置项的相关介绍,两者均为字符串)


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿save_plugin_config￿ [color=gray]([/color] [color=gray])[/color]

	用于将内存中的配置保存到配置文件中，需要先初始化配置文件才能使用此函数


	● [color=#70bafa][url=godot:Variant]Variant[/url][/color] ￿get_plugin_config￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key [color=gray])[/color]

	用于从已加载的配置中获取指定key对应的内容，需要先初始化配置文件才能使用此函数


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿has_plugin_config￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key [color=gray])[/color]

	用于从已加载的配置中检查指定key是否存在，需要先初始化配置文件才能使用此函数


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿set_plugin_config￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key, [color=#70bafa][url=godot:Variant]Variant[/url][/color] value, [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于在已加载的配置中设定指定key的对应内容，需要先初始化配置文件才能使用此函数 
	
	最后一项可选的参数用于指定是否在设定的同时将更改立刻保存到配置文件中


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿reset_plugin_config￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key, [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于在已加载的配置中将指定key还原回默认值，需要先初始化配置文件才能使用此函数 
	
	最后一项可选的参数用于指定是否在还原的同时将更改立刻保存到配置文件中


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿reset_all_plugin_config￿ [color=gray]([/color] [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于在已加载的配置中将所有内容还原回默认值，需要先初始化配置文件才能使用此函数 
	
	最后一项可选参数用于指定是否在还原的同时将更改立即保存到配置文件中


	● [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] ￿get_plugin_config_metadata￿ [color=gray]([/color] [color=gray])[/color]

	用于直接获取已加载的配置的字典，便于以字典的形式对其进行操作，需要先初始化配置文件才能使用此函数


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿set_plugin_config_metadata￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic, [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于直接替换已加载的配置的字典为指定的字典，便于以字典的形式对其进行操作，需要先初始化配置文件才能使用此函数 
	
	最后一项参数用于指定是否在设定的同时将更改立刻保存到配置文件中


	● [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] ￿get_plugin_data_metadata￿ [color=gray]([/color] [color=gray])[/color]

	用于直接获取已加载的数据库的字典，便于以字典的形式对其进行操作，需要先初始化数据库文件才能使用此函数


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿set_plugin_data_metadata￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic, [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于直接替换已加载的数据库的字典为指定的字典，便于以字典的形式对其进行操作，需要先初始化数据库文件才能使用此函数 
	
	最后一项可选参数用于指定是否在设定的同时立即将更改保存到数据库文件中


	● [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] ￿get_plugin_cache_metadata￿ [color=gray]([/color] [color=gray])[/color]

	用于直接获取已加载的缓存数据库的字典，便于以字典的形式对其进行操作，需要先初始化缓存数据库文件才能使用此函数


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿set_plugin_cache_metadata￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic, [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于直接替换已加载的缓存数据库的字典为指定的字典，便于以字典的形式对其进行操作，需要先初始化缓存数据库文件才能使用此函数 
	
	最后一项可选参数用于指定是否在设定的同时立即将更改保存到缓存数据库文件中


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿init_plugin_data￿ [color=gray]([/color] [color=gray])[/color]

	用于初始化插件的数据库文件，并将其加载到内存中，以便在后续对其内容进行操作 
	
	对于配置的储存，建议使用插件配置功能，以便指定默认配置与配置说明，且能使用常规编辑器对其进行编辑与更改 
	
	执行此函数时，将会检测是否已存在此插件对应的数据库文件，否则将会新建一个空白的数据库文件(.rdb格式)


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿save_plugin_data￿ [color=gray]([/color] [color=gray])[/color]

	用于将内存中的数据保存到数据库文件中，需要先初始化数据库文件才能使用此函数


	● [color=#70bafa][url=godot:Variant]Variant[/url][/color] ￿get_plugin_data￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key [color=gray])[/color]

	用于从已加载的数据库中获取指定key对应的内容，需要先初始化数据库文件才能使用此函数


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿has_plugin_data￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key [color=gray])[/color]

	用于从已加载的数据库中检查指定key是否存在，需要先初始化数据库文件才能使用此函数


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿set_plugin_data￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key, [color=#70bafa][url=godot:Variant]Variant[/url][/color] value, [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于在已加载的数据库中设定指定key的对应内容，需要先初始化数据库文件才能使用此函数 
	
	最后一项可选参数用于指定是否在设定的同时将更改立即保存到数据库文件中


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿remove_plugin_data￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key, [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于在已加载的数据库中删除指定key及其对应内容，需要先初始化数据库文件才能使用此函数 
	
	最后一项可选参数用于指定是否在删除的同时将更改立即保存到数据库文件中


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿clear_plugin_data￿ [color=gray]([/color] [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于在已加载的数据库中清空所有内容，需要先初始化数据库文件才能使用此函数 
	
	最后一项可选参数用于指定是否在清空的同时将更改立即保存到数据库文件中


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿init_plugin_cache￿ [color=gray]([/color] [color=gray])[/color]

	用于初始化插件的缓存数据库文件，并将其加载到内存中，以便在后续对其内容进行操作 
	
	缓存数据库中的所有内容及文件本身会在插件卸载/重载时保留，但是会在RainyBot关闭时永久删除 
	
	执行此函数时，将会检测是否已存在此插件对应的缓存数据库文件，否则将会新建一个空白的缓存数据库文件(.rca格式)


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿save_plugin_cache￿ [color=gray]([/color] [color=gray])[/color]

	用于将内存中的数据保存到缓存数据库文件中，需要先初始化缓存数据库文件才能使用此函数


	● [color=#70bafa][url=godot:Variant]Variant[/url][/color] ￿get_plugin_cache￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key [color=gray])[/color]

	用于从已加载的缓存数据库中获取指定key对应的内容，需要先初始化缓存数据库文件才能使用此函数


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿has_plugin_cache￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key [color=gray])[/color]

	用于从已加载的缓存数据库中检查指定key是否存在，需要先初始化缓存数据库文件才能使用此函数


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿set_plugin_cache￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key, [color=#70bafa][url=godot:Variant]Variant[/url][/color] value, [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于在已加载的缓存数据库中设定指定key的对应内容，需要先初始化缓存数据库文件才能使用此函数 
	
	最后一项可选参数用于指定是否在设定的同时将更改立即保存到缓存数据库文件中


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿remove_plugin_cache￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] key, [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于在已加载的缓存数据库中删除指定key及其对应内容，需要先初始化缓存数据库文件才能使用此函数 
	
	最后一项可选参数用于指定是否在删除的同时将更改立即保存到缓存数据库文件中


	● [color=#70bafa][url=godot:int]int[/url][/color] ￿clear_plugin_cache￿ [color=gray]([/color] [color=#70bafa][url=godot:bool]bool[/url][/color] save_file[color=gray] = true[/color] [color=gray])[/color]

	用于在已加载的缓存数据库中清空所有内容，需要先初始化缓存数据库文件才能使用此函数 
	
	最后一项可选参数用于指定是否在清空的同时将更改立即保存到缓存数据库文件中


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿unload_plugin￿ [color=gray]([/color] [color=gray])[/color]

	调用此函数后，插件将会尝试卸载自身 
	
	若此插件被其他插件依赖，则可能会卸载失败


	● [color=#70bafa][url=godot:Node]Node[/url][/color] ￿load_scene￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] path, [color=#70bafa][url=godot:bool]bool[/url][/color] for_capture[color=gray] = false[/color] [color=gray])[/color]

	加载一个场景文件，并根据第二个参数将其准备为用于图像捕捉或用于其他用途(如自定义GUI)，需要配合await关键字来使用此函数 
	
	注意：加载场景与根目录的相对路径必须与场景在原项目时所在的相对路径相同，且加载前请确保已重新导入所有资源(位于插件菜单中)，否则可能会加载失败或出现未知问题 
	例如，原项目中位于"[code]res://plugins[/code]"的场景在加载时必须位于"[code]RainyBot根目录/plugins[/code]"路径下 
	
	需要的参数从左到右分别为: 
	- 场景文件的路径，可以是相对路径(以[code]res://[/code]开头)，也可以是绝对路径(如D:/RaintBot/plugins，可通过[get_plugin_path]函数来获取插件目录的绝对路径) 
	- 是否将加载的场景准备为用于图像捕捉 (可选，默认为false，必须启用才可使用[get_scene_image]函数来获取其中内容的图像，否则会直接将其添加为插件的子项以便用于其他用途(如自定义GUI)) 
	
	小贴士：出于性能原因，对已加载的场景或其附加脚本所做的的任何修改均无法通过重载插件来实时更新，因此在修改场景或其脚本后，请通过主菜单中的重新启动选项来快速重启RainyBot以便应用您所做的任何更改


	● [color=#70bafa][url=godot:Image]Image[/url][/color] ￿get_scene_image￿ [color=gray]([/color] [color=#70bafa][url=godot:Node]Node[/url][/color] scene, [color=#70bafa][url=godot:Vector2i]Vector2i[/url][/color] size, [color=#70bafa][url=godot:Vector2i]Vector2i[/url][/color] stretch_size[color=gray] = Vector2i(0, 0)[/color], [color=#70bafa][url=godot:bool]bool[/url][/color] transparent[color=gray] = false[/color] [color=gray])[/color]

	将指定场景实例中的当前内容获取为[Image]类图像的实例，需要配合await关键字来使用此函数 
	
	请确保指定的场景是通过load_scene()函数加载的，且加载时在函数中启用了for_capture参数，否则将无法正确获取其中的内容 
	
	需要的参数从左到右分别为: 
	- 需要从其中获取图像的场景实例，场景实例需要满足上述条件才能被正确获取为图像 
	- 要生成的图像的原始大小，这决定了场景的内容将会以何种分辨率渲染为图像 
	- 图像生成后要拉伸到的大小(可选，默认为[code]Vector2i(0,0)[/code])，若设置为大于0的值，则将基于第二个参数的大小渲染图像，并将渲染后的图像拉伸为此参数指定的大小 
	- 设置生成的图像是否启用透明背景(可选，默认为[code]false[/code])。若启用透明背景，则场景中任何拥有透明度的位置在获取的图像中将拥有同样的透明度，空白的位置在获取的图像中将完全透明


	● [color=#70bafa][url=godot:Variant]Variant[/url][/color] ￿wait_context_custom￿ [color=gray]([/color] [color=#70bafa][url=godot:GDScript]GDScript[/url][/color] event_type, [color=#70bafa][url=godot:int]int[/url][/color] sender_id[color=gray] = -1[/color], [color=#70bafa][url=godot:int]int[/url][/color] group_id[color=gray] = -1[/color], [color=#70bafa][url=godot:float]float[/url][/color] timeout[color=gray] = 20.0[/color], [color=#70bafa][url=godot:bool]bool[/url][/color] block[color=gray] = true[/color] [color=gray])[/color]

	通过await调用后，将等待一个满足指定发送者id，指定群组id的指定类型的消息事件 
	
	消息事件不会自动进行上下文匹配，而是需要手动调用或者在注册消息事件时将需要匹配上下文的消息事件手动绑定到"[respond_context]"函数即可 
	
	接收到满足条件的事件后，该函数将返回该事件的引用，否则在达到指定的超时秒数后，将返回null 
	
	需要的参数从左到右分别为： 
	- 要等待的消息事件的类型 
	- 要匹配的发送者ID(可选，若为-1则不匹配此项) 
	- 要匹配的群组ID(可选，若为-1则不匹配此项) 
	- 等待的超时时间(可选，默认为20秒; 若数值小于等于0, 或已存在相同的等待, 则不启用超时) 
	- 消息事件匹配成功后阻断对应事件的传递 (可选,默认为true)


	● [color=#70bafa][url=godot:Variant]Variant[/url][/color] ￿wait_context￿ [color=gray]([/color] [color=#70bafa][url=api:MessageEvent]MessageEvent[/url][/color] event, [color=#70bafa][url=godot:bool]bool[/url][/color] match_sender[color=gray] = true[/color], [color=#70bafa][url=godot:bool]bool[/url][/color] match_group[color=gray] = true[/color], [color=#70bafa][url=godot:float]float[/url][/color] timeout[color=gray] = 20.0[/color], [color=#70bafa][url=godot:bool]bool[/url][/color] block[color=gray] = true[/color] [color=gray])[/color]

	通过await调用后，将等待另外一个与指定消息事件相匹配的消息事件 
	
	消息事件不会自动进行上下文匹配，而是需要手动调用或者在注册消息事件时将需要进行匹配的消息事件手动绑定到"[respond_context]"函数即可 
	
	接收到满足条件的事件后，该函数将返回该事件的引用，否则在达到指定的超时秒数后，将返回null 
	
	需要的参数从左到右分别为： 
	- 要匹配的消息事件的实例引用 
	- 是否要匹配消息事件中的发送者ID(可选，默认为true) 
	- 是否要匹配消息事件中的群组ID(可选，默认为true) 
	- 等待的超时时间(可选，默认为20秒; 若数值小于等于0, 或已存在相同的等待, 则不启用超时) 
	- 消息事件匹配成功后阻断对应事件的传递 (可选,默认为true)


	● [color=#70bafa][url=godot:Variant]Variant[/url][/color] ￿wait_context_id￿ [color=gray]([/color] [color=#70bafa][url=godot:String]String[/url][/color] context_id, [color=#70bafa][url=godot:float]float[/url][/color] timeout[color=gray] = 20.0[/color] [color=gray])[/color]

	通过await调用后，将等待指定id的响应，并在收到响应后返回响应的内容 
	
	要进行响应，需要在某处手动调用"[respond_context]"函数并传入相同的ID 
	
	若未进行响应且在达到指定的超时秒数后，将返回null 
	
	需要的参数从左到右分别为： 
	- 要等待响应的自定义ID 
	- 等待的超时时间(可选，默认为20秒; 若数值小于等于0, 或已存在相同的等待, 则不启用超时)


	● [color=#70bafa][url=godot:bool]bool[/url][/color] ￿respond_context￿ [color=gray]([/color] [color=#70bafa][url=godot:Variant]Variant[/url][/color] context, [color=#70bafa][url=godot:Variant]Variant[/url][/color] response[color=gray] = true[/color] [color=gray])[/color]

	用于响应正在进行中的上下文等待 
	
	若第一个参数传入内容为一个消息事件，则将用于响应与消息事件相关的上下文等待，并且第二个参数将被忽略 
	通常只需在注册消息事件时将其与事件直接绑定后即可自动进行此类上下文响应  
	
	若第一个参数传入内容为一个字符串，则将用于响应指定ID的上下文等待，此时可通过第二个参数指定响应的内容 
	第二个参数为可选参数，可以是任何类型的值；若不填则默认响应内容为布尔值true


