extends SingleMessage


class_name PokeMessage


func _init():
	data = {
		"poke_type":null
	}

func set_poke_type(type:int) -> void:
	data.poke_type = type

func get_poke_type() -> String:
	return data.poke_type
