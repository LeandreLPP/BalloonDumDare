extends Area2D

signal pressed

func _on_BalloonSwitch_body_entered(body):
	var p = self.get_path_to(body)
	p = p.get_name(p.get_name_count() - 1)
	if p == "Balloon" or p.begins_with("@Balloon@"):
		emit_signal("pressed")
		$AnimatedSprite.play("on")
		$Sound.play()
