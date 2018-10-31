extends "res://girl/gun.gd"

func _ready():
	bullet_scn = preload( "res://girl/big_gun/big_gun_bullet.tscn" )

func check_fire():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_point( $fire_position.global_position, 32, [], 1 )
	if result.empty():
		return true
	elif result.size() == 1:
		if result[0].collider is Area2D:
			return true
	return false