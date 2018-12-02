extends Area2D

export(NodePath) var player
onready var real_player = get_node(player)

func _on_DeathLine_body_entered(body):
	if body == real_player:
		LevelManager.reload_level()
