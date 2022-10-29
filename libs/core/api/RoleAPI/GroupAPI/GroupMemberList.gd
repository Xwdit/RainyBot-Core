extends GroupAPI


class_name GroupMemberList


var data_array:Array = []
var iter_current:int = 0


func _iter_should_continue()->bool:
	return (iter_current < data_array.size())


func _iter_init(_arg)->bool:
	iter_current = 0
	return _iter_should_continue()


func _iter_next(_arg)->bool:
	iter_current += 1
	return _iter_should_continue()


func _iter_get(_arg)->GroupMember:
	return get_from_index(iter_current)


static func init_meta(arr:Array)->GroupMemberList:
	var ins:GroupMemberList = GroupMemberList.new()
	ins.data_array = arr
	return ins


func get_metadata()->Array:
	return data_array


func set_metadata(arr:Array)->void:
	data_array = arr


func get_from_index(index:int)->GroupMember:
	if (index >= 0) && (index <= data_array.size()-1):
		var member_dic:Dictionary = data_array[index]
		var ins:GroupMember = GroupMember.init_meta(member_dic)
		return ins
	else:
		return null
		

func get_from_id(member_id:int)->GroupMember:
	for _member in data_array:
		if _member.id == member_id:
			return GroupMember.init_meta(_member)
	return null


func has_member(member_id:int)->bool:
	for _member in data_array:
		if _member.id == member_id:
			return true
	return false


func get_size()->int:
	return data_array.size()
