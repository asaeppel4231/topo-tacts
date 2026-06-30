extends Control

@onready var color_rect    := $ColorRect
@onready var gui           := color_rect.get_node("GUI")

@onready var containers    = {
	"back_and_help"       :  gui.get_node("BackAndHelp")            ,
	"difficulty_chooser"  :  gui.get_node("DifficultyChooser")      ,
	"volume_sfx_control"  :  gui.get_node("AudioVolumeSFXControl")  ,
	"volume_music_control":  gui.get_node("AudioVolumeMusicControl"),
	"volume_total_control":  gui.get_node("AudioVolumeTotalControl"),
	"default_username"    :  gui.get_node("DefaultUsername")        ,
	"default_port"        :  gui.get_node("DefaultPort")
}

@onready var buttons       = {
	"back_and_help" : {
		"back"      :        containers.back_and_help.get_node("Back")         ,
		"help"      :        containers.back_and_help.get_node("Help")
	},
	"reset_settings":        gui.                     get_node("ResetSettings")
}

@onready var labels        = {
	"difficulty"           : gui.                            get_node("DifficultyLabel")         ,
	"difficulty_easy"      : containers.difficulty_chooser.  get_node("Easy")                    ,
	"diffculty_hard"       : containers.difficulty_chooser.  get_node("Hard")                    ,
	"volume_sfx"           : gui.                            get_node("AudioVolumeSFXLabel")     ,
	"volume_music"         : gui.                            get_node("AudioVolumeMusicLabel")   ,
	"volume_total"         : gui.                            get_node("AudioVolumeTotalLabel")   ,
	"volume_sfx_min"       : containers.volume_sfx_control.  get_node("Min")                     ,
	"volume_music_min"     : containers.volume_music_control.get_node("Min")                     ,
	"volume_total_min"     : containers.volume_total_control.get_node("Min")                     ,
	"volume_sfx_max"       : containers.volume_sfx_control.  get_node("Max")                     ,
	"volume_music_max"     : containers.volume_music_control.get_node("Max")                     ,
	"volume_total_max"     : containers.volume_total_control.get_node("Max")                     ,
	"multiplayer"          : gui.                            get_node("MultiplayerLabel")        ,
	"default_username"     : containers.default_username.    get_node("DefaultUsername")         ,
	"default_port"         : containers.default_port.        get_node("DefaultPort")             ,
	"settings_last_changed": gui.                            get_node("SettingsLastChangedLabel")
}

@onready var sliders       = {
	"difficulty"  :          containers.difficulty_chooser.  get_node("Slider"),
	"volume_sfx"  :          containers.volume_sfx_control.  get_node("Slider"),
	"volume_music":          containers.volume_music_control.get_node("Slider"),
	"volume_total":          containers.volume_total_control.get_node("Slider"),
}

@onready var dialogs       = {
	"confirm_reset":         get_node("ConfirmReset"),
	"help"         :         get_node("Help")
}

@onready var default_username_lne        := $ColorRect/GUI/DefaultUsername/Username # LNE = LineEdit
@onready var default_port_spb            := $ColorRect/GUI/DefaultPort/Port         # SPB = SpinBox

@onready var sounds := $Sounds

@onready var audio_stream_players = {
	"accept": sounds.get_node("Accept"),
	"cancel": sounds.get_node("Cancel")
}
