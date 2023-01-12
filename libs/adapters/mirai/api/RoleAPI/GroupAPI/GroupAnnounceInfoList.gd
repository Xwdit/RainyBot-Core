extends GroupAPI


class_name GroupAnnounceInfoList


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


func _iter_get(_arg)->GroupAnnounceInfo:
	return get_from_index(iter_current)


static func init_meta(arr:Array)->GroupAnnounceInfoList:
	if arr.is_empty():
		return null
	var ins:GroupAnnounceInfoList = GroupAnnounceInfoList.new()
	ins.data_array = arr
	return ins


func get_metadata()->Array:
	return data_array


func set_metadata(arr:Array)->void:
	if arr.is_empty():
		return
	data_array = arr


func get_from_index(index:int)->GroupAnnounceInfo:
	if (index >= 0) && (index <= data_array.size()-1):
		var _dic:Dictionary = data_array[index]
		var ins:GroupAnnounceInfo = GroupAnnounceInfo.init_meta(_dic)
		return ins
	else:
		return null
		

func get_from_id(announce_id:int)->GroupAnnounceInfo:
	for _announce in data_array:
		if _announce.fid == announce_id:
			return GroupAnnounceInfo.init_meta(_announce)
	return null


func has_announce(announce_id:int)->bool:
	for _announce in data_array:
		if _announce.fid == announce_id:
			return true
	return false


func get_size()->int:
	return data_array.size()
