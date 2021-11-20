extends Message


class_name PokeMessage


enum PokeType {
	POKE,
	SHOW_LOVE,
	LIKE,
	HEART_BROKEN,
	SIX_SIX_SIX,
	FANG_DA_ZHAO
}


const type_dic:Dictionary = {
	PokeType.POKE:"Poke",
	PokeType.SHOW_LOVE:"ShowLove",
	PokeType.LIKE:"Like",
	PokeType.HEART_BROKEN:"Heartbroken",
	PokeType.SIX_SIX_SIX:"SixSixSix",
	PokeType.FANG_DA_ZHAO:"FangDaZhao"
}


const type_dic_reverse:Dictionary = {
	"Poke":PokeType.POKE,
	"ShowLove":PokeType.SHOW_LOVE,
	"Like":PokeType.SHOW_LOVE,
	"Heartbroken":PokeType.SHOW_LOVE,
	"SixSixSix":PokeType.SIX_SIX_SIX,
	"FangDaZhao":PokeType.FANG_DA_ZHAO
}


var data_dic:Dictionary = {
	"type": "Poke",
	"name": ""
}


static func init(type:int)->PokeMessage:
	var ins:PokeMessage = PokeMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.name = type_dic[type]
	return ins


static func init_meta(dic:Dictionary)->PokeMessage:
	var ins:PokeMessage = PokeMessage.new()
	ins.data_dic = dic
	return ins

	
func get_poke_type()->int:
	return type_dic_reverse[data_dic.name]
	
	
func set_poke_type(type:int):
	data_dic.name = type_dic[type]
	
	
func get_as_text()->String:
	return "[戳一戳:"+data_dic.name+"]"
