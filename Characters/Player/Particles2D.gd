extends Particles2D

func update_particles(velocity):
	emitting = velocity.length() > 100