extends Node

signal restart_level
signal finished_level
signal game_over
var can_input = false
var initial_coins = 0

func _ready():
	call_deferred( "_set_camera_limits" )
	call_deferred( "_connect_to_player" )
	call_deferred( "_connect_to_finish" )
	var input_timer = Timer.new()
	input_timer.wait_time = 0.3
	input_timer.connect( "timeout", self, "_on_input_timer_timeout" )
	add_child( input_timer )
	input_timer.start()
	initial_coins = game.gamestate.coins
	game.play_music( 0 )
	

func _set_camera_limits():
	#print( "Checking stuff" )
	var pos_NW = find_node( "camera_limit_NW" )
	#print( "POS_NW: ", pos_NW )
	if pos_NW == null: return
	var pos_SE = find_node( "camera_limit_SE" )
	if pos_SE == null: return
	if game.camera == null: return
	game.camera.limit_left = pos_NW.position.x
	game.camera.limit_top = pos_NW.position.y
	game.camera.limit_right = pos_SE.position.x
	game.camera.limit_bottom = pos_SE.position.y

func _connect_to_player():
	var girl = find_node( "girl" )
	if girl == null: return
	girl.connect( "player_dead", self, "_on_player_dead" )

func _connect_to_finish():
	var finish = find_node( "finish_area" )
	if finish == null: return
	finish.connect( "body_entered", self, "_on_finish" )

func _on_input_timer_timeout():
	can_input = true

func _on_player_dead():
	game.gamestate.coins = initial_coins
	emit_signal( "restart_level" )

func _on_finish( body ):
	pass

func _input(evt):
	if evt.is_action_pressed( "btn_quit" ):
		emit_signal( "game_over" )

