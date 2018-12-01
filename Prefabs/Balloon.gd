extends RigidBody2D

var inflated = false
var deflating = false

signal finish_inflating;
signal finish_deflating;

func inflate():
	if not inflated:
		$AnimatedSprite.play("inflating")
		$inflating_sound.play()

func pierce(var direction):
	if inflated:
		apply_impulse(Vector2(0,0), direction)
		deflating = true
		$deflating_sound.play()
		$DeflatingTimer.start()

func _on_animation_finished():
	if not inflated:
		inflated = true
		emit_signal("finish_inflating")
		$AnimatedSprite.play("inflated")

func _on_DeflatingTimer_timeout():
	emit_signal("finish_deflating")
