extends Node2D

@onready var time_helper := TimeHelper.new()
@onready var tree_ctl    := TreeWrapper.new()

@onready var title_ui := $TitleUI
@onready var triax    := $Triax

@onready var static_body_2d := $StaticBody2D

@onready var enemy_example := $EnemyExample

#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready() -> void:
	add_child(tree_ctl)
	UserData.setup()
	UserData.load_config()
	
	var locale := OS.get_locale().substr(0, 2)
	TranslationServer.set_locale(locale)

	if UserData.get_value("debug") == 1:
		print("Using locale: ", locale)
	
	title_ui.show_all()
#	var i := 0
#	var j := 10
# RESULT: Works as expected
#	while i < j: # First test
#		print(SaveGameManagerAutoload.create_save())
#		i += 1
#	print(SaveGameManagerAutoload.create_save(0))
#	SaveGameManagerAutoload.close_save()
#	print(SaveGameManagerAutoload.create_save())

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		SaveGameManagerAutoload.shutdown()
		tree_ctl.quit_game()

func _process(_delta: float) -> void: # delta is unused
	if Input.is_action_just_pressed("reload (DEBUG)"):
		tree_ctl.restart_game()

func test_map() -> void:
	triax.player.make_pcam_current()
	title_ui.hide_all()
	triax.show()
	triax.is_paused = false
	static_body_2d.show()
	enemy_example.show()
