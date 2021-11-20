extends GroupAPI


class_name GroupMemberList


var data_array:Array = []


static func init_meta(arr:Array)->GroupMemberList:
	var ins:GroupMemberList = GroupMemberList.new()
	ins.data_array = arr
	return ins


func get_metadata()->Array:
	return data_array


func set_metadata(arr:Array):
	data_array = arr


func get_from_index(index:int)->GroupMember:
	if (index >= 0) && (index < data_array.size()-1):
		var member_dic:Dictionary = data_array[index]
		var ins = GroupMember.init_meta(member_dic)
		return ins
	else:
		return null
		
		
func get_size()->int:
	return data_array.size()
