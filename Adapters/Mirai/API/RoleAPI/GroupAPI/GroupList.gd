extends GroupAPI


class_name GroupList


var data_array:Array = []


static func init_meta(arr:Array)->GroupList:
	var ins:GroupList = GroupList.new()
	ins.data_array = arr
	return ins


func get_metadata()->Array:
	return data_array


func set_metadata(arr:Array):
	data_array = arr


func get_from_index(index:int)->Group:
	if (index >= 0) && (index < data_array.size()-1):
		var member_dic:Dictionary = data_array[index]
		var ins = Group.init_meta(member_dic)
		return ins
	else:
		return null


func get_from_id(group_id:int)->Group:
	for _group in data_array:
		if _group.id == group_id:
			return Group.init_meta(_group)
	return null

		
func get_size()->int:
	return data_array.size()


func has_group(group_id:int)->bool:
	for _group in data_array:
		if _group.id == group_id:
			return true
	return false
