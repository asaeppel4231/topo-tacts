extends "res://scripts/SettingsDialog/prepared_vars.gd"

var difficulty_state = {
	"changing": false,
	"last_value": 0.0
}

var volume_sfx_state = {
	"changing": false,
	"last_value": 0.0
}

var volume_music_state = {
	"changing": false,
	"last_value": 0.0
}

var volume_total_state = {
	"changing": false,
	"last_value": 0.0
}

#############################################
#                 UTILITIES                 #
#############################################

func init_sliders():
	sliders.volume_sfx.  value = UserData.get_value("volume-sfx", 0.5)   * 100
	sliders.volume_music.value = UserData.get_value("volume-music", 0.5) * 100
	sliders.volume_total.value = UserData.get_value("volume", 0.5)       * 100

func init_multiplayer_inputs():
	default_username_lne.text = UserData.get_value("default-username", "")
	default_port_spb.value    = float(UserData.get_value("default-port", 1024.0))

func update_settings_last_changed_label():
	var ts = UserData.get_value("settings-last-changed", null)
	if ts == null:
		labels.settings_last_changed.hide()
		return
	labels.settings_last_changed.show()
	var dt = get_tree().current_scene.time_helper.get_local_datetime_from_unix(ts)
	var formatted = "%02d.%02d.%04d %02d:%02d" % [
		dt.day, dt.month, dt.year, dt.hour, dt.minute
	]

	labels.settings_last_changed.text = tr("Settings last changed at %s") % formatted
	
func update_settings_set_timestamp():
	UserData.set_value("settings-last-changed", Time.get_unix_time_from_system())
	update_settings_last_changed_label()

func left_or_right_pressed():
	return Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")

func left_or_right_released(event):
	return event.is_action_released("ui_left") or event.is_action_released("ui_right")

func _on_slider_value_changed_base(state: Dictionary, value: float):
	if left_or_right_pressed():
		state.changing = true
	state.last_value = value

# Handles the save of the current value of a slider if the mouse keys (drag_ended) or the 
# keyboard keys (own logic, refer to _unhandled_input) were released

func handle_changed_slider_value_on_released_input(slider_name: String, new_value: float, is_in_procent := true):
	if is_in_procent:
		UserData.set_value(slider_name, float(new_value) / 100.0)
	else:
		UserData.set_value(slider_name, float(new_value))
	update_settings_set_timestamp()

func unhandled_key_input_slider_state_save_base(state: Dictionary, slider_name: String):
	if state.changing:
		state.changing = false
		handle_changed_slider_value_on_released_input(slider_name, state.last_value)

# special for my difficulty slider :.)

func unhandled_key_input_slider_updating_label(state: Dictionary, slider_name: String, 
	label: Label, new_label_text: String, new_color: Color):
	unhandled_key_input_slider_state_save_base(state, slider_name)
	label.text = new_label_text
	label.add_theme_color_override("font_color", new_color)

func update_difficulty_text_label():
	if   sliders.difficulty.value == 0:
		unhandled_key_input_slider_updating_label(difficulty_state, "difficulty", labels.difficulty,
		tr("Difficulty: Easy"),   Color(0.35, 0.75, 0.45))
	elif sliders.difficulty.value == 1:
		unhandled_key_input_slider_updating_label(difficulty_state, "difficulty", labels.difficulty,
		tr("Difficulty: Normal"), Color(0.5, 0.5, 0.5))
	elif sliders.difficulty.value == 2:
		unhandled_key_input_slider_updating_label(difficulty_state, "difficulty", labels.difficulty,
		tr("Difficulty: Hard"),   Color(0.85, 0.35, 0.35))

func update_audio_server_bus_db(bus_idx: int, value: float):
	var linear = value / 100.0
	var db = linear_to_db(linear)
	AudioServer.set_bus_volume_db(bus_idx, db)

func open():
	update_settings_last_changed_label()
	update_difficulty_text_label()
	init_sliders()
	init_multiplayer_inputs()
	visible = true
	buttons.back_and_help.back.grab_focus()

func close():
	visible = false
	dialogs.confirm_reset.hide()
	dialogs.help.         hide()
