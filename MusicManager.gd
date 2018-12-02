extends Node

export (bool) var inGame = false

var mainCurrent = 0

func _on_MenuPlayer_finished():
	if not inGame:
		$MenuPlayer.play()
	else:
		playNextMain()

func _on_MainPlayer_finished():
	if not inGame:
		$MenuPlayer.play()
	else:
		playNextMain()

func playNextMain():
	mainCurrent += 1
	if mainCurrent > 4:
		mainCurrent = 1
	
	if mainCurrent == 1:
		$Main1Player.play()
	if mainCurrent == 2:
		$Main2Player.play()
	if mainCurrent == 3:
		$Main3Player.play()
	if mainCurrent == 4:
		$Main4Player.play()