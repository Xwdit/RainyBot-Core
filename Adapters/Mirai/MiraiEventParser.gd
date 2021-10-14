extends Object


static func parse_group_data(group_dic:Dictionary):
	var group = Group.new()
	if group_dic.has("id"):
		group.data.id = group_dic["id"]
	if group_dic.has("name"):
		group.data.name = group_dic["name"]
	if group_dic.has("permission"):
		group.data.permission = MiraiCaster.permission_type_from_mirai(group_dic["permission"])
	return group


static func parse_member_data(member_dic:Dictionary):
	var member = Member.new()
	if member_dic.has("id"):
		member.data.id = member_dic["id"]
	if member_dic.has("memberName"):
		member.data.name = member_dic["memberName"]
	if member_dic.has("nickname"):
		member.data.name = member_dic["nickname"]
	if member_dic.has("remark"):
		member.data.remark = member_dic["remark"]
	if member_dic.has("specialTitle"):
		member.data.special_title = member_dic["specialTitle"]
	if member_dic.has("permission"):
		member.data.permission = MiraiCaster.permission_type_from_mirai(member_dic["permission"])
	if member_dic.has("joinTimestamp"):
		member.data.join_timestamp = member_dic["joinTimestamp"]
	if member_dic.has("lastSpeakTimestamp"):
		member.data.last_speak_timestamp = member_dic["lastSpeakTimestamp"]
	if member_dic.has("muteTimeRemaining"):
		member.data.mute_time_remaining = member_dic["muteTimeRemaining"]
	if member_dic.has("group"):
		var group_dic = member_dic["group"]
		if group_dic is Dictionary:
			member.data.group = parse_group_data(group_dic)
	if member_dic.has("platform"):
		member.data.platform = member_dic["platform"]
