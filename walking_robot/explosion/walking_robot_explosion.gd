extends Node2D


var hit_dir = 1
var multiplier = 1.5

func _ready():
	# set velocity of parts
	if hit_dir == -1:
		# hit came from the front
		$part_0.linear_velocity = Vector2( -200, 0 ) * multiplier
		$part_1.linear_velocity = Vector2( -150, -100 ) * multiplier
		$part_2.linear_velocity = Vector2( -150, -100 ) * multiplier
		$part_3.linear_velocity = Vector2( -100, 0 ) * multiplier
		$part_4.linear_velocity = Vector2( 100, -200 ) * multiplier
#		$part_5.linear_velocity = Vector2( -150, -150 )
#		$part_6.linear_velocity = Vector2( -150, -150 )
	else:
		# hit came from the back
		$part_0.linear_velocity = Vector2( 100, 0 ) * multiplier
		$part_1.linear_velocity = Vector2( 150, -100 ) * multiplier
		$part_2.linear_velocity = Vector2( 150, -100 ) * multiplier
		$part_3.linear_velocity = Vector2( 100, 0 ) * multiplier
		$part_4.linear_velocity = Vector2( 100, -200 ) * multiplier
#		$part_5.linear_velocity = Vector2( -150, -150 )
#		$part_6.linear_velocity = Vector2( 150, -150 )
	game.camera_shake( 0.25, 60, 4 )
