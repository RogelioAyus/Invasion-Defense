extends CharacterBody2D

@onready var timer = $Timer

@export var gainer: PackedScene;
@export var DeathParticle: PackedScene;
@export var bulletScene: PackedScene;
@export var laserScene: PackedScene;
var limit_sed = 50;
var health = 25;
var maxHealth = 25;
var speedUpValue = 4
var type_list = ["Red","Armor","Coiez","Helepor","Abaso"]
var type: int = 0;
var death = false;
var scrapsVal: int;
var hit = 0;
var gotHitDir;
var spawningAnimationDelay = 0.5

var laserCurr;
#debug
var count = 0
func _ready():
	if GlobalScript.isLowQualityMode:
		$"spawn effect".hide()
	$shieldAnchor.hide()
	$"Enemy AnimBase".hide()
	$Shield.hide()

	$respawn.play()
	$"spawn effect".emitting = true
	if GlobalScript.stageNum >= 50:
		type = randi_range(0,4)
	elif GlobalScript.stageNum >= 41:
		type = randi_range(1,4)
	elif GlobalScript.stageNum >= 31:
		type = randi_range(3,4)
	elif GlobalScript.stageNum >= 26:
		type = randi_range(1,3)
	elif GlobalScript.stageNum >= 21:
		type = randi_range(1,2)
	elif GlobalScript.stageNum >= 11:
		type = randi_range(0,1)
	else:
		type = 0
	health += int(int(GlobalScript.stageNum) + (0.85 * type))* (1 + (GlobalScript.difficulty*8))
	maxHealth = health
	$"Enemy AnimBase".animation = type_list[type]
	$"Enemy AnimBase".play()
	scrapsVal = int((type+8) + 4 * ((GlobalScript.stageNum)/10)) + GlobalScript.difficulty * 2
	self.add_to_group("_enemy")
	match type: #setup a fire here
		1:
			$Timer.start()
		2:
			$fasterTimer.start()
		3:
			$timerLaser.start()
		4:
			$shieldAnchor.show()
			$timerSlowerLaser.start()
			$shieldAnchor/ost.monitoring = true
			$shieldAnchor/ost2.monitoring = true
			$shieldAnchor/ost4.monitoring = true
			$shieldAnchor/ost5.monitoring = true

func spawnlaser():
	laserCurr = laserScene.instantiate()
	laserCurr.position = position
	get_tree().get_root().add_child(laserCurr)
	laserCurr.setAngle()

func spawnbullet():
	var summon = bulletScene.instantiate()
	summon.position = position
	get_tree().get_root().add_child(summon)
	summon.callOnTarget()
	

func _physics_process(delta):
	if spawningAnimationDelay <= 0:
		$"Enemy AnimBase".show()
		$Shield.show()
	else:
		spawningAnimationDelay -= delta
	hit -= delta
	match type:
		0:
			if !death:
				var base = get_tree().get_nodes_in_group("_base")
				if hit <= 0:
					for i in base:
						var target = (i.position - position).normalized()
						var angle = atan2(target.y,target.x)
						velocity = Vector2(limit_sed * cos(angle),limit_sed * sin(angle))
						limit_sed += speedUpValue * delta
						move_and_slide()
				elif hit > 0:
					velocity = -Vector2(cos(gotHitDir)*600*hit,sin(gotHitDir)*600*hit)
		1:
			if !death:
				var base = get_tree().get_nodes_in_group("_base")
				if hit <= 0:
					for i in base:
						var target = (i.position - position).normalized()
						var angle = atan2(target.y,target.x)
						velocity = Vector2(limit_sed/2 * cos(angle),limit_sed/2 * sin(angle))
						limit_sed += delta
						move_and_slide()
				elif hit > 0:
					velocity = -Vector2(cos(gotHitDir)*600*hit,sin(gotHitDir)*600*hit)
		2:
			if !death:
				var base = get_tree().get_nodes_in_group("_base")
				if hit <= 0:
					for i in base:
						var target = (i.position - position).normalized()
						var angle = atan2(target.y,target.x)
						velocity = Vector2(limit_sed/3 * cos(angle),limit_sed/3 * sin(angle))
						limit_sed += delta
						move_and_slide()
				elif hit > 0:
					velocity = -Vector2(cos(gotHitDir)*600*hit,sin(gotHitDir)*600*hit)
		3:
			if !death:
				var base = get_tree().get_nodes_in_group("_base")
				if hit <= 0:
					for i in base:
						var target = (i.position - position).normalized()
						var angle = atan2(target.y,target.x)
						velocity = Vector2(cos(angle),sin(angle))
						move_and_slide()
				elif hit > 0:
					velocity = -Vector2(cos(gotHitDir)*600*hit,sin(gotHitDir)*600*hit)
		4:
			$shieldAnchor.rotation = lerp_angle($shieldAnchor.rotation,rotateShield(),0.02)
			if !death:
				var base = get_tree().get_nodes_in_group("_base")
				if hit <= 0:
					for i in base:
						var target = (i.position - position).normalized()
						var angle = atan2(target.y,target.x)
						velocity = Vector2(cos(angle),sin(angle))
						move_and_slide()
				elif hit > 0:
					velocity = -Vector2(cos(gotHitDir)*600*hit,sin(gotHitDir)*600*hit)
			
			
	if spawningAnimationDelay > 0:
		velocity = Vector2.ZERO
	move_and_slide()
			#$Label.text = str(int(limit_sed)) + "\nHealth: " + str(health) + "\n" + str(type)
	$health.value = health
	$health.max_value = maxHealth
	$health/hLab.text = str(health) + "/" + str(maxHealth)
	

func _on_area_area_entered(area):
	#print(area.name)
	#if area.name == "bullet_area" or area.name == "missile_attack" or area.name == "laserArea" or area.name == "explo":
	if area.name in ["bullet_area","missile_attack","explo"]:
		$animate.stop(false)
		$animate.play("hurt")
		count += 1
		health -= area.damage
		GlobalScript.score += (float(area.damage)/10) * (1 + GlobalScript.difficulty)
	elif area.name == "ship2D":
		hit = 1
		health -= health/2 +7
		var getPT = (area.pos - self.position).normalized()
		var angle = atan2(getPT.y,getPT.x)
		gotHitDir = angle
	elif area.name == "laserArea":
		$animate.stop(false)
		$animate.play("hurt")
		count += 1
		health -= area.damage
		GlobalScript.score += (float(area.damage)/10) * (1 + GlobalScript.difficulty)
		
	if health <= 0 and !death:
		death = true
		GlobalScript.scraps += scrapsVal
		spawnGainer(scrapsVal)
		GlobalScript.score += GlobalScript.stageNum * (1 + GlobalScript.difficulty)
		deathonscene()
		
		
func spawnGainer(amount):
	var a = gainer.instantiate()
	get_tree().get_root().add_child(a)
	a.position = self.global_position
	a.changeText(str(amount) + "+")
	a.play()
	
func deathonscene() -> void:
	if laserCurr != null:
		laserCurr.stopE()
	GlobalScript.enemy_killed += 1
	self.remove_from_group("_enemy")
	$enemy_area.set_deferred("monitorable", false)
	$enemy_area.set_deferred("monitoring", false)
	var _part = DeathParticle.instantiate()
	_part.position = position
	_part.emitting = true
	self.modulate = Color(0,0,0,0)
	get_tree().current_scene.add_child(_part)
	self.position = Vector2(-9999,-9999)
	$death.pitch_scale = randf_range(0.2,0.9)
	$death.play()
	await $death.finished
	queue_free()



func _shield_detection(area):
	area.get_parent().clearBullet()

func rotateShield():
		var targetx = (get_global_mouse_position() - position).normalized()
		var angle = atan2(targetx.y,targetx.x)
		return angle
