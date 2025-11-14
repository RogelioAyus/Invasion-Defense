extends GPUParticles2D


var timeStart = Time.get_ticks_msec()
func _ready():
	self.process_material.initial_velocity_max = randi_range(300,1000)

	
func _process(_delta):
	if Time.get_ticks_msec() - timeStart > 500:
		queue_free()
