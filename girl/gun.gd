extends Sprite

var bullet_scn = null

func fire( parent, offset = Vector2() ):
	if bullet_scn == null: return
	var b = bullet_scn.instance()
	b.global_position = $fire_position.global_position + offset
	b.bullet_rotation = rotation
	parent.add_child( b )


