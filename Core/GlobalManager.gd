extends Node


const INIT_PATH = [
	"/plugin/",
	"/config/",
	"/data/",
]


func _init():
	init_dir()


func init_dir():
	var dir = Directory.new()
	for p in INIT_PATH:
		var path = OS.get_executable_path().get_base_dir() + p
		if !dir.dir_exists(path):
			dir.make_dir(path)
