extends Area2D

signal pressed
signal released

func _on_PressurePlate_body_entered(body):
	var p = self.get_path_to(body)
	if p.get_name(p.get_name_count() - 1) == "Player":
		emit_signal("pressed")

func _on_PressurePlate_body_exited(body):
	var p = self.get_path_to(body)
	if p.get_name(p.get_name_count() - 1) == "Player":
		emit_signal("released")
