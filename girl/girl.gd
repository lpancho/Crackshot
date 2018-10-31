extends KinematicBody2D

signal player_dead


const MAX_VEL_AIR = 100
const ACCEL_AIR = 5
const DECEL_AIR = 5
const MAX_VEL = 120
const ACCEL = 15
const DECEL = 25
const JUMP_VEL = 300
const JUMP_GRAVITY = 700
const JUMP_MAXTIME = 0.25
const JUMP_MARGIN = 0.1
const AIM_VEL = 10#5
const FIRE_WAITTIME = 0.25

var invulnerable = false#true# 

var fsm = null

var vel = Vector2()
var vel_platform = Vector2()
var dir_cur = 1
var is_jump = false
var double_jump = false
var anim_cur = ""
var anim_nxt = ""

var can_aim = true
var arm_dir_nxt = Vector2( 1, 0 )
var arm_dir_cur = Vector2( 1, 0 )


var is_cutscene = false

enum FIRE_STATES { FIRE, WAIT }
var is_fire = false
var fire_timer = 0
var fire_state

var interact_area = null

var is_hit = false

var camera_mode = 0


onready var rotate = $rotate
onready var arm = $big_gun

func _ready():
	# register with game
	game.player = self
	# Initialize states machine
	fsm = preload( "res://scripts/fsm.gd" ).new( self, $states, $states/idle, false )

func set_cutscene():
	is_cutscene = true
func reset_cutscene():
	is_cutscene = false

func _physics_process( delta ):
	if is_cutscene:
		pass
	else:
		# update states machine
		fsm.run_machine( delta )
		# update weapon dir
		_aim_weapon( delta )
		# fire
		_fire( delta )
		# direction
		if vel.x > 0:
			dir_cur = 1
		elif vel.x < 0:
			dir_cur = -1
		# update animations
		if anim_nxt != anim_cur:
			anim_cur = anim_nxt
			$anim.play( anim_cur )
		# interact
		_interact( delta )
		# platform
		_platform( delta )


#func _process(delta):
#	_aim_weapon( delta )


func check_ground():
	if $down_left.is_colliding() or $down_right.is_colliding():
		return true
	return false


var mouse_dir = Vector2()
func _aim_weapon( delta ):
	if can_aim:
		if game.control_type == game.CONTROL_MOUSE:
			mouse_dir = get_global_mouse_position() - arm.global_position
		else:
			var gamepad_dir = Vector2( Input.get_joy_axis(0, JOY_ANALOG_RX), \
					Input.get_joy_axis(0, JOY_ANALOG_RY) )
			if gamepad_dir.length_squared() > 0.1:
				mouse_dir = Vector2( Input.get_joy_axis(0, JOY_ANALOG_RX), \
					Input.get_joy_axis(0, JOY_ANALOG_RY) ).normalized() * 200
			else:
				pass
	else:
		mouse_dir = Vector2( rotate.scale.x, 0 )
	
	arm_dir_nxt = mouse_dir.normalized()
	arm_dir_cur = arm_dir_cur.linear_interpolate( arm_dir_nxt, AIM_VEL * delta )
	arm.rotation = arm_dir_cur.angle()
	if arm_dir_cur.x < 0:
		rotate.scale.x = -1
		arm.scale.y = -1
	else:
		rotate.scale.x = 1
		arm.scale.y = 1
	
	# set camera target
	if camera_mode == 0:
		#$camera_target.position = ( mouse_dir * 0.5 ).round()#( mouse_dir * 0.3 ).round()
		$camera_target.position = $camera_target.position.linear_interpolate( \
			( mouse_dir * Vector2( 0.35, 0.5 ) ).round(), 5 * delta )
	else:
		$camera_target.position = $camera_target.position.linear_interpolate( \
				Vector2( 180, mouse_dir.y * 0.5 ), 1 * delta )


func _fire( delta ):
	if not is_fire and \
			Input.is_action_just_pressed( "btn_fire" ) and\
			fsm.state_cur != fsm.STATES.interact and \
			fsm.state_cur != fsm.STATES.altar and \
			fsm.state_cur != fsm.STATES.hit and \
			fsm.state_nxt != fsm.STATES.hit and \
			arm.check_fire():
		is_fire = true
		fire_state = FIRE_STATES.FIRE
	if is_fire:
		match fire_state:
			FIRE_STATES.FIRE:
				# random position
				var roffset = Vector2( \
					round( 0*rand_range( -1, 1 ) ), \
					round( rand_range( -3, 3 ) ) ) 
				# nozzle blast
				var n = preload( "res://girl/bullet/muzzle_blast.tscn" ).instance()
				n.position = arm.get_node( "fire_position" ).position + roffset
				arm.add_child( n )
				# instance bullet
				arm.fire( get_parent(), roffset )
				# fire animation
				arm.get_node( "armanim" ).play( "fire" )
				# next state
				fire_timer = FIRE_WAITTIME
				fire_state = FIRE_STATES.WAIT
				# sfx
				$mplayer.mplay( preload( "res://sfx/player_shoot.wav" ) )
			FIRE_STATES.WAIT:
				fire_timer -= delta
				if fire_timer <= 0:
					is_fire = false


func _interact( delta ):
	if fsm.state_cur == fsm.STATES.interact: return
	if is_fire: return
	if Input.is_action_just_pressed( "btn_interact" ):
		interact_area = _check_interaction()
		if interact_area == null: return
		print( "Player interacting with area ", interact_area.name )
		interact_area.interact( self )

func _check_interaction():
	var areas = $interact_box.get_overlapping_areas()
	print( "Interacting areas: ", areas )
	for a in areas:
		if a.has_method( "interact" ):
			return a
		elif a.get_parent().has_method( "interact" ):
			return a.get_parent()
	return null




var is_on_platform = false
#var prv_parent = null
#var prv_platform = null
var old_motion = Vector2()
func _platform( delta ):
	var platform = null
	if $down_left.is_colliding() and $down_left.get_collider() != null and \
		$down_left.get_collider().is_in_group( "platform" ):
			platform = $down_left.get_collider()
	elif $down_right.is_colliding() and $down_right.get_collider() != null and \
		$down_right.get_collider().is_in_group( "platform" ):
			platform = $down_right.get_collider()
	if platform == null:
		camera_mode = 0
		if is_on_platform:
			is_on_platform = false
			vel += vel_platform#old_motion / delta
		vel_platform *= 0.0
		return
	is_on_platform = true
	old_motion = platform.delta_motion
	position += platform.delta_motion
	vel_platform = platform.delta_motion / delta
	#print( vel_platform )
	camera_mode = 1
	#game.camera.reset_smoothing()
	#move_and_slide( platform.delta_motion )






#========================
# dust functions
#========================
func dust_run():
	#print( vel.x )
	if abs( vel.x ) < 50: return
	var d = preload( "res://girl/dust/dust_run.tscn" ).instance()
	d.position = position + $rotate/girl.position
	d.scale.x = dir_cur
	get_parent().add_child( d )
func dust_jump():
	var d = preload( "res://girl/dust/dust_jump.tscn" ).instance()
	d.position = position + $rotate/girl.position
	d.scale.x = dir_cur
	get_parent().add_child( d )
func dust_land():
	var d = preload( "res://girl/dust/dust_land.tscn" ).instance()
	d.position = position + $rotate/girl.position
	d.scale.x = dir_cur
	get_parent().add_child( d )

func _on_hitbox_area_entered( area ):
	if invulnerable: return
	if fsm.state_cur == fsm.STATES.hit or \
		fsm.state_nxt == fsm.STATES.hit:
			return
	fsm.state_nxt = fsm.STATES.hit
	pass # replace with function body


func _on_reward_area_entered(area):
	pass


#========================
# SFX
#========================
func step():
	$mplayer.mplay( preload( "res://sfx/step.wav" ) )

func jump():
	$mplayer.mplay( preload( "res://sfx/jump.wav" ) )

func deadfx():
	$mplayer.mplay( preload( "res://sfx/player_dead.wav" ), false )













