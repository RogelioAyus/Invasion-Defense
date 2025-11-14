extends Node2D

@export var gainer: PackedScene
@export var DeathParticle: PackedScene;
var boss = true
@onready var p = $dash
@onready var healthBar = $health
@onready var c = [$Asprite/red, $Asprite/blue, $Asprite/green]
var health = 5000
var maxHealth = 5000
var dead = false;
var cooldown = 8
var dash = 0
var dashwarning = 0.7
var setPos = Vector2.ZERO
var angle = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	health += (1000*GlobalScript.difficulty) + (GlobalScript.stageNum * 400)
	maxHealth = health
	self.add_to_group("_enemy")
	healthBar.max_value = maxHealth



func _process(delta):
	healthBar.value = health
		
	p.value = cooldown
	for i in c:
		#i.self_modulate = Color(randf_range(0,1),randf_range(0,1),randf_range(0,1),1)
		i.position = Vector2(randi_range(5,-5),randi_range(5,-5))
	
	var target = get_tree().get_nodes_in_group("_base")
	

	for i in target:
		var getPT = (i.position - self.position).normalized()
		angle = atan2(getPT.y,getPT.x)
	
	if cooldown > 0:
		self.position += Vector2(cos(angle)*0.6,sin(angle)*0.6)
		cooldown -= delta
		#print(cooldown)
		if cooldown < 0:
			$Dash.play()
			setPos = Vector2(cos(angle)*50,sin(angle)*50)
			dash = 0.2
	elif dash > 0 and dashwarning < 0:
		dash -= delta
		self.position += setPos
		if dash < 0:
			cooldown = 8
			dashwarning = 0.8
	elif dashwarning > 0:

		$Warn.play()
		dashwarning -= delta
		$charging.emitting = true


func _on_boss_area_area_entered(area):
	if area.name in ["bullet_area","missile_attack" ,"laserArea","explo"]:
		health -= area.damage
	if health <= 0 and !dead:
		dead = true
		death()

func death():
	var srs = 200 + (5 * GlobalScript.stageNum)
	GlobalScript.scraps += srs
	var gainX = gainer.instantiate()
	get_tree().get_root().add_child(gainX)
	gainX.spawnGainer(srs,position)
	var effectDeath = DeathParticle.instantiate()
	effectDeath.position = position
	effectDeath.emitting = true
	get_tree().current_scene.add_child(effectDeath)
	queue_free()
