extends Area2D

var vel = Vector2()
var is_active = true

func _ready():
	connect( "area_entered", self, "_on_area_entered" )
	connect( "body_entered", self, "_on_body_entered" )

func _physics_process( delta ):
	if is_active:
		position += vel * delta

func _on_area_entered( area ):
	if not is_active: return
	if area.is_in_group( "hitbox" ):
		is_active = false
		if area.get_parent().has_method( "hit" ):
			area.get_parent().hit()
		queue_free()

func _on_body_entered( body ):
	if not is_active: return
	is_active = false
	queue_free()
	pass