extends "res://scripts/state.gd"

enum STATES { FIRE, WAIT }

var state
var state_timer

func initialize( obj ):
	obj.anim_nxt = "fire"
	state = STATES.FIRE
	obj.get_node( "shoot" ).play()

func run( obj, delta ):
	# gravity
	obj.vel.y = min( obj.vel.y + game.GRAVITY * delta, game.TERMINAL_VELOCITY )
	# slow down horizontally
	obj.vel.x *= 0.8
	# move
	obj.vel = obj.move_and_slide( obj.vel )
	
	match state:
		STATES.FIRE:
			if not obj.player_line_of_sight():
				obj.fsm.state_nxt = obj.fsm.STATES.robot_idle
				return
			# fire
			var roffset = Vector2( 0, rand_range( -2, 2 ) )
			var firedir = game.player.global_position - obj.rotate.get_node( "firepos" ).global_position
			var b = preload( "res://walking_robot/fire/fire_blast.tscn" ).instance()
			b.position = obj.rotate.get_node( "firepos" ).position + roffset
			var aux = firedir
			aux.x = abs( aux.x )
			b.rotation = aux.angle()
			obj.rotate.add_child( b )
			# bullet
			var x = preload( "res://walking_robot/fire/robot_bullet.tscn" ).instance()
			x.global_position = obj.rotate.get_node( "firepos" ).global_position + roffset
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




