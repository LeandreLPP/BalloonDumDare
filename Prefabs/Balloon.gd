extends RigidBody2D

var inflated = false
var deflating = false
export (int) var propulsion_force = 500
export (float) var GRAV_SCALE = -10

signal finish_inflating
signal finish_deflating

var target_pos
var target_angle
var set_target = false
var exploding = false

var available_colors = [
	Color("ac3232"),  # red
	Color("6abe30"), # green
	Color("5b6ee1"), # blue
	Color("df7126"), # orange
	Color("76428a"), # purple
	Color("37946e"), # teal
]

func setHand(hand):
	$Rope.hand = hand

func stopFollowingTarget():
	if set_target:
		$DampedSpringJoint2D.node_b = ".."
		set_mode(RigidBody2D.MODE_RIGID)
		$Collision.disabled = false
		set_gravity_scale(GRAV_SCALE)
		set_target = false

func setTargetPosition(pos, ang):
	if not deflating:
		$DampedSpringJoint2D.node_b = ""
		set_mode(RigidBody2D.MODE_KINEMATIC)
		$Collision.disabled = true
		target_pos = pos
		target_angle = ang + PI/2
		set_target = true

func _physics_process(delta):
	if set_target:
		set_global_position(target_pos)
		set_rotation(target_angle)

func _ready():
	set_gravity_scale(0)
	set_mode(RigidBody2D.MODE_STATIC)
	
	randomize()
	var random_color = available_colors[randi() % len(available_colors)]
	$Sprite.set_modulate(random_color)

func inflate(siding_left):
	if not inflated:
		$Animation.play("inflate")
		$inflating_sound.play()

func _on_animation_finished(var animationName):
	if not inflated and animationName == "inflate":
		inflated = true
		set_gravity_scale(GRAV_SCALE)
		set_mode(RigidBody2D.MODE_RIGID)
		apply_impulse(Vector2(0, 0), Vector2(0, 0))
		emit_signal("finish_inflating")
	elif animationName == "deflate":
		pass # todo deflated ballon particle

func pierce(direction):
	if inflated:
		stopFollowingTarget()
		mass = 4
		set_gravity_scale(0)
		add_force(Vector2(0,0), direction * mass * propulsion_force)
		deflating = true
		$deflating_sound.play()
		$Animation.play("deflate")
		$DeflatingTimer.start()

func detach(direction):
	if inflated:
		$Rope.hand = null
		$DampedSpringJoint2D.set_node_a("")
		$DampedSpringJoint2D.queue_free()
		pierce(direction)
		

func explode():
	if not exploding:
		exploding = true
		$Animation.play("paf")
		$explode_sound.play()

func _on_DeflatingTimer_timeout():
	emit_signal("finish_deflating")

func _on_deflating_sound_finished():
	emit_signal("finish_deflating")

func _on_explode_sound_finished():
	queue_free()
	emit_signal("finish_deflating")
