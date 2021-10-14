extends SingleMessage


class_name PokeMessage


func _init():
	data = {
		Interface.poke_message_data.PokeType:null
	}

func set_poke_type(type:int) -> void:
	data[Interface.poke_message_data.PokeType] = type

func get_poke_type() -> String:
	return data[Interface.poke_message_data.PokeType]
