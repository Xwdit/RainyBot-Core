extends Object


static func pack_group_data(group_dic:Dictionary) -> Group:
	var group = Group.new()
	for keys in group_dic:
		group.data[MiraiCaster.group_data_from_mirai(keys)] = group_dic[keys]
	if group_dic.has(MiraiCaster.group_data_to_mirai(Interface.group_data.Permission)):
		group.data[Interface.group_data.Permission] = group_dic[MiraiCaster.group_data_to_mirai(Interface.group_data.Permission)]
	return group


static func pack_member_data(member_dic:Dictionary) -> Member:
	var member = Member.new()
	for keys in member_dic:
		member.data[MiraiCaster.member_data_from_mirai(keys)] = member_dic[keys]
	if member_dic.has(MiraiCaster.group_data_to_mirai(Interface.member_data.Permission)):
		member.data[Interface.member_data.Permission] = member_dic[MiraiCaster.group_data_to_mirai(Interface.member_data.Permission)]
	if member_dic.has(MiraiCaster.group_data_to_mirai(Interface.member_data.Group)):
		member.data[Interface.member_data.Group] = pack_group_data(member_dic[MiraiCaster.group_data_to_mirai(Interface.member_data.Group)])
	return member	

static func pack_message(msg_dic:Dictionary):
	var msg = Message.new()
	for keys in msg_dic:
		msg.data[MiraiCaster.message_data_from_mirai(keys)] = msg_dic[keys]
	return msg
		
		
static func pack_message_chain(chain_array:Array):
	var chain = MessageChain.new()
	for msg_dic in chain_array:
		var msg = pack_single_message(msg_dic)
		chain.append(msg)
