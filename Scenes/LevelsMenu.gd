extends MarginContainer

export (PackedScene) var level_button;

func _ready():
	for i in range(LevelManager.MIN_LEVEL, LevelManager.MAX_LEVEL + 1):
		add_Level_Button(i)

func add_Level_Button(i):
	var button = level_button.instance()
	button.text = "Level " + str(i)
	$VBoxContainer/HBoxContainer.add_child(button)
	button.connect("pressed", self, "_on_Level_Button_pressed", [i])

func _on_Level_Button_pressed(i):
	LevelManager.goto_level(i)

func _on_MenuButton_pressed():
	LevelManager.goto_main_menu()
