extends Node2D

func _on_HUD_start_game():
	$Player.set_health(100)
	$HUD.set_health($Player.get_health())
	$Player.show()
	$HUD.showMessage("get ready!")

func _on_Player_damage_taken():
	$HUD.set_health($Player.get_health())

func _on_Player_health_emptied():
	$Player.hide()
	$HUD.show_game_over()