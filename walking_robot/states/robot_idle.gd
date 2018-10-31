extends "res://scripts/state.gd"

var state_timer

func initialize( obj ):
	obj.anim_nxt = "idle"
	state_timer = 1#obj.STATE_TIME

func run( obj, delta ):
	# gravity
	obj.vel.y = min( obj.vel.y + game.GRAVITY * delta, game.TERMINAL_VELOCITY )
	# slow down horizontally
	obj.vel.x *= 0.5
	# move
	obj.vel = obj.move_and_slide( obj.vel )
	
	
	
	# timer
	if state_timer > 0:
		state_timer -= delta
		if state_timer <= 0:
			obj.fsm.state_nxt = obj.fsm.STATES.robot_run

