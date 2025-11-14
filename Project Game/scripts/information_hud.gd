extends Control
@onready var audio_select = $Select/audioSelect

@onready var cool_down = $coolDown
@onready var anc = $"../../MotherShip"
@onready var anc2 = $anchor
@onready var shield = $shield
@onready var healthbar = %healthbar
@onready var next_stage = %nextStage
@onready var line_25_detail = %line25Detail
@onready var upgrade_route = %upgradeRoute
@onready var laz = [%a, %b, %c, %d, %e, %f, %g, %h, %i, %j]
@onready var shopD = $ShopDetail
@onready var diff = %difficulty
@onready var selection_p = $Select/selectionP
@onready var glir = $TextureRect

@export var arr : PackedScene
var selectList = ["select 1","select 2","select 3"]
var prevInt = 0;
var bS = ["plasma_bullet","homing_missile","laser"]
var difL = ["Sterile","Medium","Insane","Cataclysm"]
var offset = 0;

var setNode = []


# Called when the node enters the scene tree for the first time.
func _ready():
	selection_p.play("select 1")
	shopD.hide()
	next_stage.hide()
func dspawn():
	for i in setNode:
		i.hide()
		i.queue_free()
		setNode.erase(i)
func displayTyme():
	dspawn()
	arrowSpawn()
	pass

func redisplay():
	for i in range(-1,10):
		laz[i].show()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	targetUpdate()
	cool_down.value = 7 - (GlobalScript.shipDashCooldown)
	shield.max_value = GlobalScript.shipMaxShield
	if GlobalScript.bullet_type != prevInt:
		audio_select.stop()
		audio_select.play()
		prevInt = GlobalScript.bullet_type
		selection_p.play(selectList[prevInt])
	diff.text = "Difficulty: " + difL[GlobalScript.difficulty]
	if GlobalScript.isPressedShop:
		shopD.show()
	else:
		shopD.hide()
	# Reload update
	
	redisplay()
	for i in range(-1,10):
		if i >= GlobalScript.laserAmmo:
			laz[i].hide()
	#
	var type = GlobalScript.bullet_type
	var GS = GlobalScript.upgradeTree[bS[type]]
	if GlobalScript.isInStageBreak == true:
		next_stage.show()
	else:
		next_stage.hide()
	healthbar.value = GlobalScript.shiphealth
	#---player
	if !GlobalScript.isBoss:
		$Health/Enemy_count.show()
		$Health/Enemy_count.text = "Enemy Left: " + str(GlobalScript.enemy_curr-GlobalScript.enemy_killed) + "/" + str(GlobalScript.enemy_cap)
	else:
		$Health/Enemy_count.hide()
	$Health/Damage_value.text = str(GS["upgradeTier"]["damageTier"][GS["damage"]])
	
	$Health/Type.text = str(GlobalScript.player_type)
	$Score/Score_value.text = str(int(GlobalScript.score))
	var GS_s = GS["upgradeTier"]
	
	if GS_s.has("piercingTier"):
		$Health/piercing.text = str(GS["upgradeTier"]["piercingTier"][GS["piercing"]])
	else:
		$Health/piercing.text = "NULL"
	if GS_s.has("speedTier"):
		$Health/speed.text = str(GS["upgradeTier"]["speedTier"][GS["speed"]])
	else:
		$Health/speed.text = "NULL"
	$Health/reload.text = str(GS["upgradeTier"]["reloadTier"][GS["reload"]])
	#shield-------------
	$shield.value = int(GlobalScript.shipShieldHealth)
	$shield.max_value = GlobalScript.shipMaxShield
	$shield/shieldLabel.text = str(int(GlobalScript.shipShieldHealth)) + "/" + str(GlobalScript.shipMaxShield)
	offset = Vector2(GlobalScript.shipShieldHealth,GlobalScript.shipMaxShield)
	glir.material.set_shader_parameter("offset",
		randi_range(
			2-((offset.x/offset.y)*2),
			10-((offset.x/offset.y)*10)
			)
		)
	$ShipHealth.text = str(GlobalScript.shiphealth)
	$shieldRegenStatus.max_value = GlobalScript.shipShieldRegenDelayMax
	$shieldRegenStatus.value = GlobalScript.shipShieldRegenDelayMax - GlobalScript.shipShieldRegenDelay
	
	#--------resource and stage
	$Resources/scrap_value.text = str(GlobalScript.scraps)
	$Resources/energy_value.text = str(GlobalScript.energy)
	%galaxyInfo.text = "Wave: " + str(GlobalScript.stageNum-1)
	$nextStage.value = GlobalScript.stageBreakFloat

func spawn_circle(pos,ang,ang2):
	var ship_pos = pos
	var r = 100
	var c_x = ship_pos.x
	var c_y = ship_pos.y
	var x = r * ang + c_x
	var y = r * ang2 + c_y
	return Vector2(x,y)

func arrowSpawn():
	var baseEn = get_tree().get_nodes_in_group("_enemy")
	for i in baseEn:
		var newAr = arr.instantiate()
		setNode.append(newAr)
		get_parent().add_child(newAr)
		var a = target(i.position,anc.global_position)
		newAr.position = spawn_circle(anc2.global_position,cos(a),sin(a))
		newAr.rotation = a
		newAr.self_modulate = Color(1,1,1,((i.position.distance_to(anc.global_position)-1000)/(4000-1000)))
		#print(i.position.distance_to(anc2.global_position))
	$debug.text = str(baseEn.size()) + "/" + str(baseEn)
	
	#made an enemy indicator. Solve arrow assistment

func target(a,b):
	var targetx = (a - b).normalized()
	var angle = atan2(targetx.y,targetx.x)
	return angle

func targetUpdate():
	var a = GlobalScript.enemyTargetedNode
	if a != null and a.health > 0:
		$eTarHealth.modulate = Color(1,1,1,1)
		$eTarHealth.max_value = a.maxHealth
		$eTarHealth.value = a.health
		$eTarHealth/Label.text = str(a.health) + "/" + str(a.maxHealth)
	else:
		$eTarHealth.modulate = Color(1,1,1,0)
