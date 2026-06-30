extends Node

var instance

func _ready() -> void:
	instance = ClassDB.instantiate("SaveGameManager")
	add_child(instance)

func create_save(slot := -1) -> int:
	return instance.create_save(slot)
	
func load_save(slot: int) -> bool:
	return instance.load_save(slot)
	
func extend_to_multiplayer() -> bool:
	return instance.extend_to_multiplayer()
	
func close_save() -> void:
	instance.close_save()

func get_current_slot() -> int:
	return instance.get_current_slot()

func get_current_mode() -> int:
	return instance.get_current_mode()

func read_metadata() -> Dictionary:
	return instance.read_metadata()

func write_metadata(dict: Dictionary) -> bool:
	return instance.write_metadata(dict)

func shutdown() -> void:
	instance.shutdown()
