extends "res://scripts/state.gd"

var dir_timer
var state_timer

func initialize( obj ):
	obj.anim_nxt = "run"
	dir_timer = 0.1
	state_timer = obj.STATE_TIME

func run( obj, delta ):
	obj.vel.x = obj.MAX_VEL * obj.dir_cur
	
	# gravity
	obj.vel.y = min( obj.vel.y + game.GRAVITY * delta, game.TERMINAL_VELOCITY )
	# move
	obj.vel = obj.move_and_slide( obj.vel )
	
	# check limits
	if obj.reached_limit():
		obj.dir_nxt = -obj.dir_cur
	
	# timer
	if state_timer > 0:
		state_timer -= delta
		if state_timer <= 0:
			obj.fsm.state_nxt = obj.fsm.STATES.robot_idle
