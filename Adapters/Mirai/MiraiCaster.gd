extends Object

class_name MiraiCaster

const message_events = {
	"FriendMessage":Interface.message_events.FriendMessage,
	"GroupMessage":Interface.message_events.GroupMessage,
	"TempMessage":Interface.message_events.TempMessage,
	"StrangerMessage":Interface.message_events.StrangerMessage,
	"OtherClientMessage":Interface.message_events.OtherClientMessage,
}

const message_events_revert = {
	Interface.message_events.FriendMessage:"FriendMessage",
	Interface.message_events.GroupMessage:"GroupMessage",
	Interface.message_events.TempMessage:"TempMessage",
	Interface.message_events.StrangerMessage:"StrangerMessage",
	Interface.message_events.OtherClientMessage:"OtherClientMessage"
}

const message_types = {
	"Source":Interface.message_types.Source,
	"Quote":Interface.message_types.Quote,
	"At":Interface.message_types.At,
	"AtAll":Interface.message_types.AtAll,
	"Face":Interface.message_types.Face,
	"Plain":Interface.message_types.Plain,
	"Image":Interface.message_types.Image,
	"FlashImage":Interface.message_types.FlashImage,
	"Voice":Interface.message_types.Voice,
	"Xml":Interface.message_types.Xml,
	"Json":Interface.message_types.Json,
	"App":Interface.message_types.App,
	"Poke":Interface.message_types.Poke,
	"Dice":Interface.message_types.Dice,
	"MusicShare":Interface.message_types.MusicShare,
	"Forward":Interface.message_types.Forward,
	"File":Interface.message_types.File,
	"MiraiCode":Interface.message_types.MiraiCode
}

const message_types_revert = {
	Interface.message_types.Source:"Source",
	Interface.message_types.Quote:"Quote",
	Interface.message_types.At:"At",
	Interface.message_types.AtAll:"AtAll",
	Interface.message_types.Face:"Face",
	Interface.message_types.Plain:"Plain",
	Interface.message_types.Image:"Image",
	Interface.message_types.FlashImage:"FlashImage",
	Interface.message_types.Voice:"Voice",
	Interface.message_types.Xml:"Xml",
	Interface.message_types.Json:"Json",
	Interface.message_types.App:"App",
	Interface.message_types.Poke:"Poke",
	Interface.message_types.Dice:"Dice",
	Interface.message_types.MusicShare:"MusicShare",
	Interface.message_types.Forward:"Forward",
	Interface.message_types.File:"File",
	Interface.message_types.MiraiCode:"MiraiCode"
}

const bot_events = {
	"BotOnlineEvent":Interface.bot_events.BotOnlineEvent,
	"BotOfflineEventActive":Interface.bot_events.BotOfflineEventActive,
	"BotOfflineEventForce":Interface.bot_events.BotOfflineEventForce,
	"BotOfflineEventDropped":Interface.bot_events.BotOfflineEventDropped,
	"BotReloginEvent":Interface.bot_events.BotReloginEvent,
	"FriendInputStatusChangedEvent":Interface.bot_events.FriendInputStatusChangedEvent,
	"FriendNickChangedEvent":Interface.bot_events.FriendNickChangedEvent,
	"BotGroupPermissionChangeEvent":Interface.bot_events.BotGroupPermissionChangeEvent,
	"BotMuteEvent":Interface.bot_events.BotMuteEvent,
	"BotUnmuteEvent":Interface.bot_events.BotUnmuteEvent,
	"BotJoinGroupEvent":Interface.bot_events.BotJoinGroupEvent,
	"BotLeaveEventActive":Interface.bot_events.BotLeaveEventActive,
	"BotLeaveEventKick":Interface.bot_events.BotLeaveEventKick,
	"GroupRecallEvent":Interface.bot_events.GroupRecallEvent,
	"FriendRecallEvent":Interface.bot_events.FriendRecallEvent,
	"NudgeEvent":Interface.bot_events.NudgeEvent,
	"GroupNameChangeEvent":Interface.bot_events.GroupNameChangeEvent,
	"GroupEntranceAnnouncementChangeEvent":Interface.bot_events.GroupEntranceAnnouncementChangeEvent,
	"GroupMuteAllEvent":Interface.bot_events.GroupMuteAllEvent,
	"GroupAllowAnonymousChatEvent":Interface.bot_events.GroupAllowAnonymousChatEvent,
	"GroupAllowConfessTalkEvent":Interface.bot_events.GroupAllowConfessTalkEvent,
	"GroupAllowMemberInviteEvent":Interface.bot_events.GroupAllowMemberInviteEvent,
	"MemberJoinEvent":Interface.bot_events.MemberJoinEvent,
	"MemberLeaveEventKick":Interface.bot_events.MemberLeaveEventKick,
	"MemberLeaveEventQuit":Interface.bot_events.MemberLeaveEventQuit,
	"MemberCardChangeEvent":Interface.bot_events.MemberCardChangeEvent,
	"MemberSpecialTitleChangeEvent":Interface.bot_events.MemberSpecialTitleChangeEvent,
	"MemberPermissionChangeEvent":Interface.bot_events.MemberPermissionChangeEvent,
	"MemberMuteEvent":Interface.bot_events.MemberMuteEvent,
	"MemberUnmuteEvent":Interface.bot_events.MemberUnmuteEvent,
	"MemberHonorChangeEvent":Interface.bot_events.MemberHonorChangeEvent,
	"NewFriendRequestEvent":Interface.bot_events.NewFriendRequestEvent,
	"MemberJoinRequestEvent":Interface.bot_events.MemberJoinRequestEvent,
	"BotInvitedJoinGroupRequestEvent":Interface.bot_events.BotInvitedJoinGroupRequestEvent,
	"OtherClientOnlineEvent":Interface.bot_events.OtherClientOnlineEvent,
	"OtherClientOfflineEvent":Interface.bot_events.OtherClientOfflineEvent,
	"CommandExecutedEvent":Interface.bot_events.CommandExecutedEvent,
}

const bot_events_revert = {
	Interface.bot_events.BotOnlineEvent:"BotOnlineEvent",
	Interface.bot_events.BotOfflineEventActive:"BotOfflineEventActive",
	Interface.bot_events.BotOfflineEventForce:"BotOfflineEventForce",
	Interface.bot_events.BotOfflineEventDropped:"BotOfflineEventDropped",
	Interface.bot_events.BotReloginEvent:"BotReloginEvent",
	Interface.bot_events.FriendInputStatusChangedEvent:"FriendInputStatusChangedEvent",
	Interface.bot_events.FriendNickChangedEvent:"FriendNickChangedEvent",
	Interface.bot_events.BotGroupPermissionChangeEvent:"BotGroupPermissionChangeEvent",
	Interface.bot_events.BotMuteEvent:"BotMuteEvent",
	Interface.bot_events.BotUnmuteEvent:"BotUnmuteEvent",
	Interface.bot_events.BotJoinGroupEvent:"BotJoinGroupEvent",
	Interface.bot_events.BotLeaveEventActive:"BotLeaveEventActive",
	Interface.bot_events.BotLeaveEventKick:"BotLeaveEventKick",
	Interface.bot_events.GroupRecallEvent:"GroupRecallEvent",
	Interface.bot_events.FriendRecallEvent:"FriendRecallEvent",
	Interface.bot_events.NudgeEvent:"NudgeEvent",
	Interface.bot_events.GroupNameChangeEvent:"GroupNameChangeEvent",
	Interface.bot_events.GroupEntranceAnnouncementChangeEvent:"GroupEntranceAnnouncementChangeEvent",
	Interface.bot_events.GroupMuteAllEvent:"GroupMuteAllEvent",
	Interface.bot_events.GroupAllowAnonymousChatEvent:"GroupAllowAnonymousChatEvent",
	Interface.bot_events.GroupAllowConfessTalkEvent:"GroupAllowConfessTalkEvent",
	Interface.bot_events.GroupAllowMemberInviteEvent:"GroupAllowMemberInviteEvent",
	Interface.bot_events.MemberJoinEvent:"MemberJoinEvent",
	Interface.bot_events.MemberLeaveEventKick:"MemberLeaveEventKick",
	Interface.bot_events.MemberLeaveEventQuit:"MemberLeaveEventQuit",
	Interface.bot_events.MemberCardChangeEvent:"MemberCardChangeEvent",
	Interface.bot_events.MemberSpecialTitleChangeEvent:"MemberSpecialTitleChangeEvent",
	Interface.bot_events.MemberPermissionChangeEvent:"MemberPermissionChangeEvent",
	Interface.bot_events.MemberMuteEvent:"MemberMuteEvent",
	Interface.bot_events.MemberUnmuteEvent:"MemberUnmuteEvent",
	Interface.bot_events.MemberHonorChangeEvent:"MemberHonorChangeEvent",
	Interface.bot_events.NewFriendRequestEvent:"NewFriendRequestEvent",
	Interface.bot_events.MemberJoinRequestEvent:"MemberJoinRequestEvent",
	Interface.bot_events.BotInvitedJoinGroupRequestEvent:"BotInvitedJoinGroupRequestEvent",
	Interface.bot_events.OtherClientOnlineEvent:"OtherClientOnlineEvent",
	Interface.bot_events.OtherClientOfflineEvent:"OtherClientOfflineEvent",
	Interface.bot_events.CommandExecutedEvent:"CommandExecutedEvent"
}

const permission_types = {
	"OWNER":Interface.permission_types.OWNER,
	"ADMINISTRATOR":Interface.permission_types.ADMINISTRATOR,
	"MEMBER":Interface.permission_types.MEMBER,
}

const permission_types_revert = {
	Interface.permission_types.OWNER:"OWNER",
	Interface.permission_types.ADMINISTRATOR:"ADMINISTRATOR",
	Interface.permission_types.MEMBER:"MEMBER"
}

static func message_event_from_mirai(event_str:String) -> int:
	if message_events.has(event_str):
		return message_events[event_str]
	else:
		return -1
		
static func message_event_to_mirai(event_id:int) -> String:
	if message_events_revert.has(event_id):
		return message_events_revert[event_id]
	else:
		return ""
		
static func message_type_from_mirai(type_str:String) -> int:
	if message_types.has(type_str):
		return message_types[type_str]
	else:
		return -1
		
static func message_type_to_mirai(type_id:int) -> String:
	if message_types_revert.has(type_id):
		return message_types_revert[type_id]
	else:
		return ""
		
static func bot_event_from_mirai(event_str:String) -> int:
	if bot_events.has(event_str):
		return bot_events[event_str]
	else:
		return -1
		
static func bot_event_to_mirai(event_id:int) -> String:
	if bot_events_revert.has(event_id):
		return bot_events_revert[event_id]
	else:
		return ""
		
static func permission_type_from_mirai(type_str:String) -> int:
	if permission_types.has(type_str):
		return permission_types[type_str]
	else:
		return -1
		
static func permission_type_to_mirai(type_id:int) -> String:
	if permission_types_revert.has(type_id):
		return permission_types_revert[type_id]
	else:
		return ""
