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

func _process(_delta: float) -> void: # delta is unused
	if Input.is_action_just_pressed("reload (DEBUG)"):
		title_ui.tree_ctl.restart_game()

func test_map():
	triax.player.make_pcam_current()
	title_ui.hide_all()
	triax.show()
	triax.is_paused = false
	static_body_2d.show()
	enemy_example.show()
