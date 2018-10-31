extends "res://scripts/state.gd"

var timer

func initialize( obj ):
	obj.can_aim = false
	timer = 2
	obj.anim_nxt = "hit"
	game.camera_shake( 1.0, 60, 4 )

func run( obj, delta ):
	if timer > 0:
		timer -= delta
		if timer <= 0:
			obj.emit_signal( "player_dead" )
