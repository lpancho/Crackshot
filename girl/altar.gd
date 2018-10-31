extends "res://scripts/state.gd"

func initialize( obj ):
	obj.can_aim = false
	

func terminate( obj ):
	obj.can_aim = true