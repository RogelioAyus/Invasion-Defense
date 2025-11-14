extends Sprite2D

var fade = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.self_modulate = Color(1,1,1,fade)
	fade -= delta * 2
	if fade <= 0:
		queue_free()
