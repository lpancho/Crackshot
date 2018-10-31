extends "res://scripts/state.gd"

var state_timer

func initialize( obj ):
	obj.anim_nxt = "idle"
	state_timer = 2#obj.STATE_TIME

func run( obj, delta ):
	# slow down horizontally
	obj.vel.x *= 0.9
	# check limits
	if obj.reached_limit():
		obj.vel.x *= 0
	# move
	obj.vel = obj.move_and_slide( obj.vel )
	
	
	# timer
	if state_timer > 0:
		state_timer -= delta
		if state_timer <= 0:
			obj.fsm.state_nxt = obj.fsm.STATES.robot_run

