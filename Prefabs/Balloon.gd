extends RigidBody2D

var inflated = false
var deflating = false

signal finish_inflating;
signal finish_deflating;

func _ready():
	gravity_scale = 0
	mode = RigidBody2D.MODE_CHARACTER

func inflate(siding_left):
	if not inflated:
		$Animation.play("inflate")
		$inflating_sound.play()

func pierce(direction):
	if inflated:
		look_at(position + direction)
		mode = RigidBody2D.MODE_CHARACTER
		apply_impulse(Vector2(0,0), direction)
		deflating = true
		$deflating_sound.play()
		$DeflatingTimer.start()

func _on_animation_finished(var animationName):
	if not inflated:
		inflated = true
		gravity_scale = -1
		mode = RigidBody2D.MODE_RIGID
		emit_signal("finish_inflating")

func _on_DeflatingTimer_timeout():
	emit_signal("finish_deflating")
