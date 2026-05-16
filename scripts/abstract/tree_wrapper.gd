extends Node
class_name TreeWrapper

@onready var tree = get_tree()

func quit_game() -> void:
	tree.quit()

func restart_game() -> void:
	tree.reload_current_scene()
