extends Area2D

func _on_Porte_body_entered(body):
	var p = self.get_path_to(body)
	if p.get_name(p.get_name_count() - 1) == "Player":
		LevelManager.goto_next_level()
