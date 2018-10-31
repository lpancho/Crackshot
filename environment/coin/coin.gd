extends Area2D


enum STATES { WAIT, PLAYER, END, FREE }
var state = STATES.WAIT
var active = false
var found = false
const MAX_VEL = 200
var vel = Vector2()
var timer = 1

func _ready():
	pass

func _physics_process(delta):
	match state:
		STATES.WAIT:
			pass
		STATES.PLAYER:
			var desired_vel = game.player.global_position - global_position
			vel += desired_vel
			vel = vel.clamped( MAX_VEL )
			position += vel * delta
		STATES.END:
			$coin.hide()
			game.gamestate.coins += 1
			$ping.play()
			state = STATES.FREE
		STATES.FREE:
			vel *= 0.5
			position += vel * delta
			$trail.modulate.a = lerp( $trail.modulate.a, 0, 5 * delta )
			$light.energy = lerp( $light.energy, 0, delta )
			if timer > 0:
				timer -= delta
				if timer <= 0:
					queue_free()
	
	
		

func _on_coin_area_entered(area):
	if game.player != null:
		if area.get_parent() == game.player:
			if active: return
			active = true
			state = STATES.END
	pass # replace with function body


func _on_search_player_area_entered(area):
	if game.player == null or area.get_parent() != game.player: return
	if found: return
	found = true
	state = STATES.PLAYER
	$trail.emitting = true
	pass # replace with function body


func _on_VisibilityNotifier2D_screen_entered():
	$light.enabled = true
	pass # replace with function body
