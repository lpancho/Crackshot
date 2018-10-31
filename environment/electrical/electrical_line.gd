extends Line2D

signal activated
signal deactivated

export( bool ) var active = false

func _ready():
	if active:
		activate()

func activate():
	$anim.play( "cycle" )
	$active_timer.start()

func deactivate():
	$anim.play( "start" )
	emit_signal( "deactivated" )

func _on_active_timer_timeout():
	emit_signal( "activated" )
