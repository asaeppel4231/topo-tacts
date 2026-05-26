extends Node
class_name UserDataManager

var config_dir: String
var config_file: String
var data: Dictionary = {}

const CONFIG_FILENAME = "config.json"

func setup() -> void:
	var home_dir := OS.get_user_data_dir()
	config_dir = home_dir
	config_file = config_dir + "/" + CONFIG_FILENAME

func load_config() -> void:
	DirAccess.make_dir_recursive_absolute(config_dir)

	if FileAccess.file_exists(config_file):
		var file := FileAccess.open(config_file, FileAccess.READ)
		if file == null:
			push_error("Could not open config file for reading, resetting.")
			data = {}
			save_config()
			return

		var parsed = JSON.parse_string(file.get_as_text())
		if typeof(parsed) == TYPE_DICTIONARY:
			data = parsed
		else:
			push_error("Config file corrupted, resetting.")
			data = {}
			save_config()
	else:
		print("Config file missing, creating new one.")
		data = {}
		save_config()

func save_config() -> void:
	DirAccess.make_dir_recursive_absolute(config_dir)
	var file := FileAccess.open(config_file, FileAccess.WRITE)
	if file == null:
		push_error("Could not open config file for writing!")
		return

	# Sort alphabetically
	var sorted_keys := data.keys()
	sorted_keys.sort()

	var sorted_data := {}
	for key in sorted_keys:
		sorted_data[key] = data[key]

	var json_text := JSON.stringify(sorted_data, "\t")
	file.store_string(json_text)

func set_value(key: String, value) -> void:
	data[key] = value
	save_config()

func get_value(key: String, default = null) -> Variant:
	return data.get(key, default)

func reset() -> void:
	DirAccess.remove_absolute(config_file)
	data = {}
	set_value("settings-last-changed", Time.get_unix_time_from_system())
