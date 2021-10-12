extends Node

enum message_events{
	FriendMessage,
	GroupMessage,
	TempMessage,
	StrangerMessage,
	OtherClientMessage,
}

enum message_types{
	Source,
	Quote,
	At,
	AtAll,
	Face,
	Plain,
	Image,
	FlashImage,
	Voice,
	Xml,
	Json,
	App,
	Poke,
	Dice,
	MusicShare,
	Forward,
	File,
	MiraiCode
}

enum bot_events{
	BotOnlineEvent,
	BotOfflineEventActive,
	BotOfflineEventForce,
	BotOfflineEventDropped,
	BotReloginEvent,
	FriendInputStatusChangedEvent,
	FriendNickChangedEvent,
	BotGroupPermissionChangeEvent,
	BotMuteEvent,
	BotUnmuteEvent,
	BotJoinGroupEvent,
	BotLeaveEventActive,
	BotLeaveEventKick,
	GroupRecallEvent,
	FriendRecallEvent,
	NudgeEvent,
	GroupNameChangeEvent,
	GroupEntranceAnnouncementChangeEvent,
	GroupMuteAllEvent,
	GroupAllowAnonymousChatEvent,
	GroupAllowConfessTalkEvent,
	GroupAllowMemberInviteEvent,
	MemberJoinEvent,
	MemberLeaveEventKick,
	MemberLeaveEventQuit,
	MemberCardChangeEvent,
	MemberSpecialTitleChangeEvent,
	MemberPermissionChangeEvent,
	MemberMuteEvent,
	MemberUnmuteEvent,
	MemberHonorChangeEvent,
	NewFriendRequestEvent,
	MemberJoinRequestEvent,
	BotInvitedJoinGroupRequestEvent,
	OtherClientOnlineEvent,
	OtherClientOfflineEvent,
	CommandExecutedEvent,
}

enum permission_types{
	OWNER,
	ADMINISTRATOR,
	MEMBER
}


func get_message_event_id(_name:String):
	return message_events[_name]
	
func get_message_type_id(_name:String):
	return message_types[_name]
	
func get_bot_event_id(_name:String):
	return bot_events[_name]
	
func get_permission_type_id(_name:String):
	return permission_types[_name]


func get_message_event_name(event:int):
	return message_events.keys()[event]
	
func get_message_type_name(type:int):
	return message_types.keys()[type]
	
func get_bot_event_name(event:int):
	return bot_events.keys()[event]
	
func get_permission_type_name(type:int):
	return permission_types.keys()[type]


func message_event_has_name(_name:String):
	return message_events.has(_name)
	
func message_type_has_name(_name:String):
	return message_types.has(_name)
	
func bot_event_has_name(_name:String):
	return bot_events.has(_name)
	
func permission_type_has_name(_name:String):
	return permission_types.has(_name)
