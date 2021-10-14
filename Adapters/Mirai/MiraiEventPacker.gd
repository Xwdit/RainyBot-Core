extends Object


static func pack_group_data(group_dic:Dictionary):
	var group = Group.new()
	for keys in group_dic:
		group.data[MiraiCaster.group_data_from_mirai(keys)] = group_dic[keys]
	if group_dic.has(MiraiCaster.group_data_to_mirai(Interface.group_data.Permission)):
		group.data[Interface.group_data.Permission] = group_dic[MiraiCaster.group_data_to_mirai(Interface.group_data.Permission)]
	return group


static func pack_member_data(member_dic:Dictionary):
	var member = Member.new()
	for keys in member_dic:
		member.data[MiraiCaster.member_data_from_mirai(keys)] = member_dic[keys]
	if member_dic.has(MiraiCaster.group_data_to_mirai(Interface.member_data.Permission)):
		member.data[Interface.member_data.Permission] = member_dic[MiraiCaster.group_data_to_mirai(Interface.member_data.Permission)]
	if member_dic.has(MiraiCaster.group_data_to_mirai(Interface.member_data.Group)):
		member.data[Interface.member_data.Group] = pack_group_data(member_dic[MiraiCaster.group_data_to_mirai(Interface.member_data.Group)])
		

static func pack_single_message(msg_dic:Dictionary):
	if msg_dic.has("type"):
		var msg:SingleMessage
		match msg_dic["type"]:
			"App":
				msg = AppMessage.new()
				for keys in msg_dic:
					msg.data[MiraiCaster.app_message_data_from_mirai(keys)] = msg_dic[keys]
			"AtAll":
				msg = AtAllMessage.new()
			"Source":
				msg = SourceMessage.new()
				for keys in msg_dic:
					msg.data[MiraiCaster.source_message_data_from_mirai(keys)] = msg_dic[keys]
			"Face":
				msg = FaceMessage.new()
				for keys in msg_dic:
					msg.data[MiraiCaster.face_message_data_from_mirai(keys)] = msg_dic[keys]
			"FlashImage":
				msg = FlashImageMessage.new()
				for keys in msg_dic:
					msg.data[MiraiCaster.flash_image_message_data_from_mirai(keys)] = msg_dic[keys]
					
		return msg
		
		
static func pack_message_chain(chain_array:Array):
	var chain = MessageChain.new()
	for msg_dic in chain_array:
		var msg = pack_single_message(msg_dic)
		chain.append(msg)
