extends RigidBody2D

var inflated = false
var deflating = false
export (int) var propulsion_force = 500

signal finish_inflating
signal finish_deflating

func _ready():
	gravity_scale = 0
	mode = RigidBody2D.MODE_STATIC

func inflate(siding_left):
	if not inflated:
		$Animation.play("inflate")
		$inflating_sound.play()

func _on_animation_finished(var animationName):
	if not inflated:
		inflated = true
		gravity_scale = -1
		mode = RigidBody2D.MODE_RIGID
		emit_signal("finish_inflating")
		
func pierce(direction):
	if inflated:
		mass = 10
		add_force(Vector2(0,0), direction * mass * propulsion_force)
		deflating = true
		$deflating_sound.play()
		$DeflatingTimer.start()

func _on_DeflatingTimer_timeout():
	emit_signal("finish_deflating")

func _on_deflating_sound_finished():
	emit_signal("finish_deflating")
