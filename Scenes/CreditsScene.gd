extends Node

export (PackedScene) var Balloon

func _ready():
    randomize()

func _on_MenuButton_pressed():
	LevelManager.goto_main_menu()

func _on_TimerPopBalloon_timeout():
	# Choose a random location on Path2D.
	$PathPop/BalloonSpawnLocation.set_offset(randi())
	# Create a Mob instance and add it to the scene.
	var balloon = Balloon.instance()
	add_child(balloon)
	balloon.get_child(3).stream = null
	balloon.position = $PathPop/BalloonSpawnLocation.position
	balloon.inflate(false)
