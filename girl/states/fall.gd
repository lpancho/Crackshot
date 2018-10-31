extends "res://scripts/state.gd"

var jump_trans_timer = 0
var jump_margin_timer = 0

func initialize( obj ):
	if obj.is_jump:
		obj.anim_nxt = "jump_trans"
		jump_trans_timer = 0.24
		jump_margin_timer = 0
	else:
		obj.anim_nxt = "fall"
		jump_trans_timer = 0
		jump_margin_timer = obj.JUMP_MARGIN

func run( obj, delta ):
	if jump_trans_timer > 0:
		jump_trans_timer -= delta
		if jump_trans_timer <= 0:
			obj.anim_nxt = "fall"
		
	
	# gravity
	obj.vel.y = min( obj.vel.y + game.GRAVITY * delta, game.TERMINAL_VELOCITY )
	# move
	obj.vel = obj.move_and_slide( obj.vel )
	
	# player input
	var is_moving = false
	if Input.is_action_pressed( "btn_left" ):
		is_moving = true
		obj.vel.x = lerp( obj.vel.x, -obj.MAX_VEL_AIR, obj.ACCEL_AIR * delta )
	elif Input.is_action_pressed( "btn_right" ):
		is_moving = true
		obj.vel.x = lerp( obj.vel.x, obj.MAX_VEL_AIR, obj.ACCEL_AIR * delta )
	else:
		obj.vel.x = lerp( obj.vel.x, 0, obj.DECEL_AIR * delta )
		if abs( obj.vel.x ) < 1:
			obj.vel.x = 0
		else:
			is_moving = true
	if not obj.is_jump and not obj.double_jump and jump_margin_timer > 0:
		jump_margin_timer -= delta
		if Input.is_action_just_pressed( "btn_jump" ):
			obj.fsm.state_nxt = obj.fsm.STATES.jump
	if obj.is_jump and not obj.double_jump and \
			Input.is_action_just_pressed( "btn_jump" ):
		obj.fsm.state_nxt = obj.fsm.STATES.double_jump
	
	if obj.check_ground():
		obj.is_jump = false
		obj.double_jump = false
		obj.dust_land()
		if is_moving:
			obj.fsm.state_nxt = obj.fsm.STATES.run
		else:
			obj.fsm.state_nxt = obj.fsm.STATES.idle

