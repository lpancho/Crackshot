extends StaticBody2D

signal activated

var is_active = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func interact( obj ):
	$interaction_box/collision.disabled = true
	game.camera_shake( 0.5, 60, 1 )
	$magnet.play()
	$anim.play( "active" )
	$spintimer.start()
	


func _on_spintimer_timeout():
	game.camera_shake( 1, 60, 2 )
	$anim_2.play( "start" )
	emit_signal( "activated" )
