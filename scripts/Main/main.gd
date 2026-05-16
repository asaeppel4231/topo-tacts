extends Node2D

#############################################
#            SPECIAL FUNCTIONS              #
#############################################

func _ready() -> void:
	UserData.setup()
	UserData.load_config()
	
	var locale := OS.get_locale().substr(0, 2)
	TranslationServer.set_locale(locale)

	if UserData.get_value("debug") == 1:
		print("Using locale: ", locale)

func _process(_delta: float) -> void: # delta is unused
	pass
