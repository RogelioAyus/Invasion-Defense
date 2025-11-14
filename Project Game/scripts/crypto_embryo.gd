extends Node2D
#graphic
@export var gainer: PackedScene
@export var bulletE: PackedScene;
@export var DeathParticle: PackedScene;
@onready var inner = $sprite/inner
@onready var outer = $sprite/outer
@onready var red = $sprite/outer/red
@onready var green = $sprite/outer/green
@onready var blue = $sprite/outer/blue
@onready var health_bar = $health
@onready var shield_bar = $shieldBar
@onready var regenBar = $regen
@onready var anime = $anime

#variables
var boss = true;
var health = 0
var shield = 0
var maxHealth = 5000
var maxS = 2500
var isShieldDown = false
var regen = 0
var death = false

var cooldown = 0.4
var cl = 0
var isPlayed = false
var is_target_found = false
var angle = 0;

func find_angle_once():
	if !is_target_found:
		is_target_found = true
		var player = get_tree().get_nodes_in_group("_base")[0]
		var new_distance = (player.position - position).normalized()
		var new_angle = atan2(new_distance.y,new_distance.x)
		angle = new_angle
	
func playSoundOnce():
	if isPlayed == false:
		isPlayed = true
		$shielddown.play()
	
func diffApply():
	maxHealth += GlobalScript.difficulty * 450
	maxS += GlobalScript.difficulty * 300
	health = maxHealth
	shield = maxS
	health_bar.max_value = maxHealth
	shield_bar.max_value = maxS
	regenBar.max_value = 7
	
func _ready():
	diffApply()
	self.add_to_group("_enemy")

func _process(delta):
	if isShieldDown:
		playSoundOnce()
		find_angle_once()
		var player1 = get_tree().get_nodes_in_group("_base")[0]
		var new_location = Vector2(player1.position.x + cos(angle)*-1000,player1.position.y + sin(angle)*-1000)
		position = lerp(position,new_location,0.05)
		angle += 1 * delta
		if cl < 0:
			cl = cooldown
			var but = bulletE.instantiate()
			get_tree().get_root().add_child(but)
			but.position = position
			but.callOnTarget()
		else:
			cl -= delta
		
	health_bar.value = health
	shield_bar.value = shield
	regenBar.value = regen
	if isShieldDown and regen < 7:
		regen += delta
		if regen >= 7:
			is_target_found = false
			isPlayed = false
			$anime.play("shieldUp")
			isShieldDown = false
			shield = maxS
			regen = 0
	inner.rotation += 2 * delta
	outer.rotation -= 1 * delta
	for i in [red,green,blue]:
		i.position = Vector2(randi_range(-9,9),randi_range(-9,9))
		
	var player = get_tree().get_nodes_in_group("_base")
	if !death:
		var dir = (player[0].position - self.position).normalized()
		var angleG = atan2(dir.y,dir.x)
		position += Vector2(cos(angleG)*1,sin(angleG)*1)


func _on_shield_area_entered(area):
	var par = area.get_parent()
	if par.is_in_group("_bullet") and !death:
		if shield <= 0:
			if !isShieldDown:
				$anime.play("shieldDown")
				isShieldDown = true
			health -= par.damage
			if health <= 0 and !death:
				death = true
				deathProc()
		else:
			shield -= par.damage
		par.queue_free()

func deathProc():
	GlobalScript.scraps += 400
	var gainX = gainer.instantiate()
	get_tree().get_root().add_child(gainX)
	gainX.spawnGainer(400,position)
	var effectDeath = DeathParticle.instantiate()
	effectDeath.position = position
	effectDeath.emitting = true
	get_tree().current_scene.add_child(effectDeath)
	queue_free()
