extends Node2D

@export var enemyScene: PackedScene;
@export var DeathParticle: PackedScene;
var shieldenable = true
@export_category("Manual")
@export var anti_missile: PackedScene;
var death = false
var shootCooldown = 0.8
var shield_duration = 10
var sd_in = 10
var vulnerable_state = 6
var vs_in = 0
var limit_sed = 100
@export var health = 100000
var maxHealth = 100000

var summonStage = 0
@onready var pb= $ProgressBar
@onready var la = $ProgressBar/Label
@onready var stop_fire = $stopFire
@onready var shieldt = $Sprite2D
@onready var shield = $shield
@onready var vulnerable = $vulnerable

	
func _process(delta):
	$Asprite.rotation = lerp_angle($Asprite.rotation, targetRotation()+1.5, 0.001)
	$g.rotation = $Asprite.rotation
	$g2.rotation = $Asprite.rotation
	$graveArea.rotation = $Asprite.rotation
	if health <= 75000 and summonStage == 0:
		summonStage += 1
		summonEnemy(10)
	elif health <= 60000 and summonStage == 1:
		summonStage += 1
		summonEnemy(20)
	elif health <= 50000 and summonStage == 2:
		summonStage += 1
		summonEnemy(30)
	elif health <= 45000 and summonStage == 3:
		summonStage += 1
		summonEnemy(40)
	elif health <= 25000 and summonStage == 4:
		summonStage += 1
		summonEnemy(50)
	elif health <= 15000 and summonStage == 5:
		summonStage += 1
		summonEnemy(60)
	elif health <= 10000 and summonStage == 6:
		summonStage += 1
		summonEnemy(70)
	elif health <= 5000 and summonStage == 7:
		summonStage += 1
		summonEnemy(80)
	
	match summonStage:
		1:
			$g.position.x = randf_range(-30,30)
			$g2.position.x = randf_range(-1,0)
			$g.self_modulate = Color(1,0,0,0.1)
			$g2.self_modulate = Color(1,0,0,0.1)
		2:
			$g.position.x = randf_range(-30,30)
			$g2.position.x = randf_range(-1,0)
			$g.self_modulate = Color(1,0,0,0.1)
			$g2.self_modulate = Color(1,0,0,0.1)
		3:
			$g.position.x = randf_range(-30,30)
			$g2.position.x = randf_range(-4,0)
			$g.self_modulate = Color(1,0,0,0.3)
			$g2.self_modulate = Color(1,0,0,0.3)
		4:
			$g.position.x = randf_range(-30,30)
			$g2.position.x = randf_range(-4,0)
			$g.self_modulate = Color(1,0,0,0.3)
			$g2.self_modulate = Color(1,0,0,0.3)
		5:
			$g.position.x = randf_range(-20,20)
			$g2.position.x = randf_range(-8,0)
			$g.self_modulate = Color(1,0,0,0.5)
			$g2.self_modulate = Color(1,0,0,0.5)
		6:
			$g.position.x = randf_range(-20,20)
			$g2.position.x = randf_range(-8,0)
			$g.self_modulate = Color(1,0,0,0.5)
			$g2.self_modulate = Color(1,0,0,0.5)
		7:
			$g.position = Vector2(randf_range(-30,30),randf_range(-30,30))
			$g2.position = Vector2(randf_range(-30,30),randf_range(-30,30))
			$g.self_modulate = Color(1,0,0,0.8)
			$g2.self_modulate = Color(1,0,0,0.8)
		8:
			$g.position = Vector2(randf_range(-80,80),randf_range(-80,80))
			$g2.position = Vector2(randf_range(-30,30),randf_range(-30,30))
			$g.self_modulate = Color(1,0,0,1)
			$g2.self_modulate = Color(1,0,0,1)
		
	if health < 0:
		deatheff()
	stateShield(delta)
	pb.value = health
	la.text = str(health) + "/" + str(maxHealth)
	if shootCooldown <= 0:
		shootCooldown = 0.8
		spawn_anti()
	else:
		shootCooldown -= delta
func _ready():
	self.add_to_group("_enemy");
	self.add_to_group("_finalboss");

func stateShield(delta):
	shield.value = sd_in
	vulnerable.value = vs_in
	if vs_in <= 0:
		shieldenable = true
		shieldt.show()
		if sd_in <= 0:
			vs_in = vulnerable_state
			shieldt.hide()
			shieldenable = false
			return
		elif sd_in > 0:
			sd_in -= delta
	elif vs_in > 0:
		vs_in -= delta
		sd_in = shield_duration

func _on_grave_area_area_entered(area):
	var par = area.get_parent()
	if par.is_in_group("_bullet") and !death:
		health -= area.damage
		if par.name != "laser":
			par.queue_free()

func summonEnemy(unit):
	$hurt.play()
	for i in range(unit):
		var enemyv = enemyScene.instantiate()
		get_tree().get_root().add_child(enemyv)
		enemyv.position = spawn_circle()

func target():
	var base = get_tree().get_nodes_in_group("_base")
	if base == []:
		return
	for i in base:
		var targetz = (i.position - position).normalized()
		var angle = atan2(targetz.y,targetz.x)
		return Vector2(limit_sed * cos(angle),limit_sed * sin(angle))

func targetRotation():
	var base = get_tree().get_nodes_in_group("_base")
	if base == []:
		return 0
	for i in base:
		var targetz = (i.position - position).normalized()
		var angle = atan2(targetz.y,targetz.x)
		return angle

func spawn_anti():
	var anti_missile_set = anti_missile.instantiate()
	get_tree().get_root().add_child(anti_missile_set)
	anti_missile_set.position = position
	anti_missile_set.setTarget()

func deatheff():
	var effectDeath = DeathParticle.instantiate()
	effectDeath.position = position
	effectDeath.emitting = true
	get_tree().current_scene.add_child(effectDeath)
	queue_free()

func spawn_circle():
	var ship_pos = position
	var r = 500
	var c_x = ship_pos.x
	var c_y = ship_pos.y
	var ang = 2 * PI * randf_range(0,1)
	var x = r * cos(ang) + c_x
	var y = r * sin(ang) + c_y
	return Vector2(x,y)
