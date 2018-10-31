extends Node2D

const MAX_LEN = 100

func set_bullet( origin, dir ):
	global_position = origin
	rotation = dir.angle()
	
	# compute extent using a raycast
	var space_state = get_world_2d().direct_space_state
	var start_pos = origin
	var end_pos = origin + dir.normalized() * MAX_LEN
	var result = space_state.intersect_ray( \
		start_pos, end_pos, [], 1 )
	if not result.empty():
		end_pos = result.position
		