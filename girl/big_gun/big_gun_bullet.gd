extends KinematicBody2D

var bullet_rotation = 0
var dir = Vector2()
var vel = 400
var is_colliding = false

var hit_wall_scn = preload( "res://girl/big_gun/big_gun_bullet_hit_wall.tscn" )

func _ready():
	dir = Vector2( 1, 0 ).rotated( bullet_rotation )
	$sprite.rotation = bullet_rotation


func  _physics_process( delta ):
	var coldata = move_and_collide( dir * vel * delta )
	if coldata != null:
		_collision( coldata )


func _on_visible_screen_exited():
	queue_free()


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


func _on_interactbox_area_entered(area):
	if is_colliding: return
	var a = null
	if area.has_method( "interact" ):
			a = area
	elif area.get_parent().has_method( "interact" ):
		a = area.get_parent()
	if a == null: return
	is_colliding = true
	#print( "BULLET ON AREA: ", area )
	a.interact( self )
	
	var h = hit_wall_scn.instance()
	var n = dir.rotated( PI / 2 )
	h.rotation = ( dir ).angle()
	h.position = position
	get_parent().add_child( h )
	queue_free()
	pass # replace with function body




func _on_damagebox_area_entered(area):
	#print( "ENTERED AREA: ", area.name )
	queue_free()
	pass # replace with function body
