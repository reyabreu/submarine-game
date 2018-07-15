extends Sprite

var last_flip = false

func update_sprite(velocity):
	var new_flip = velocity.x < 0 if abs(velocity.x) > 0 else last_flip
	if new_flip != last_flip:
		flip_h = new_flip
		last_flip = flip_h