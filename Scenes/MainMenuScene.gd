extends Node

func _ready():
	if OS.get_name() == "HTML5":
		$MainMenu/VBoxContainer/QuitButton.disabled = true
		$MainMenu/VBoxContainer/QuitButton.hide()

func _on_PlayButton_pressed():
	LevelManager.goto_level(LevelManager.current_level)


func _on_LevelButton_pressed():
	LevelManager.goto_levels_scene()


func _on_OptionsButton_pressed():
	LevelManager.goto_options_scene()


func _on_CreditsButton_pressed():
	LevelManager.goto_credit_scene()

func _on_QuitButton_pressed():
	get_tree().quit()
