extends Node2D

@onready var a = $Accepted
@onready var d = $Deny
@onready var bossAudio = $BossAppears

@onready var sb = [%"0", %"1", %"2", %"3", %"4", %"5", %"6",%"7",%"8"]
@onready var cLabel = $MotherShip/motherShipLayer/confirmation
@onready var cAnim = $MotherShip/motherShipLayer/labelAnimation
@export var pauseMenu: PackedScene
@export var bossGalactic: PackedScene
@export var bossEmbryo: PackedScene
@export var bossGrave: PackedScene

#debug setting
@export var is_debugging = false;
@onready var mother_ship = $MotherShip

var pausedDelay = 0;
var datea = 0;
const enemy = "res://TSCN Scenes/enemy.tscn"
var onShopPressedOnce = false;
var iscalledOnceDial = false
var previousIndex = 0;
var iconBullets = [preload("res://sprites/icons/plasma_icon.png"),preload("res://sprites/icons/Missile icon.png"),preload("res://sprites/icons/Lazer_icon.png")]
var bST = 0 #bullet_type
var upgt = GlobalScript.upgradeTree
var pb = upgt["plasma_bullet"]
var hm = upgt["homing_missile"]
var lazr = upgt["laser"]
var cost = upgt["costOrder"]
var upNaN = {"3":[3,2,1],"4":[2,1],"5":[1],"7":[0,0,0]}

var i4bST = 0;


		

func _processData():
	upgt = GlobalScript.upgradeTree
	pb = upgt["plasma_bullet"]
	hm = upgt["homing_missile"]
	lazr = upgt["laser"]
	cost = upgt["costOrder"]
	bList = [pb,hm,lazr]

var bList = []
var bulletName = ["plasma_bullet","homing_missile","laser"]
var cB = ["pbCostBegin","hmCostBegin","lCostBegin"]
var cX = ["pbCostNext","hmCostNext","lCostNext"]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	if is_debugging:
		GlobalScript.scraps = 999999
	var enemy_node_group_count = get_tree().get_nodes_in_group("_enemy")
	for i in enemy_node_group_count:
		GlobalScript.enemy_curr += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pausedDelay -= delta;
	GlobalScript.currentTime += delta;
	

	#if GlobalScript.shiphealth <= 0:
		#died()
	#_processData()
	#iscalledOnceDial = false
	#datea += delta
	#if !GlobalScript.isBoss and datea >= 0.5 and GlobalScript.enemy_curr < GlobalScript.enemy_cap:
		#GlobalScript.enemy_curr += 1
		#datea = 0
		#var eny = preload(enemy).instantiate()
		#eny.position = spawn_circle()
		#get_tree().get_root().add_child(eny)
	#elif GlobalScript.isBoss and !GlobalScript.isBossSpawned:
		#bossAudio.play()
		#var eny;
		#if GlobalScript.stageNum in [11,21,31,41]:
			#eny = bossGalactic.instantiate()
		#elif GlobalScript.stageNum in [26]:
			#eny = bossEmbryo.instantiate()
		#elif GlobalScript.stageNum in [51]:
			#eny = bossGrave.instantiate()
		#eny.position = spawn_circle()
		#get_tree().get_root().add_child(eny)
		#GlobalScript.isBossSpawned = true;
		
	
	#if GlobalScript.isNextStage == true and iscalledOnceDial == false:
		#iscalledOnceDial = true
		#GlobalScript.isPaused = true
		#get_tree().paused = true
		#$"UI/Information HUD".next_stage.hide()
		
		#$Dialogue.setupDialogue(GlobalScript.stageDialogeDict[(GlobalScript.dialogueNum)])
	
func spawn_circle():
	var ship_pos = $MotherShip.position
	var r = 1500
	var c_x = ship_pos.x
	var c_y = ship_pos.y
	var ang = 2 * PI * randf_range(0,1)
	var x = r * cos(ang) + c_x
	var y = r * sin(ang) + c_y
	return Vector2(x,y)

func _input(event):
	if Input.is_action_just_pressed("openShop") and GlobalScript.isPressedShop == false:
		mother_ship._on_shop_pressed()
	elif GlobalScript.isPressedShop == true and Input.is_action_just_pressed("openShop"):
		_shopExit()
		
	if event.is_action("esc") and pausedDelay < 0:
		pausedDelay = 0.5
		GlobalScript.isPaused = true
		
		$pausedLayer.show()
		get_tree().paused = true
	elif event.is_action_pressed("1"):
		GlobalScript.playerStatRestart(0)
	elif event.is_action_pressed("2"):
		GlobalScript.playerStatRestart(1)
	elif event.is_action_pressed("3"):
		GlobalScript.playerStatRestart(2)
		#print(GlobalScript.bullet_type)
		


func buttonupdate(bSTz):
	if upgt["boughtHM"] and bSTz == 1:
		#print("homiing passed")
		sb[3].lvl.text = str(GlobalScript.upgradeTree[bulletName[bSTz]]["reload"])
		sb[4].lvl.text = str(GlobalScript.upgradeTree[bulletName[bSTz]]["piercing"])
		sb[7].lvl.text = str(GlobalScript.upgradeTree[bulletName[bSTz]]["damage"])
		sb[8].button.disabled = true
		sb[5].button.disabled = true
		sb[6].button_sprite.texture = iconBullets[bSTz]
	elif upgt["boughtL"] and bSTz == 2:
		#print("laser passed")
		sb[3].lvl.text = str(GlobalScript.upgradeTree[bulletName[bSTz]]["reload"])
		sb[7].lvl.text = str(GlobalScript.upgradeTree[bulletName[bSTz]]["damage"])
		
		sb[4].button.disabled = true
		sb[5].button.disabled = true
		sb[8].button.disabled = true
		sb[6].button_sprite.texture = iconBullets[bSTz]
	elif bSTz == 0:
		sb[3].lvl.text = str(GlobalScript.upgradeTree[bulletName[bSTz]]["reload"])
		sb[7].lvl.text = str(GlobalScript.upgradeTree[bulletName[bSTz]]["damage"])
		sb[5].lvl.text = str(GlobalScript.upgradeTree[bulletName[bSTz]]["speed"])
		sb[4].lvl.text = str(GlobalScript.upgradeTree[bulletName[bSTz]]["piercing"])
		#print("plasma bullet")
		sb[8].button.disabled = true
		sb[6].button_sprite.texture = iconBullets[bSTz]
	else:
		
		sb[3].button.disabled = true
		sb[4].button.disabled = true
		sb[5].button.disabled = true
		sb[7].button.disabled = true
		sb[6].button_sprite.texture = iconBullets[bSTz]
		
		
func onShopChoice(node):
	var indexShop = int(node.ID_shop);
	if onShopPressedOnce == true and previousIndex == indexShop:
		for i in sb:
			i.button.disabled = false
			i.lvl.text = ""
		# shield Regen == shield == Range == Reload == Piercing == Speed == Swap == Damage
		if indexShop == 0: #shield regem
			if GlobalScript.scraps >= 400 and GlobalScript.shipRegenShieldAmount < 10:
				GlobalScript.scraps -= 400
				GlobalScript.shipRegenShieldAmount += 0.2
				a.play()
				cLabel.text = "Upgraded"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			elif GlobalScript.shipRegenShieldAmount >= 10:
				d.play()
				cLabel.text = "MAX Reached"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			else:
				d.play()
				cLabel.text = "not enough scraps"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
		elif indexShop == 1: #shield upgrade
			if GlobalScript.scraps >= 500 and GlobalScript.shipMaxShield < 75:
				a.play()
				GlobalScript.scraps -= 500
				GlobalScript.shipMaxShield += 1
				cLabel.text = "Upgraded"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			elif GlobalScript.shipMaxShield >= 75:
				d.play()
				cLabel.text = "Max Shield upto 75"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			else:
				d.play()
				cLabel.text = "not enough scraps"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
				
		elif indexShop == 2: #range
			if GlobalScript.scraps >= 300 and GlobalScript.player_range <= 1000:
				a.play()
				GlobalScript.scraps -= 300
				GlobalScript.player_range += 100
				cLabel.text = "Range upgrade to: " + str(GlobalScript.player_range)
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			elif GlobalScript.player_range > 1000:
				d.play()
				cLabel.text = "Already MAX"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			else:
				d.play()
				cLabel.text = "not enough scraps"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
		elif indexShop == 3: #reload
			if bST == 1: i4bST = 2;
			elif bST == 2: i4bST = 1; 
			else: i4bST = 3;
			if GlobalScript.scraps > cost[cB[bST]][i4bST] and len(GlobalScript.upgradeTree[bulletName[bST]]["upgradeTier"]["reloadTier"])-1 > GlobalScript.upgradeTree[bulletName[bST]]["reload"]: # * cost[cX[bST]][i4bST]:
				a.play()
				GlobalScript.upgradeTree[bulletName[bST]]["reload"] += 1
				GlobalScript.scraps -= int(cost[cB[bST]][i4bST])
				GlobalScript.upgradeTree["costOrder"][cB[bST]][i4bST] *= cost[cX[bST]][i4bST]
				sb[3].lvl.text = str(GlobalScript.upgradeTree[bulletName[bST]]["reload"])
				
				cLabel.text = "Level up: " + str(GlobalScript.upgradeTree[bulletName[bST]]["reload"]) #debug
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			else:
				d.play()
				cLabel.text = "not enough money"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
				
		elif indexShop == 4: #piercing
			if bST == 1: i4bST = 1; 
			else: i4bST = 2;
			if GlobalScript.scraps > cost[cB[bST]][i4bST] and len(GlobalScript.upgradeTree[bulletName[bST]]["upgradeTier"]["piercingTier"])-1 > GlobalScript.upgradeTree[bulletName[bST]]["piercing"]: #* cost[cX[bST]][i4bST]:
				#print(cost[cB[bST]][i4bST] * cost[cX[bST]][i4bST])
				a.play()
				GlobalScript.upgradeTree[bulletName[bST]]["piercing"] += 1
				GlobalScript.scraps -= int(cost[cB[bST]][i4bST])
				GlobalScript.upgradeTree["costOrder"][cB[bST]][i4bST] *= cost[cX[bST]][i4bST]
				sb[4].lvl.text = str(GlobalScript.upgradeTree[bulletName[bST]]["piercing"])
				
				cLabel.text ="Level up: " + str(GlobalScript.upgradeTree[bulletName[bST]]["piercing"]) #debug
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			else:
				d.play()
				#print(cost[cB[bST]][i4bST] * cost[cX[bST]][i4bST])
				cLabel.text ="not enough money"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			
		elif indexShop == 5: #bullet speed
			if GlobalScript.scraps > cost[cB[bST]][1] and len(GlobalScript.upgradeTree[bulletName[bST]]["upgradeTier"]["speedTier"])-1 > GlobalScript.upgradeTree[bulletName[bST]]["speed"]: # * cost[cX[bST]][1]:
				GlobalScript.upgradeTree[bulletName[bST]]["speed"] += 1
				a.play()
				GlobalScript.scraps -= int(cost[cB[bST]][1])
				GlobalScript.upgradeTree["costOrder"][cB[bST]][1] *= cost[cX[bST]][1]
				sb[5].lvl.text = str(GlobalScript.upgradeTree[bulletName[bST]]["speed"])
				
				cLabel.text ="Level up: " + str(GlobalScript.upgradeTree[bulletName[bST]]["speed"]) #debug
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			else:
				d.play()
				cLabel.text ="not enough money"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			
		elif indexShop == 6: #swap bullet_type
			bST += 1
			bST = bST if bST <= 2 else 0
			buttonupdate(bST)
			return
		elif indexShop == 7: #increase bullet damage
			if GlobalScript.scraps > cost[cB[bST]][0] and len(GlobalScript.upgradeTree[bulletName[bST]]["upgradeTier"]["damageTier"])-1 > GlobalScript.upgradeTree[bulletName[bST]]["damage"]: #*cost[cX[bST]][0]:
				GlobalScript.upgradeTree[bulletName[bST]]["damage"] += 1
				a.play()
				GlobalScript.scraps -= int(cost[cB[bST]][0])
				GlobalScript.upgradeTree["costOrder"][cB[bST]][0] *= cost[cX[bST]][0]
				sb[7].lvl.text = str(GlobalScript.upgradeTree[bulletName[bST]]["damage"])
				cLabel.text ="Level up: " + str(GlobalScript.upgradeTree[bulletName[bST]]["damage"]) #debug
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
				
			else:
				d.play()
				cLabel.text ="not enough money" #debug
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
				
		elif indexShop == 8: # buy the 2 weapon made
			if !upgt["boughtHM"] and bST == 1 and GlobalScript.scraps > 500:
				a.play()
				GlobalScript.upgradeTree["boughtHM"] = true
				GlobalScript.scraps -= 500
				cLabel.text ="Change your weapon to update: homing missile" #debug
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			elif !upgt["boughtL"] and bST == 2  and GlobalScript.scraps > 200:
				a.play()
				GlobalScript.upgradeTree["boughtL"] = true
				GlobalScript.scraps -= 200
				cLabel.text ="Change your weapon to update: Laser" #debug
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
			elif (!upgt["boughtHM"] or !upgt["boughtL"]) and bST in [1,2]:
				d.play()
				cLabel.text ="not enough money"
				cAnim.play("RESET")
				cAnim.play("confirmation")
				buttonupdate(bST)
				return
		if indexShop in [3,4,5,6,7]:
			$"UI/Information HUD".upgrade_route.text = "Scraps:" + str(int(cost[cB[bST]][upNaN[str(indexShop)][bST]]))
		else:
			pass
		#onShopPressedOnce = false
		#GlobalScript.isPressedShop = false
		#$MotherShip/motherShipLayer/shopPlayerAn.play("RESET")
	else:
		$"UI/Information HUD".line_25_detail.text = GlobalScript.details[indexShop]
			
		if indexShop in [3,4,5,7]:
			$"UI/Information HUD".upgrade_route.text = "Scraps:" + str(int(cost[cB[bST]][upNaN[str(indexShop)][bST]]))
		elif indexShop == 8:
			$"UI/Information HUD".upgrade_route.text = "Buy for 500 Scraps"
		else:
			$"UI/Information HUD".upgrade_route.text = ""
		onShopPressedOnce = true
		previousIndex = indexShop

func _shopExit():
	GlobalScript.isPressedShop = false
	$MotherShip/motherShipLayer/shopPlayerAn.play_backwards("shopOpen")
	
func died():
	var enemye = get_tree().get_nodes_in_group("_enemy");
	for i in enemye:
		i.queue_free()
	var bullet = get_tree().get_nodes_in_group("_bullet");
	for i in bullet:
		i.queue_free()
	$BgMusic.stop()
	$dialogueMusic.stop()
	get_tree().change_scene_to_file("res://TSCN Scenes/game_over_scene.tscn")

