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

enum message_data{
	Type,
	MessageId,
	SenderId,
	TargetId,
	GroupId,
	Timestamp,
	OriginMessageChain,
	DisplayText,
	FaceId,
	FaceName,
	ImageId,
	VoiceId,
	Url,
	Path,
	Base64,
	Length,
	Text,
	PokeType,
	Value,
	Kind,
	Title,
	Summary,
	JumpUrl,
	PictureUrl,
	MusicUrl,
	Brief,
	NodeList,
	FileId,
	FileName,
	FileSize
}
