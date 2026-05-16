extends Control


@onready var color_rect    := $ColorRect
@onready var btn_container := $ColorRect/btn_container
@onready var back_and_help := $ColorRect/btn_container/BackAndHelp

@onready var btn_back      := $ColorRect/btn_container/BackAndHelp/Back
@onready var btn_help      := $ColorRect/btn_container/BackAndHelp/Help

@onready var difficulty_text       := $ColorRect/btn_container/DifficultyText
@onready var difficulty_easy_label := $ColorRect/btn_container/DifficultyChooser/DifficultyEasy
@onready var difficulty_hard_label := $ColorRect/btn_container/DifficultyChooser/DifficultyHard

@onready var volume_sfx_label   := $ColorRect/btn_container/AudioVolumeSFXLabel
@onready var volume_music_label := $ColorRect/btn_container/AudioVolumeMusicLabel
@onready var volume_total_label := $ColorRect/btn_container/AudioVolumeTotalLabel


@onready var difficulty_chooser := $ColorRect/btn_container/DifficultyChooser

@onready var volume_sfx_control   := $ColorRect/btn_container/AudioVolumeSFXControl
@onready var volume_music_control := $ColorRect/btn_container/AudioVolumeMusicControl
@onready var volume_total_control := $ColorRect/btn_container/AudioVolumeTotalControl

@onready var volume_sfx_min_label   := $ColorRect/btn_container/AudioVolumeSFXControl/LabelMin
@onready var volume_music_min_label := $ColorRect/btn_container/AudioVolumeMusicControl/LabelMin
@onready var volume_total_min_label := $ColorRect/btn_container/AudioVolumeTotalControl/LabelMin

@onready var difficulty_slider   := $ColorRect/btn_container/DifficultyChooser/DifficultySlider

@onready var volume_sfx_slider   := $ColorRect/btn_container/AudioVolumeSFXControl/Slider
@onready var volume_music_slider := $ColorRect/btn_container/AudioVolumeMusicControl/Slider
@onready var volume_total_slider := $ColorRect/btn_container/AudioVolumeTotalControl/Slider

@onready var volume_sfx_max_label   := $ColorRect/btn_container/AudioVolumeSFXControl/LabelMax
@onready var volume_music_max_label := $ColorRect/btn_container/AudioVolumeMusicControl/LabelMax
@onready var volume_total_max_label := $ColorRect/btn_container/AudioVolumeTotalControl/LabelMax

@onready var multiplayer_label           := $ColorRect/btn_container/MultiplayerLabel

@onready var default_username_container  := $ColorRect/btn_container/DefaultUsername
@onready var default_port_container      := $ColorRect/btn_container/DefaultPort

@onready var default_username_label      := $ColorRect/btn_container/DefaultUsername/LabelDefaultUsername
@onready var default_port_label          := $ColorRect/btn_container/DefaultPort/LabelDefaultPort

@onready var default_username_lne        := $ColorRect/btn_container/DefaultUsername/LnEDefaultUsername # LNE = LineEdit
@onready var default_port_spb            := $ColorRect/btn_container/DefaultPort/SpbDefaultPort # SPB = SpinBox

@onready var settings_last_changed_label := $ColorRect/btn_container/LabelLastSettingsChange

@onready var btn_reset                   := $ColorRect/btn_container/ResetSettings

@onready var dialog_confirm_reset        := $ConfirmReset
@onready var dialog_help                 := $HelpDialog

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
	volume_sfx_slider.value   = UserData.get_value("volume-sfx", 0.5)   * 100
	volume_music_slider.value = UserData.get_value("volume-music", 0.5) * 100
	volume_total_slider.value = UserData.get_value("volume", 0.5)       * 100

func init_multiplayer_inputs():
	default_username_lne.text = UserData.get_value("default-username", "")
	default_port_spb.value    = float(UserData.get_value("default-port", 1024.0))

func get_local_datetime_from_unix(ts: int) -> Dictionary:
	# workaround because on my godot 4.7 Time.get_datetime_dict_from_unix_time returns UTC time, but
	# my time zone is actually UTC + 2 (Europe/Berlin).
	# I think this is a bug, because Time.get_datetime_dict_from_system() returns local time.
	return Time.get_datetime_dict_from_unix_time(ts + Time.get_time_zone_from_system().bias * 60)

func update_settings_last_changed_label():
	var ts = UserData.get_value("settings-last-changed")
	if ts == null:
		settings_last_changed_label.hide()
		return
	settings_last_changed_label.show()
	var dt = get_local_datetime_from_unix(ts)
	var formatted = "%02d.%02d.%04d %02d:%02d" % [
		dt.day, dt.month, dt.year, dt.hour, dt.minute
	]

	settings_last_changed_label.text = tr("Settings last changed at %s") % formatted
	
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
	if difficulty_slider.value == 0:
		unhandled_key_input_slider_updating_label(difficulty_state, "difficulty", difficulty_text,
		tr("Difficulty: Easy"), Color(0.35, 0.75, 0.45))
	elif difficulty_slider.value == 1:
		unhandled_key_input_slider_updating_label(difficulty_state, "difficulty", difficulty_text,
		tr("Difficulty: Normal"), Color(0.5, 0.5, 0.5))
	elif difficulty_slider.value == 2:
		unhandled_key_input_slider_updating_label(difficulty_state, "difficulty", difficulty_text,
		tr("Difficulty: Hard"), Color(0.85, 0.35, 0.35))

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
	btn_back.grab_focus()

func close():
	visible = false
	dialog_confirm_reset.hide()
	dialog_help.hide()
