extends Node2D

var dirc = Vector2(1,10)
var lifetime = randf_range(1,8);
var initiateLT = lifetime
@onready var x = $x
var health = 200
var maxHealth = 200

func _ready():
	self.add_to_group("_enemy")
	
func _process(delta):
	if health < 0:
		queue_free()
	$debug.text = str(health)
	x.scale = Vector2(lifetime/initiateLT,lifetime/initiateLT)
	position += dirc * delta * 3
	lifetime -= delta;
	if lifetime <= 0:
		death()
	
	dirc = lerp(dirc,target()*300,0.002)
	
func target():
	var base = get_tree().get_nodes_in_group("_base")
	if base.size() == 0:
		return Vector2(0,0)
	for i in base:
		var targetx = (i.position - position).normalized()
		var angle = atan2(targetx.y,targetx.x)
		return Vector2(cos(angle),sin(angle))

func setTarget():
	dirc = target()

func death():
	queue_free()



func _on_anti_bullet_area_entered(area):
	if area.name == "ship2D":
		area.get_parent().gotDamage()
		death()
	
	if area.name == "bullet_area":
		health -= area.damage
		area.get_parent().queue_free()
