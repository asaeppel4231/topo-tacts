extends "res://scripts/SettingsDialog/settings_dialog_utils.gd"

#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready() -> void:
	set_process_unhandled_input(true)
	close()

func _unhandled_input(event):
	if visible:
		if left_or_right_released(event):
			update_difficulty_text_label()
			unhandled_key_input_slider_state_save_base(volume_sfx_state, "volume-sfx")
			unhandled_key_input_slider_state_save_base(volume_music_state, "volume-music")
			unhandled_key_input_slider_state_save_base(volume_total_state, "volume")
		if event.is_action_pressed("focus_1"):
			difficulty_slider.grab_focus()
		elif event.is_action_pressed("focus_2"):
			volume_sfx_slider.grab_focus()
		elif event.is_action_pressed("focus_3"):
			volume_music_slider.grab_focus()
		elif event.is_action_pressed("focus_4"):
			volume_total_slider.grab_focus()

func _process(_delta: float) -> void: # delta is unused here
	pass

#############################################
#                 EVENTS                    #
#############################################

func _on_back_pressed() -> void:
	close()

func _on_help_pressed() -> void:
	dialog_help.popup_centered()

func _on_reset_settings_pressed() -> void:
	dialog_confirm_reset.popup_centered()

func _on_confirm_reset_confirmed() -> void:
	UserData.reset()
	init_sliders()
	update_settings_last_changed_label()
	difficulty_slider.value = 1 # 1 = NORMAL
	update_difficulty_text_label()
	init_multiplayer_inputs()

func _on_confirm_reset_canceled() -> void:
	pass

func _on_difficulty_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		handle_changed_slider_value_on_released_input("difficulty", difficulty_slider.value, false)
		update_difficulty_text_label()

func _on_volume_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		handle_changed_slider_value_on_released_input("volume-sfx", volume_sfx_slider.value)

func _on_volume_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		handle_changed_slider_value_on_released_input("volume-music", volume_music_slider.value)

func _on_volume_total_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		handle_changed_slider_value_on_released_input("volume", volume_total_slider.value)

func _on_difficulty_slider_value_changed(value: float) -> void:
	_on_slider_value_changed_base(difficulty_state, value)

func _on_volume_sfx_slider_value_changed(value: float) -> void:
	update_audio_server_bus_db(AudioServer.get_bus_index("SFX"), value)
	_on_slider_value_changed_base(volume_sfx_state, value)

func _on_volume_music_slider_value_changed(value: float) -> void:
	update_audio_server_bus_db(AudioServer.get_bus_index("Music"), value)
	_on_slider_value_changed_base(volume_music_state, value)

func _on_volume_total_slider_value_changed(value: float) -> void:
	update_audio_server_bus_db(AudioServer.get_bus_index("Master"), value)
	_on_slider_value_changed_base(volume_total_state, value)



func _on_lne_default_username_text_changed(new_text: String) -> void:
	UserData.set_value("default-username", new_text)
	update_settings_set_timestamp()

func _on_spb_default_port_value_changed(value: float) -> void:
	UserData.set_value("default-port", int(value))
	update_settings_set_timestamp()


func _on_help_dialog_close_requested() -> void:
	dialog_help.hide()
