extends Message


class_name PokeMessage


enum Type {
	POKE,
	SHOW_LOVE,
	LIKE,
	HEART_BROKEN,
	SIX_SIX_SIX,
	FANG_DA_ZHAO
}


var type_dic:Dictionary = {
	Type.POKE:"Poke",
	Type.SHOW_LOVE:"ShowLove",
	Type.LIKE:"Like",
	Type.HEART_BROKEN:"Heartbroken",
	Type.SIX_SIX_SIX:"SixSixSix",
	Type.FANG_DA_ZHAO:"FangDaZhao"
}


var type_dic_reverse:Dictionary = {
	"Poke":Type.POKE,
	"ShowLove":Type.SHOW_LOVE,
	"Like":Type.SHOW_LOVE,
	"Heartbroken":Type.SHOW_LOVE,
	"SixSixSix":Type.SIX_SIX_SIX,
	"FangDaZhao":Type.FANG_DA_ZHAO
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
