extends Object

class_name Interface

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
	Owner,
	Administrator,
	Member
}

enum poke_types{
	Poke,
	ShowLove,
	Like,
	Heartbroken,
	SixSixSix,
	FangDaZhao
}

enum group_data{
	Id,
	Name,
	Permission
}

enum member_data{
	Id,
	Name,
	MemberName,
	Remark,
	SpecialTitle,
	Permission,
	JoinTimestamp,
	LastSpeakTimestamp,
	MuteTimeRemaining,
	Group,
	Platform
}

enum app_message_data{
	AppText
}

enum at_all_message_data{}

enum at_message_data{
	TargetId,
	DisplayText
}

enum face_message_data{
	FaceId,
	Name
}

enum flash_image_message_data{
	ImageId,
	Url,
	Path,
	Base64
}

enum image_message_data{
	ImageId,
	Url,
	Path,
	Base64
}

enum json_message_data{
	JsonText
}

enum plain_message_data{
	Text
}

enum poke_message_data{
	PokeType
}

enum quote_message_data{
	MessageId,
	GroupId,
	SenderId,
	TargetId,
	OriginMessageChain
}

enum source_message_data{
	MessageId,
	Timestamp
}

enum voice_message_data{
	VoiceId,
	Url,
	Path,
	Base64,
	Length
}

enum xml_message_data{
	XmlText
}
