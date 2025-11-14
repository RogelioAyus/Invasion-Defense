extends Node2D
var GlobalS = GlobalScript.upgradeTree["plasma_bullet"]
var piercing = GlobalS["upgradeTier"]["piercingTier"][GlobalS["piercing"]] 
var damage = GlobalS["upgradeTier"]["damageTier"][GlobalS["damage"]] 
var bullet_speed;
var lifetime = 3;
var x = 0;
var y = 0;
var dir_tre
var sprite_turn = 0;

#debug

func _ready():
	self.add_to_group("_bullet")
	GlobalS = GlobalScript.upgradeTree["plasma_bullet"]
	piercing = GlobalS["upgradeTier"]["piercingTier"][GlobalS["piercing"]] 
	damage = GlobalS["upgradeTier"]["damageTier"][GlobalS["damage"]] 
	bullet_speed = GlobalS["upgradeTier"]["speedTier"][GlobalS["speed"]]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		clearBullet()
	sprite_turn += delta*10;
	if sprite_turn >= 360:
		sprite_turn -= 360;
	$S.rotation = sprite_turn
	position += Vector2(x * delta * bullet_speed,y * delta * bullet_speed)
	$red.position = Vector2(randf_range(5,-5),randf_range(5,-5))
	$green.position = Vector2(randf_range(5,-5),randf_range(5,-5))
	$blue.position = Vector2(randf_range(5,-5),randf_range(5,-5))

func clearBullet():
	queue_free()

func set_direction(value):
	dir_tre = value
	x = cos(dir_tre)
	y = sin(dir_tre)




func _on_area_area_entered(area):
	if area.name == "enemy_area":
		if piercing >= 1:
			piercing -= 1;
			return
		else:
			clearBullet()
