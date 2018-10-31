extends "res://levels/level.gd"

var nxt_level = "res://levels/level_01/level_01.tscn"

func _ready():
	if game.gamestate.cur_level.empty():
		$menu.unselectable_items.append( 1 )
	#game.play_music( 2 )



func _on_menu_selected_item( itemno ):
	match itemno:
		0:
			game.set_initial_gamestate()
			emit_signal( "finished_level", nxt_level )
		1:
			emit_signal( "finished_level", game.gamestate.cur_level )
		2:
			emit_signal( "game_over" )

func _input(evt):
	if evt is InputEventJoypadButton:
		game.control_type = game.CONTROL_GAMEPAD
	elif evt is InputEventMouseButton:
		game.control_type = game.CONTROL_MOUSE
	