extends Node2D


@onready var s = $s


@onready var info = %info
const bullet_tscn = preload("res://TSCN Scenes/bullet.tscn")
const missile_tscn = preload("res://TSCN Scenes/missile.tscn")
const laser = preload("res://TSCN Scenes/laser.tscn")
const typeList = [bullet_tscn,missile_tscn,laser]
var enemy_target = false;
var bullDelay = 0
var rotation_degre;
var forceStopFire: bool = false

var gs = GlobalScript.upgradeTree


@export var isGameOn = true;
# Called when the node enters the scene tree for the first time.
func _ready():
	if isGameOn:
		s.show()
	else:
		s.hide()
	#$Control.modulate = Color(1,1,1,1)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	forceToStopFire()
	s.max_value = GlobalScript.player_bullet_delay
	s.value = bullDelay
	bullDelay += delta
	var pos_cursor = get_global_mouse_position()
	if isGameOn:
		position = lerp(position, pos_cursor, 0.07)
	else:
		position = pos_cursor
	var enemy = get_tree().get_nodes_in_group("_enemy")
	var closest_dist = INF
	var close_enemy = null
	
	if enemy_target and bullDelay >= GlobalScript.player_bullet_delay and isGameOn and GlobalScript.isPaused == false and (GlobalScript.bullet_type == 1 and gs["boughtHM"] or GlobalScript.bullet_type == 2 and gs["boughtL"] and GlobalScript.laserAmmo > 0 or GlobalScript.bullet_type == 0) and !forceStopFire:
		if Input.is_action_pressed("left_mouse") and GlobalScript.bullet_type in [1,2]:
			$audio.play()
			bullDelay = 0;
			bullet_spawn(position,rotation_degre)
		elif GlobalScript.bullet_type == 0:
			$audio.play()
			bullDelay = 0;
			bullet_spawn(position,rotation_degre)
		
	for i in enemy:
		var dista = self.position.distance_to(i.position)
		if dista < closest_dist:
			closest_dist = dista
			close_enemy = i
		
	if closest_dist != null and closest_dist <= GlobalScript.player_range and isGameOn and GlobalScript.isPaused == false:
		enemy_target = close_enemy
		GlobalScript.enemyTargetedNode = close_enemy
		var direction_to_closest_enemy = close_enemy.position - self.position
		rotation_degre = atan2(direction_to_closest_enemy.y, direction_to_closest_enemy.x)
		$Sprite2D.rotation = rotation_degre + 1.5
	else:
		enemy_target = false;
		$Sprite2D.rotation = 5.5
	$Sprite2D/green.position = Vector2(randf_range(-10,10),randf_range(-10,10))
	$Sprite2D/red.position = Vector2(randf_range(-10,10),randf_range(-10,10))
	$Sprite2D/blue.position =  Vector2(randf_range(-10,10),randf_range(-10,10))
	$Sprite2D.self_modulate = Color(1,1,1,randf_range(0,1))
	
func bullet_spawn(pos,dir):
	var bullet_scene_on = typeList[GlobalScript.bullet_type].instantiate()
	
	bullet_scene_on.position = pos
	if GlobalScript.bullet_type in [0,2]: 
		bullet_scene_on.set_direction(dir)
	get_tree().get_root().add_child(bullet_scene_on)
	if GlobalScript.bullet_type == 2:
		GlobalScript.laserAmmo -= 1


func forceToStopFire():
	var getFinalBoss = get_tree().get_nodes_in_group("_finalboss")
	for i in getFinalBoss:
		var distance = self.position.distance_to(i.position)
		if distance < 560 and i.shieldenable == true:
			forceStopFire = true
		else:
			forceStopFire = false
