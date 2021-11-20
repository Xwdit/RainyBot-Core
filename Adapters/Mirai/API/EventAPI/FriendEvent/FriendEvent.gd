extends Event


class_name FriendEvent


enum Type{
	INPUT_STATUS_CHANGED,
	NICK_CHANGED,
	RECALL
}


func get_member()->Member:
	return Member.init_meta(get("data_dic").friend)
