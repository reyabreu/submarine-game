extends KinematicBody2D

const SCREEN_MARGIN = 100
const WOBBLE_AMPLITUDE = 8
const WOBBLE_FREQUENCY = 2

export (int) var linear_speed = 200
export (int) var player_damage = 10
export (float) var horizontal_dampening = 0.05 # units/delta
export (float) var vertical_dampening = 0.02 # units/delta

var screen_size
var dead_band
var velocity = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	dead_band = $Sprite.texture.get_size()/2 + Vector2(SCREEN_MARGIN, SCREEN_MARGIN)
	randomize()
	velocity.x = randi() % linear_speed - (linear_speed/2)

func _process(delta):
	 $Sprite.update_sprite(velocity)

func _physics_process(delta):
	_move()
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)

func _move():
	var target_velocity = Vector2()

	if velocity.x > 0:
		target_velocity.x = 1 if position.x < screen_size.x - dead_band.x else -1
	if velocity.x < 0:
		target_velocity.x = -1 if position.x > dead_band.x else 1
	if velocity.y > 0:
		target_velocity.y = 1 if position.y < screen_size.y - dead_band.y else -1
	if velocity.y < 0:
		target_velocity.y = -1 if position.y > dead_band.y else 1

	target_velocity *= linear_speed
	velocity.x = lerp(velocity.x, target_velocity.x, horizontal_dampening)
	velocity.y = lerp(velocity.y, target_velocity.y, vertical_dampening)

func player_hit(player, collision_info):
	player.apply_damage(player_damage)