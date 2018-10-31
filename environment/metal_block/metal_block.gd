extends RigidBody2D

export( bool ) var maintain_x = false
export( bool ) var maintain_y = false

var initial_pos = Vector2()
func _ready():
	initial_pos = position

func _integrate_forces(state):
	var vel = state.get_linear_velocity()
	if maintain_x:
		state.set_linear_velocity(Vector2(0, vel.y))
		state.transform.origin.x = initial_pos.x
	elif maintain_y:
		state.set_linear_velocity(Vector2(vel.x, 0))
		state.transform.origin.y = initial_pos.y