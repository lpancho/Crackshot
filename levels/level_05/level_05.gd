extends "res://levels/level.gd"

func _ready():
	game.gamestate.cur_level = ""
func _on_finish( body ):
	emit_signal( "finished_level", "res://levels/start_menu/start_menu.tscn" )