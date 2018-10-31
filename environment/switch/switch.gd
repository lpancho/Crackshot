extends Area2D

#signal switch_flipped
signal activated
signal deactivated

export(bool) var initial_state = false
export(bool) var active = false

var is_changing = false
var state = false

func _ready():
	state = initial_state
	if state:
		print( "turning switch off (initial) " )
		$anim.play( "turn_on" )
	else:
		print( "turning switch on (initial) " )
		$anim.play( "turn_off" )

func activate():
	active = true

func deactivate():
	active = false

func interact( obj = null ):
	if not active: return
	#print( "Flipping switch from ", state )
	if is_changing: return
	is_changing = true
	if state:
		state = false
		$anim.play( "turn_off" )
	else:
		state = true
		$anim.play( "turn_on" )
	$tick.play()


func _on_anim_animation_finished(anim_name):
	if state:
		emit_signal( "activated" )
	else:
		emit_signal( "deactivated" )
	is_changing = false



