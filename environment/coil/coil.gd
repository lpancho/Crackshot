tool
extends Node2D

signal activated
signal deactivated

export(int) var coil_orientation = 1 setget _set_type
export(bool) var active = false setget _set_active
export(bool) var repel = false


#196

func _ready():
	
	if repel:
		$rotate/magnet.gravity *= -1
	else:
		$rotate/magnet.gravity = 196
	call_deferred( "_set_grav" )
func _set_grav():
	#print( "ROTATION: ", $rotate.rotation )
	#print( "GRAVITY: ", (Vector2( -1, 0 ).rotated( $rotate.rotation ) ) )
	$rotate/magnet.gravity_vec = Vector2( -1, 0 ).rotated( $rotate.rotation )

func activate():
	#print( "COIL ACTIVATING ", active )
	$magnet.play()
	call_deferred( "_set_collision", false )
	emit_signal( "activated" )
	

func deactivate():
	#print( "COIL DEACTIVATING ", active )
	call_deferred( "_set_collision", true )
	emit_signal( "deactivated" )
	

func _set_collision( v ):
	#print( "COIL SETTING COLLISION ", v )
	$rotate/magnet/collision.disabled = v
	if v:
		$anim.play( "start" )
	else:
		$anim.play( "active" )

func _set_active(v):
	active = v
	if active:
		activate()
	else:
		deactivate()

func _set_type(v):
	coil_orientation = v
	call_deferred( "_align_coil" )

func _align_coil():
	match coil_orientation:
		1:
			$rotate.rotation = 0
		2:
			$rotate.rotation = PI / 2
		3:
			$rotate.rotation = PI
		4:
			$rotate.rotation = 3 * PI / 2