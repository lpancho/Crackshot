extends RigidBody2D

const MIN_VEL = 10
var time = 5
var state = 0

func _process(delta):
	if state == 0:
		# counting velocity or time
		time -= delta
		if self.linear_velocity.length() < MIN_VEL or time <= 0:
			state = 1
			time = 3
	elif state == 1:
		# count time
		time -= delta
		if time <= 0:
			state = 2
	elif state == 2:
		# fade out
		self.modulate.a = lerp( self.modulate.a, 0, 2 * delta )
		if self.modulate.a < 0.05:
			state = 3
	elif state == 3:
		queue_free()