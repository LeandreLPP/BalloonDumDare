extends Node

func _on_BalloonSwitch_switched(on):
	print("Switched " + str(on))
	$"BalloonSwitch/Sprite".flip_h = on
