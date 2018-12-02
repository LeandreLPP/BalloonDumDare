extends MarginContainer

func _process(delta):
	$VBoxContainer/LevelNumber.text = "Level " + str(LevelManager.current_level)
	var player_path = "../../../Player"
	var player_node = get_node(player_path)
	if player_node:
		var txt = str(player_node.BALLOONS_COUNT) + " balloons left"
		$VBoxContainer/HBoxContainer/BalloonNumber.text = txt
	
	if Input.is_action_just_pressed("restart"):
		LevelManager.reload_level()

func _on_RestartButton_pressed():
	LevelManager.reload_level()
