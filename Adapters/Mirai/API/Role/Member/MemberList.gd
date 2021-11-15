extends MemberAPI


class_name MemberList


var data_array:Array = []


static func init_meta(arr:Array)->MemberList:
	var ins:MemberList = MemberList.new()
	ins.data_array = arr
	return ins


func get_metadata()->Array:
	return data_array


func set_metadata(arr:Array):
	data_array = arr


func get_from_index(index:int)->Member:
	if (index >= 0) && (index < data_array.size()-1):
		var member_dic:Dictionary = data_array[index]
		var ins = Member.init_meta(member_dic)
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
