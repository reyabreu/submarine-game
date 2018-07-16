extends Node

func _on_TestRect_collisioninfo_change(is_bouncing):
	$CanvasLayer/CheckBox.pressed = is_bouncing
	print("is_bouncing : %s, ticks: %s" % [is_bouncing, OS.get_ticks_msec()])

func _ready():
	for value in range(-10, 10): 
		print("value: %d, sign: %d" % [value, sign(value)])