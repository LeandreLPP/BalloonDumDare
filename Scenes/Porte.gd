extends Area2D

export (NodePath) var PLAYER

func _on_Porte_body_entered(body):
	if self.get_path_to(body) == PLAYER:
		LevelManager.goto_next_level()
