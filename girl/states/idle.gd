extends "res://scripts/state.gd"


func initialize( obj ):
	obj.anim_nxt = "idle"

func run( obj, delta ):
	# gravity
	obj.vel.y = min( obj.vel.y + game.GRAVITY * delta, game.TERMINAL_VELOCITY )
	# slow down horizontally
	obj.vel.x *= 0.5
	# move
	obj.vel = obj.move_and_slide( obj.vel )
	
	# player input
	if Input.is_action_pressed( "btn_left" ) or Input.is_action_pressed( "btn_right" ):
		obj.fsm.state_nxt = obj.fsm.STATES.run
	
	if obj.check_ground():
		if Input.is_action_just_pressed( "btn_jump" ) and not obj.is_jump:
			obj.fsm.state_nxt = obj.fsm.STATES.jump
	else:
		obj.fsm.state_nxt = obj.fsm.STATES.fall
	
	
	