extends Control

@onready var tree_ctl        := TreeWrapper.new()

@onready var ui_camera       := $UICamera
@onready var title_ui_layer  := $TitleUILayer
@onready var background      := $TitleUILayer/Background
@onready var title           := $TitleUILayer/Title
@onready var btn_container   := $TitleUILayer/btn_container

@onready var anim_player     := $AnimationPlayer

@onready var btn_new_game    := $TitleUILayer/btn_container/NewGame
@onready var btn_settings    := $TitleUILayer/btn_container/Settings
@onready var btn_quit        := $TitleUILayer/btn_container/Quit

@onready var settings_dialog := $TitleUILayer/SettingsDialog

@onready var anim_state      := "intro"

var last_focused_button: Button

#############################################
#                 UTILITIES                 #
#############################################

func skip_animation():
	if anim_state == "intro":
		anim_player.seek(anim_player.current_animation_length, true)
	elif anim_state == "outro":
		anim_player.seek(0, true)

	_on_animation_player_animation_finished("fade_in")

func enable_disable_all_buttons(state: bool) -> void:
	for btn in btn_container.get_children():
		btn.disabled = state

func show_all():
	show()
	ui_camera.make_current()
	title_ui_layer.show()

func hide_all():
	hide()
	title_ui_layer.hide()

#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready() -> void:
	set_process_unhandled_input(true)
	add_child(tree_ctl)
	settings_dialog.close()
	enable_disable_all_buttons(true)
	anim_player.play("fade_in")

func _unhandled_input(event):
	if event.is_action_pressed("abort_operation"):
		if not settings_dialog.visible:
			skip_animation()

#############################################
#                 EVENTS                    #
#############################################

#############################################
#          NEW GAME BUTTON RELATED          #
#############################################

func _on_new_game_pressed() -> void:
	if UserData.get_value("debug") == 1:
		get_parent().test_map()

#############################################
#          LOAD GAME BUTTON RELATED         #
#############################################

func _on_load_game_pressed() -> void:
	pass # Replace with function body.

#############################################
#         SETTINGS BUTTON RELATED           #
#############################################

func _on_settings_pressed() -> void:
	settings_dialog.open()

#############################################
#           QUIT BUTTON RELATED             #
#############################################

func _on_quit_pressed() -> void:
	anim_state = "outro"
	anim_player.play_backwards("fade_in")
	enable_disable_all_buttons(true)
	await anim_player.animation_finished
	tree_ctl.quit_game()

#############################################
#         TITLE UI BUTTONS RELATED          #
#############################################

func _on_button_focus_entered() -> void:
	last_focused_button = get_viewport().gui_get_focus_owner()
	
#############################################
#        ANIMATION PLAYER RELATED           #
#############################################

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		if anim_state == "intro":
			enable_disable_all_buttons(false)
			btn_new_game.grab_focus()
		elif anim_state == "outro":
			tree_ctl.quit_game()

#############################################
#           DIALOG CLOSE RELATED            #
#############################################

# BUG: If the SettingsDialog is visible, then the settings_dialog variable is nil!!! 
# Otherwise it works correctly. I think it's an engine bug like the time-bug, 
# documented in settings_dialog.gd
func _on_dialog_visibility_changed() -> void:
	if not settings_dialog.visible:
		if last_focused_button:
			await get_tree().process_frame
			last_focused_button.grab_focus()
