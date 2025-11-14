extends Node2D



	
func _on_enemy_area_laza_area_entered(area):
	area.get_parent().gotDamage(2*GlobalScript.difficulty)



func setAngle():
	var base = get_tree().get_nodes_in_group("_base")
	if base == null:
		return Vector2.ZERO
	for i in base:
		var target = (i.position - position).normalized()
		var angle = atan2(target.y,target.x)
		rotation = angle
		$ap.play("attack")

func stopE():
	$ap.stop()
	$loading.stop()
	$fire.stop()
	queue_free()
