extends StaticBody2D

func open():
	$AnimatedSprite.play("opened")
	$CollisionShape2D.set_disabled(true)

func close():
	$AnimatedSprite.play("closed")
	$CollisionShape2D.set_disabled(false)