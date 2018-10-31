extends "res://scripts/state.gd"


func initialize( obj ):
	obj.anim_nxt = "run"

func run( obj, delta ):
	if ( obj.vel.x > 0 and obj.rotate.scale.x > 0 ) or \
		( obj.vel.x < 0 and obj.rotate.scale.x < 0 ):
		obj.anim_nxt = "run"
	elif ( obj.vel.x > 0 and obj.rotate.scale.x < 0 ) or \
		( obj.vel.x < 0 and obj.rotate.scale.x > 0 ):
		obj.anim_nxt = "run_back"
	
	
	# gravity
	obj.vel.y = min( obj.vel.y + game.GRAVITY * delta, game.TERMINAL_VELOCITY )
	# move
	obj.vel = obj.move_and_slide( obj.vel )
	
	# player input
	var is_moving = false
	if Input.is_action_pressed( "btn_left" ):
		is_moving = true
		obj.vel.x = lerp( obj.vel.x, -obj.MAX_VEL, obj.ACCEL * delta )
	elif Input.is_action_pressed( "btn_right" ):
		is_moving = true
		obj.vel.x = lerp( obj.vel.x, obj.MAX_VEL, obj.ACCEL * delta )
	else:
		obj.vel.x = lerp( obj.vel.x, 0, obj.DECEL * delta )
		if abs( obj.vel.x ) < 1:
			obj.vel.x = 0
		else:
			is_moving = true
	if not is_moving:
		obj.fsm.state_nxt = obj.fsm.STATES.idle
	
	if obj.check_ground():
		if Input.is_action_just_pressed( "btn_jump" ):
			obj.fsm.state_nxt = obj.fsm.STATES.jump
	else:
		obj.fsm.state_nxt = obj.fsm.STATES.fall
