extends CharacterBody2D

var lifetime = 5;
var limit_velocity = 1300
var GlobalS = GlobalScript.upgradeTree["homing_missile"]
var piercing = GlobalS["upgradeTier"]["piercingTier"][GlobalS["piercing"]]
var damage = GlobalS["upgradeTier"]["damageTier"][GlobalS["damage"]]
const prls = preload("res://TSCN Scenes/explosion_missile.tscn")
var exploding = false



func explodingCall():
	exploding = true
func _ready():
	self.add_to_group("_bullet")
	GlobalS = GlobalScript.upgradeTree["homing_missile"]
	damage = GlobalS["upgradeTier"]["damageTier"][GlobalS["damage"]]
	piercing = GlobalS["upgradeTier"]["piercingTier"][GlobalS["piercing"]]
	
func _physics_process(delta):
	
	lifetime -= delta;
	if lifetime < 0:
		afterDeath()
	var enlist = get_tree().get_nodes_in_group("_enemy")
	var distance_closest = INF;
	var enemy_closest = null
	
	for i in enlist:
		var dista = self.position.distance_to(i.position)
		if dista < distance_closest:
			distance_closest = dista
			enemy_closest = i
	
	if enemy_closest != null and exploding == false:
		var distance = enemy_closest.position - self.position
		var dr = atan2(distance.y,distance.x)
		self.rotation = dr
		var dis_limit = max(min(sqrt(distance.x**2+distance.y**2),50),0)
		distance.x = dis_limit * cos(dr)
		distance.y = dis_limit * sin(dr)
		velocity += distance
	elif exploding == true:
		velocity.x = 0
		velocity.y = 0
	else:
		velocity.x = move_toward(velocity.x, 0, 20)
		velocity.y = move_toward(velocity.y, 0, 20)
	move_and_slide()


func _on_missile_attack_area_entered(area):
	if area.name == "enemy_area":
		if piercing >= 1:
			piercing -= 1
			return
		else:
			afterDeath()

func afterDeath():
	var expwa = prls.instantiate()
	expwa.position = self.position
	get_parent().call_deferred("add_child",expwa)
	queue_free()

func clearBullet():
	afterDeath()
