extends CanvasLayer

onready var message_label = $MessageLabel
onready var message_timer = $MessageTimer
onready var start_button = $StartButton
onready var health_bar = $HealthBar

signal start_game 

func _ready():
	message_timer.connect("timeout", self, "_on_MessageTimer_timeout")

func set_health(health):
	health_bar.value = health

func showMessage(text):
	message_label.text = text
	message_label.show()
	message_timer.start()

func _on_MessageTimer_timeout():
	message_label.hide()

func show_game_over():
	showMessage("Game Over")
	yield(message_timer, "timeout")
	start_button.show()
	message_label.text = "Submarine Game"
	message_label.show()

func _on_Button_pressed():
	start_button.hide()
	emit_signal("start_game")
