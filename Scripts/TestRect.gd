extends KinematicBody2D

const FORCE_GRAVITY = 200 # pixels/s^2
const SPEED = 550 # pixels/s
const SEAFLOOR_NORMAL = Vector2(0, -1)

signal collisioninfo_change

var is_bouncing = false;
var velocity = Vector2()

func _draw():
	draw_line(Vector2(0,0), velocity.normalized()*100, ColorN("black"),  3)

func _process(delta):
	update()

func _physics_process(delta):
	update_movement(delta)

func update_movement(delta):
	#sink(delta)	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		velocity = velocity.bounce(collision_info.normal)
		if not is_bouncing:
			is_bouncing = true
			emit_signal("collisioninfo_change", is_bouncing)
	else:
		if is_bouncing and $CollisionTimer.is_stopped():
			$CollisionTimer.start()
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
	target_speed *= 0 if is_bouncing else SPEED
	
	#make linear movement smoother
	velocity.x = lerp(velocity.x, target_speed.x, 0.01)
	velocity.y = lerp(velocity.y, target_speed.y, 0.01)


func _on_CollisionTimer_timeout():
	is_bouncing = false
	emit_signal("collisioninfo_change", is_bouncing)
