extends MemberAPI


class_name MemberList


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


func _iter_get(_arg)->Member:
	return get_from_index(iter_current)


static func init_meta(arr:Array)->MemberList:
	var ins:MemberList = MemberList.new()
	ins.data_array = arr
	return ins


func get_metadata()->Array:
	return data_array


func set_metadata(arr:Array)->void:
	data_array = arr


func get_from_index(index:int)->Member:
	if (index >= 0) && (index <= data_array.size()-1):
		var member_dic:Dictionary = data_array[index]
		var ins:Member = Member.init_meta(member_dic)
		return ins
	else:
		return null
		
		
func get_from_id(member_id:int)->Member:
	for _member in data_array:
		if _member.id == member_id:
			return Member.init_meta(_member)
	return null
		
		
func get_size()->int:
	return data_array.size()


func has_member(member_id:int)->bool:
	for _member in data_array:
		if _member.id == member_id:
			return true
	return false
