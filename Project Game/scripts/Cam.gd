extends Camera2D


var inital_zoom = Vector2(0.5,0.5)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	zoom = lerp(zoom,inital_zoom,0.03)

func _input(event):
	if event.is_action_pressed("scrollout") and inital_zoom.x <= 1:
		inital_zoom.x += 0.05
		inital_zoom.y += 0.05
	if event.is_action_pressed("scrollin") and inital_zoom.x >= 0.5:
		inital_zoom.x -= 0.05
		inital_zoom.y -= 0.05
