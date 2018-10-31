extends KinematicBody2D


const MAX_VEL = 50
const ACCEL = 15
const STATE_TIME = 5
const MAX_PLAYER_DIST = 200#160

var fsm = null

var dir_cur = 1
export var dir_nxt = 1
var vel = Vector2()
export var predictive_fire = false

var anim_cur = ""
var anim_nxt = ""

var limits = []
var set_height = 0

onready var rotate = $rotate

func _ready():
	fsm = preload( "res://scripts/fsm.gd" ).new( self, $states, $states/robot_run, false )
	set_height = global_position.y
	call_deferred( "_set_limits" )


func _set_limits():
	var lleft = find_node( "limit_left" )
	var lright = find_node( "limit_right" )
	if lleft != null and lright != null:
		limits = [ lleft.global_position.x, lright.global_position.x ]


func _physics_process(delta):
	# update states machine
	fsm.run_machine( delta )
	# direction
	if dir_nxt != dir_cur:
		dir_cur = dir_nxt
		$rotate.scale.x = dir_cur
	# update animations
	if anim_nxt != anim_cur:
		anim_cur = anim_nxt
		$anim.play( anim_cur )
	
	# height
	var desired_vel = set_height - global_position.y
	vel.y += desired_vel
	vel.y = min( vel.y, 20 )
	if not limits.empty():
		if global_position.x < limits[0]:
			global_position.x = limits[0]
		elif global_position.x > limits[1]:
			global_position.x = limits[1]
	
	# player
	if fsm.state_cur != fsm.STATES.robot_fire and \
		fsm.state_nxt != fsm.STATES.robot_fire:
			if player_line_of_sight():
				fsm.state_nxt = fsm.STATES.robot_fire
	


func reached_limit():
	if $rotate/front.is_colliding():
		return true
	if not limits.empty():
		if global_position.x < limits[0] or global_position.x > limits[1]:
			return true
	return false


func player_line_of_sight():
	# check player
	if game.player == null:
		#print( name, " player not found" )
		return false
	# check direction
	var playerpos = game.player.global_position
	var firepos = $rotate/firepos.global_position
	if sign( ( playerpos - firepos ).x ) != dir_cur:
		#print( name, " player not in front" )
		return false
	# check screen
	#if name == "flying_robot3":
	#	print( "R3: ", $visibility.is_on_screen() )
#	if not $visibility.is_on_screen():
#		return false
	if not check_visibility(): return false
	# check distance
	if ( playerpos - firepos ).length() > MAX_PLAYER_DIST:
		#print( name, " player too far" )
		return false
	# check obstacles	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray( firepos, playerpos, [ self ], 1 )
	if result.empty():
		return true
	#print( name, " player behind obstacles ", result )
	return false

var is_hit = false
func _on_hitbox_area_entered(area):

	if is_hit: return
	is_hit = true
	position = position.round()
	var scn = preload( "res://walking_robot/fire/robot_bullet_blast.tscn" )
	var b1 = scn.instance()
	var b2 = scn.instance()
	var b3 = scn.instance()
	b1.position = position + Vector2( rand_range( -3, 3 ), rand_range( -3, 3 ) )
	b2.position = position + Vector2( rand_range( -3, 3 ), rand_range( -3, 3 ) )
	b2.get_node( "anim" ).playback_speed = 2.3
	b3.position = position + Vector2( rand_range( -3, 3 ), rand_range( -3, 3 ) )
	b3.get_node( "anim" ).playback_speed = 1.7
	get_parent().add_child( b1 )
	get_parent().add_child( b2 )
	get_parent().add_child( b3 )

	var x = preload( "res://walking_robot/explosion/walking_robot_explosion.tscn" ).instance()
	x.hit_dir = sign( area.get_parent().dir.x )
	x.position = position
	get_parent().add_child( x )
	queue_free()



func check_visibility():
	if not $visibility.is_on_screen():
		return false
	var t = get_viewport_transform()
	var s = get_viewport_rect()
	var visible_rect = s
	visible_rect.position -= t.origin
	return visible_rect.has_point( position )
