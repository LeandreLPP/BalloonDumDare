extends Area2D

func open():
	$AnimatedSprite.play("open")
	$CollisionShape2D.set_disabled(true)