extends Message


class_name DiceMessage


var data_dic:Dictionary = {
	"type": "Dice",
	"value": 1
}


static func init(value:int)->DiceMessage:
	var ins:DiceMessage = DiceMessage.new()
	var dic:Dictionary = ins.data_dic
	dic.value = value
	return ins


static func init_meta(dic:Dictionary)->DiceMessage:
	var ins:DiceMessage = DiceMessage.new()
	ins.data_dic = dic
	return ins

	
func get_dice_value()->int:
	return data_dic.value
	
	
func set_dice_value(value:int):
	data_dic.value = value


func get_as_text()->String:
	return "[骰子:"+str(get_dice_value())+"]"
