extends Node2D

var data = GlobalScript.upgradeTree["laser"]
var damage = data["upgradeTier"]["damageTier"][data["damage"]]

func _ready():
	self.add_to_group("_bullet")
	$AnimationPlayer.play("fire")
	
func _process(_delta):
	data = GlobalScript.upgradeTree["laser"]
	damage = data["upgradeTier"]["damageTier"][data["damage"]]

func delete():
	queue_free()

func set_direction(value = 0):
	self.rotation = value
