extends "res://scripts/TitleUI/utils.gd"

###########################################################
#                   SPECIAL FUNCTIONS                     #
###########################################################

func _ready() -> void:
	set_process_unhandled_input(true)
	lookup_settings_dialog().close()             # fix, see last function of this file
	enable_disable_all_buttons(true)
	anim_player.play("fade_in")

func _unhandled_input(event):
	if event.is_action_pressed("abort_operation"):
		if not lookup_settings_dialog().visible: # fix, see last function of this file
			skip_animation()

###########################################################
#                         EVENTS                          #
###########################################################

###########################################################
#                NEW GAME BUTTON RELATED                  #
###########################################################

func _on_new_game_pressed() -> void:
	if UserData.get_value("debug") == 1:
		get_parent().test_map()

###########################################################
#                LOAD GAME BUTTON RELATED                 #
###########################################################

func _on_load_game_pressed() -> void:
	pass

###########################################################
#                SETTINGS BUTTON RELATED                  #
###########################################################

func _on_settings_pressed() -> void:
	lookup_settings_dialog().open() # fix, see last function of this file

###########################################################
#                  QUIT BUTTON RELATED                    #
###########################################################

func _on_quit_pressed() -> void:
	anim_state = "outro"
	anim_player.play_backwards("fade_in")
	enable_disable_all_buttons(true)
	await anim_player.animation_finished
	get_tree().current_scene.tree_ctl.quit_game()

###########################################################
#                    BUTTONS RELATED                      #
###########################################################

func _on_button_focus_entered() -> void:
	set_last_focused_button()
	
###########################################################
#                ANIMATION PLAYER RELATED                 #
###########################################################

func _on_animation_player_animation_finished(anim_name: String) -> void:
	handle_animation_player_finished(anim_name)

###########################################################
#                  DIALOG CLOSE RELATED                   #
###########################################################

# BUG: If the SettingsDialog is visible, then the settings_dialog variable is nil!!! 
# Otherwise it works correctly. I think it's an engine bug like the time-bug, 
# documented in the TimeHelper class.
# FIX: (quick and dirty): Use each time the get_node() Node asking way instead of the variable
func _on_dialog_visibility_changed() -> void:
	if not lookup_settings_dialog().visible:
		restore_last_focused_button_focus()
