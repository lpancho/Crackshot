extends KinematicBody2D

var bullet_rotation = 0
var dir = Vector2()
var vel = 150
var is_colliding = false

var hit_wall_scn = preload( "res://walking_robot/fire/robot_bullet_blast.tscn" )

func _ready():
	dir = Vector2( 1, 0 ).rotated( bullet_rotation )
	$sprite.rotation = bullet_rotation


func  _physics_process( delta ):
	var coldata = move_and_collide( dir * vel * delta )
	if coldata != null:
		_collision( coldata )


func _collision( cdata ):
	if is_colliding: return
	is_colliding = true
	if cdata.collider.has_method( "hit" ):
		cdata.collider.hit( cdata )
	else:
		var h = hit_wall_scn.instance()
		h.rotation = ( -cdata.normal ).angle()
		h.position = cdata.position
		get_parent().add_child( h )
	queue_free()
	pass

func _on_damagebox_area_entered(area):
	return
	if area.get_parent().has_method( "hit" ):
		if is_colliding: return
		is_colliding = true
		var h = hit_wall_scn.instance()
		h.global_position = area.global_position
		get_parent().add_child( h )
		area.get_parent().hit()
		queue_free()
