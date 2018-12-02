extends Node

var current_scene = null

var azerty = true
var current_level = 1
export (int) var MIN_LEVEL = 1
export (int) var MAX_LEVEL = 11

onready var music = get_node("/root/MusicPlayer")

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

func _process(delta):
	if Input.is_action_just_pressed("menu"):
		goto_main_menu()

func goto_main_menu():
	music.inGame = false
	goto_scene("res://Scenes/MainMenuScene.tscn")

func goto_credit_scene():
	music.inGame = false
	goto_scene("res://Scenes/CreditsScene.tscn")
	
func goto_levels_scene():
	music.inGame = false
	goto_scene("res://Scenes/LevelsScene.tscn")
	
func goto_options_scene():
	music.inGame = false
	goto_scene("res://Scenes/OptionsScene.tscn")

func reload_level():
	goto_level(current_level)

func goto_level(level):
	music.inGame = true
	if level < MIN_LEVEL:
		goto_level(MIN_LEVEL)
	elif level <= MAX_LEVEL:
		current_level = level
		goto_scene("res://Scenes/Levels/Level" + str(level) + "Scene.tscn")
	else:
		current_level = MIN_LEVEL
		goto_credit_scene()

func goto_next_level():
	goto_level(current_level+1)

func goto_scene(path):
	print("loading " + path)
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)
	
	# Instance the new scene.
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	
	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)