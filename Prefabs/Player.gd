extends RigidBody2D

# Member variables
var anim = ""
var siding_left = false
var jumping = false
var stopping_jump = false
var piercing = false

export (int) var WALK_ACCEL = 800.0
export (int) var WALK_DEACCEL = 800.0
export (int) var WALK_MAX_VELOCITY = 200.0
export (int) var AIR_ACCEL = 200.0
export (int) var AIR_DEACCEL = 200.0
export (int) var JUMP_VELOCITY = 460
export (int) var STOP_JUMP_FORCE = 900.0

var MAX_FLOOR_AIRBORNE_TIME = 0.15

var airborne_time = 1e20

var floor_h_velocity = 0.0

onready var balloonPacked = preload("res://Prefabs/Balloon.tscn")
var inflatingBalloon = null

var balloons = []
var selectedBalloon = null
var selectedBalloonDist = 0
var selectedBalloonGrav = 0
var mouseVector = Vector2()

onready var camera = get_node("Camera")

func _input(event):	
	if Input.is_action_pressed("inflate"):
		inflateBalloon()
	if Input.is_action_pressed("launch"):
		launchBalloon()
		
	if event is InputEventMouseMotion:
		if selectedBalloon:
			selectedBalloon.set_gravity_scale(selectedBalloonGrav)
		mouseVector = (get_global_mouse_position() - get_position()).normalized()
		selectedBalloon = closestBalloon(mouseVector)
		if selectedBalloon:
			selectedBalloonGrav = selectedBalloon.get_gravity_scale()
			selectedBalloon.set_gravity_scale(0)
			selectedBalloonDist = (selectedBalloon.get_position() - get_position()).length()

func _integrate_forces(var s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()
	
	var new_anim = anim
	var new_siding_left = siding_left
	
	# Get the controls
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var launch = Input.is_action_just_pressed("launch")
	
	if jump:
		jump = true
	
	if selectedBalloon:
		selectedBalloon.apply_impulse(Vector2(), mouseVector * 5)
	
	# Deapply prev floor velocity
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0
	
	# Find the floor (a contact with upwards facing collision normal)
	var found_floor = false
	var floor_index = -1
	
	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)
		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x
	
	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air
	
	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump
	if jumping:
		if lv.y > 0:
			# Set off the jumping flag if going down
			jumping = false
		elif not jump:
			stopping_jump = true
		
		if stopping_jump:
			lv.y += STOP_JUMP_FORCE * step
	
	if on_floor:
		# Process logic when character is on floor
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= WALK_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += WALK_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
		
		# Check jump
		if not jumping and jump:
			lv.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false
			$sound_jump.play()
		
		# Check siding
		if lv.x < 0 and move_left:
			new_siding_left = true
		elif lv.x > 0 and move_right:
			new_siding_left = false
		if jumping:
			new_anim = "jumping"
		elif abs(lv.x) < 0.1:
			new_anim = "idle"
		else:
			new_anim = "run"
	else:
		# Process logic when the character is in the air
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += AIR_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv
		
		if lv.y < 0:
			new_anim = "jumping"
		else:
			new_anim = "falling"
	
	# Update siding
	if new_siding_left != siding_left:
		$medium_kid.flip_h = new_siding_left
		siding_left = new_siding_left
	
	# Change animation
	if new_anim != anim:
		anim = new_anim
		$anim.play(anim)
	
	# Apply floor velocity
	if found_floor:
		floor_h_velocity = s.get_contact_collider_velocity_at_position(floor_index).x
		lv.x += floor_h_velocity
	
	# Finally, apply gravity and set back the linear velocity
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)
	
func inflateBalloon():
	if inflatingBalloon:
		return
	
	inflatingBalloon = balloonPacked.instance()
	inflatingBalloon.set_position(get_position())
	
	inflatingBalloon.connect("finish_inflating", self, "_on_Balloon_inflated", [ inflatingBalloon ], CONNECT_DEFERRED | CONNECT_ONESHOT);
	inflatingBalloon.connect("finish_deflating", self, "_on_Balloon_deflated", [ inflatingBalloon ], CONNECT_DEFERRED | CONNECT_ONESHOT);
	
	var spring = inflatingBalloon.get_node("DampedSpringJoint2D")
	
	get_parent().add_child(inflatingBalloon)	
	spring.set_node_a(get_path())
	
	inflatingBalloon.inflate(siding_left)
	
func launchBalloon():
	var vec = (get_global_mouse_position() - get_position()).normalized()
	var b = closestBalloon(vec)

	if not b:
		return

	b.pierce(vec)

func closestBalloon(var vec):
	var minV = 9999999
	var minB = null
	for i in range(balloons.size()):
		var bVec = balloons[i].get_position() - get_position()
		if abs(bVec.angle() - vec.angle()) < minV:
			minV = abs(bVec.angle() - vec.angle())
			minB = balloons[i]
	return minB

func _on_Balloon_inflated(var balloon):
	inflatingBalloon = null
	balloons.append(balloon)

func _on_Balloon_deflated(var balloon):
	balloons.erase(balloon)
	if selectedBalloon == balloon:
		selectedBalloon = null
	balloon.free()
	