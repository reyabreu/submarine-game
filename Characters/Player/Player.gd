extends KinematicBody2D

const FORCE_BUOYANCY = 60 # pixels/s^2
# const SPEED = 550 # pixels/s
# const SEAFLOOR_NORMAL = Vector2(0, -1)

export (int) var linear_speed = 550  # pixels/s
export (float) var movement_dampening = 0.1 # units/delta
export (int) var health = 100 setget set_health, get_health

var velocity = Vector2()
var is_colliding = false

signal start_collision
signal stop_collision
signal damage_taken
signal health_emptied

func set_health(value):
	health = value if value >= 0 else 0;

func get_health():
	return health

func apply_damage(damage):
	health -= damage
	emit_signal("damage_taken")
	if health <= 0:
		emit_signal("health_emptied")

func _process(delta):
	if not is_colliding:
		$Sprite.update_sprite(velocity)
	$Particles2D.update_particles(velocity)

func _physics_process(delta):
	_update_movement(delta)

func _update_movement(delta):
	_buoyancy(delta)	
	_propulsion_and_collisions(delta)
	_move()	
	
func _buoyancy(delta):
	velocity.y -= FORCE_BUOYANCY * delta

func _propulsion_and_collisions(delta):
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		_notify_start_collision(collision_info)
	else:
		_start_collision_timer()

func _move():
	# capture user input
	var move_right = Input.is_action_pressed("ui_right")
	var move_left = Input.is_action_pressed("ui_left")
	var move_up = Input.is_action_pressed("ui_up")
	var move_down = Input.is_action_pressed("ui_down")
	
	# maximum speed achievable
	var target_speed = Vector2()
	
	if move_right:
		target_speed.x += 1 
	if move_left:
		target_speed.x -= 1

	if move_down:
		target_speed.y += 1 
	if move_up:
		target_speed.y -= 1	
	
	#integrate speed
	target_speed *= 0 if is_colliding else linear_speed
	
	#make linear movement smoother
	velocity.x = lerp(velocity.x, target_speed.x, movement_dampening)
	velocity.y = lerp(velocity.y, target_speed.y, movement_dampening)

func _notify_start_collision(collision_info):
	if not is_colliding:
		is_colliding = true
		emit_signal("start_collision")
		if collision_info.collider.has_method("player_hit"):
			collision_info.collider.player_hit(self, collision_info)		

func _start_collision_timer():		
	if is_colliding and $CollisionTimer.is_stopped():
		$CollisionTimer.start()

func _notify_stop_collision():
	is_colliding = false
	velocity = Vector2()
	emit_signal("stop_collision")
	
func _on_CollisionTimer_timeout():
	_notify_stop_collision()
	