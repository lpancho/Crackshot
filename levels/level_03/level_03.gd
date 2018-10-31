extends "res://levels/level.gd"

func _ready():
	game.gamestate.cur_level = "res://levels/level_03/level_03.tscn"
func _on_finish( body ):
	emit_signal( "finished_level", "res://levels/level_04/level_04.tscn" )