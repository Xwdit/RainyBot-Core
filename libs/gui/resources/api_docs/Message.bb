[font_size=25][b][color=#70bafa]类:[/color] Message[/b][/font_size]
[color=#70bafa]继承:[/color] [url=api:MessageAPI]MessageAPI[/url]
[color=#70bafa]派生:[/color] [url=api:AppMessage]AppMessage[/url], [url=api:AtAllMessage]AtAllMessage[/url], [url=api:AtMessage]AtMessage[/url], [url=api:BotCodeMessage]BotCodeMessage[/url], [url=api:DiceMessage]DiceMessage[/url], [url=api:FaceMessage]FaceMessage[/url], [url=api:FileMessage]FileMessage[/url], [url=api:FlashImageMessage]FlashImageMessage[/url], [url=api:ForwardMessage]ForwardMessage[/url], [url=api:ImageMessage]ImageMessage[/url], [url=api:JsonMessage]JsonMessage[/url], [url=api:MarketFaceMessage]MarketFaceMessage[/url], [url=api:MusicShareMessage]MusicShareMessage[/url], [url=api:PokeMessage]PokeMessage[/url], [url=api:QuoteMessage]QuoteMessage[/url], [url=api:SourceMessage]SourceMessage[/url], [url=api:TextMessage]TextMessage[/url], [url=api:VoiceMessage]VoiceMessage[/url], [url=api:XmlMessage]XmlMessage[/url]


[b]RainyBot的消息类，不具备任何功能，仅作为所有消息类型的直接或间接父类[/b]


[font_size=25][color=#70bafa][b]描述[/b][/color][/font_size]

这是RainyBot的消息类，不具备任何功能，仅作为所有消息类型的直接或间接父类 
多数消息相关操作都密切依赖于此类及其子类(构造/发送/获取消息或消息链等)


[font_size=25][color=#70bafa][b]方法[/b][/color][/font_size]

	● [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] ￿get_metadata￿ [color=gray]([/color] [color=gray])[/color]

	获取实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=gray][hint=此方法无返回值]void[/hint][/color] ￿set_metadata￿ [color=gray]([/color] [color=#70bafa][url=godot:Dictionary]Dictionary[/url][/color] dic [color=gray])[/color]

	使用指定字典覆盖实例中的元数据字典，仅当你知道自己在做什么时才使用


	● [color=#70bafa][url=godot:String]String[/url][/color] ￿get_as_text￿ [color=gray]([/color] [color=gray])[/color]

	将此消息类实例获取为字符串，具体行为请参见继承此类的每个子类


