extends Area2D

func _on_Spike_body_entered(body):
	print("body entered" + self.get_path_to(body))
	var p = self.get_path_to(body)
	var name = p.get_name(p.get_name_count() - 1)
	if name == "Balloon" or name.begins_with("@Balloon@"):
		var balloon = get_node(p)
		balloon.explode()
	if name == "Player" or name.begins_with("Player"):
		var player = get_node(p)
		player.die()
