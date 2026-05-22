extends "res://scripts/TitleUI/prepared_vars.gd"

@onready var anim_state      := "intro"

var last_focused_button: Button

#############################################
#                 UTILITIES                 #
#############################################

func handle_animation_player_finished(anim_name: String):
	if anim_name == "fade_in":
		if anim_state == "intro":
			enable_disable_all_buttons(false)
			buttons.new_game.grab_focus()
		elif anim_state == "outro":
			get_tree().current_scene.tree_ctl.quit_game()

func skip_animation():
	if anim_state == "intro":
		anim_player.seek(anim_player.current_animation_length, true)
	elif anim_state == "outro":
		anim_player.seek(0, true)
	handle_animation_player_finished("fade_in")

func enable_disable_all_buttons(state: bool) -> void:
	for btn in gui.get_children():
		btn.disabled = state

func show_all():
	ui_camera.make_current()
	show()
	title_ui_layer.show()

func hide_all():
	hide()
	title_ui_layer.hide()

func lookup_settings_dialog():
	return get_node("TitleUILayer").get_node("SettingsDialog")

func set_last_focused_button():
	last_focused_button = get_viewport().gui_get_focus_owner()

func restore_last_focused_button_focus():
	if last_focused_button:
		await get_tree().process_frame
		last_focused_button.grab_focus()
