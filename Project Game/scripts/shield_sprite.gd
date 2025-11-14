extends Sprite2D


var ang = 0;
var ranspeed = randi_range(-6,6)
var BubbleList = ["res://sprites/Bubble1.png", "res://sprites/Bubble2.png", "res://sprites/Bubble3.png", "res://sprites/Bubble4.png", "res://sprites/Bubble5.png"]
func _ready():
	texture = ResourceLoader.load(BubbleList.pick_random())
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ang += delta * ranspeed;
	if ang > 360:
		ang = 0;
	rotation = ang;
