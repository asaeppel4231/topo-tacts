extends Control

@onready var ui_camera        := $UICamera
@onready var title_ui_layer   := $TitleUILayer
@onready var background_image := title_ui_layer.get_node("Background")
@onready var title_image      := title_ui_layer.get_node("Title")

@onready var anim_player     := $AnimationPlayer

@onready var gui             := title_ui_layer.get_node("GUI")

@onready var buttons         = {
	"new_game" :             gui.get_node("NewGame"),
	"load_game":             gui.get_node("LoadGame"),
	"settings" :             gui.get_node("Settings"),
	"quit"     :             gui.get_node("Quit")
}
