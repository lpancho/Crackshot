extends KinematicBody2D

var initial_position = Vector2()
var active_offset = Vector2( 0, -32 )
var motion_offset = Vector2( 8192 - 96, 0 )

var delta_motion = Vector2()
var old_pos = Vector2()

var vel = Vector2( 100, 0 )
var dir = 0

func _ready():
	initial_position = position
	old_pos = position

func _physics_process(delta):
	delta_motion = ( position - old_pos )# / delta
	old_pos = position

func activate():
	#print( "activating platform" )
	$tween.interpolate_property( self, "position", initial_position, \
		initial_position + active_offset, 2, Tween.TRANS_ELASTIC, \
		Tween.EASE_IN_OUT, 0 )
	$tween.start()


func move():
	#print( "moving platform" )
	game.play_music( 1 )
	dir = 0
	$tween_move.interpolate_property( self, "position", initial_position + active_offset, \
		initial_position + active_offset + motion_offset, \
		60, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 0 )
	$tween_move.interpolate_property( self, "position", initial_position + active_offset + motion_offset, \
		initial_position + active_offset, \
		60, Tween.TRANS_LINEAR, Tween.EASE_OUT_IN, 70 )
	$tween_move.start()