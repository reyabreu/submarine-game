extends KinematicBody2D

const FORCE_GRAVITY = 200 # pixels/s^2
const SPEED = 550 # pixels/s
const SEAFLOOR_NORMAL = Vector2(0, -1)

var velocity = Vector2()

func _process(delta):
	$Sprite.update_sprite(velocity)

func _physics_process(delta):
	update_movement(delta)

func update_movement(delta):
	sink(delta)	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
	move()	
	
func sink(delta):
	velocity.y -= FORCE_GRAVITY * delta

func move():
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
	target_speed *= SPEED
	
	#make linear movement smoother
	velocity.x = lerp(velocity.x, target_speed.x, 0.1)
	velocity.y = lerp(velocity.y, target_speed.y, 0.1)
