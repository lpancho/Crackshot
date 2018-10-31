extends "res://scripts/state.gd"

enum STATES { FIRE, WAIT }

var state
var state_timer
var target_position

func initialize( obj ):
	obj.anim_nxt = "idle"
	state = STATES.FIRE
	target_position = obj.position
	obj.get_node( "shoot" ).play()

func run( obj, delta ):
#	var desired_vel = ( target_position - obj.position ).normalized() * 30.0
#	obj.vel += desired_vel
#	obj.vel = obj.vel.clamped( 30 )
	
	# check limits
	if obj.reached_limit():
		obj.vel.x *= 0
	# move
	obj.vel = obj.move_and_slide( obj.vel )
	
	match state:
		STATES.FIRE:
			if not obj.player_line_of_sight():
				obj.fsm.state_nxt = obj.fsm.STATES.robot_idle
				return
			# fire
			var roffset = Vector2( 0, rand_range( -2, 2 ) )
			
			var b = preload( "res://walking_robot/fire/fire_blast.tscn" ).instance()
			var x = preload( "res://walking_robot/fire/robot_bullet.tscn" ).instance()
			
			var firepos = obj.rotate.get_node( "firepos" ).global_position
			var firedir
			if obj.predictive_fire:
				var playerpos = _player_future_pos( \
					game.player.position, \
					game.player.vel + game.player.vel_platform / 2, obj.position, x.vel )
				firedir = playerpos - ( firepos + roffset )
			else:
				firedir = game.player.global_position - firepos
			
			b.position = obj.rotate.get_node( "firepos" ).position + roffset
			var aux = firedir
			aux.x = abs( aux.x )
			b.rotation = aux.angle()
			obj.rotate.add_child( b )
			
			# bullet
			x.global_position = firepos + roffset
			x.bullet_rotation = firedir.angle()
			obj.get_parent().add_child( x )
			
			# throwback
			obj.vel.y = ( -firedir.normalized() ).y * 250
			obj.vel = obj.move_and_slide( obj.vel )
			state = STATES.WAIT
			state_timer = 1.0
		STATES.WAIT:
			state_timer -= delta
			if state_timer <= 0:
				state = STATES.FIRE
			pass

func _player_future_pos( p0, v0, p, v ):
	var vL = v0.length()
	if vL < 1:
		return p0
	var dL = ( p0 - p ).length() # distance to target
	var dT = dL / v # time to arrive at target
	#dT = dT * rand_range( 0, 1 ) # a little randomness
	return p0 + v0 * dT # bad prediction


