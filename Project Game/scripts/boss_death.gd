extends GPUParticles2D


var timeStart = Time.get_ticks_msec()
func _ready():
	$AudioStreamPlayer.play()
	#self.process_material.initial_velocity_max = randi_range(300,1000)
	pass

	
func _process(_delta):
	if Time.get_ticks_msec() - timeStart > 5000:
		queue_free()
