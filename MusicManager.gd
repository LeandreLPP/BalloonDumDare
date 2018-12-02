extends Node

export (bool) var inGame = false

func _on_MenuPlayer_finished():
	if not inGame:
		$MenuPlayer.play()
	else:
		$MainPlayer.play()

func _on_MainPlayer_finished():
	if not inGame:
		$MenuPlayer.play()
	else:
		$MainPlayer.play()
