extends Node2D
@onready var _0 = $"main/0"
@onready var _1 = $"main/1"

var addVel = 300
var t = 0
var sTarget;
func callOnTarget():
	sTarget = target()
func _process(delta):
	if sTarget != null:
		position += sTarget * delta * (100+addVel*2)
	addVel = max(0,300 - (300 * (t/3)))
	t += delta
	_0.position = Vector2(randi_range(-4,4),randi_range(-4,4))
	_1.position = Vector2(randi_range(-4,4),randi_range(-4,4))


func target():
	var base = get_tree().get_nodes_in_group("_base")
	if base == null:
		return Vector2.ZERO
	for i in base:
		var targetx = (i.position - position).normalized()
		var angle = atan2(targetx.y,targetx.x)
		return Vector2(cos(angle),sin(angle))


func death():
	queue_free()
	


func _on_enemy_area_area_entered(area):
	area.get_parent().gotDamage(1*GlobalScript.difficulty)
	death()
