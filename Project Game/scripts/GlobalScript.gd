extends Node

#Global variables
#---Player vars--------
@export var bullet_type = 0
var namePlayer: String;
var studentID: String;

var currentTime = 0;
var music_volume = 0
var sound_volume = 0

@export var player_range = 200;
#-----health

@export_category("health")
@export var shiphealth = 50
@export var shipShieldHealth = 10
@export var shipMaxShield = 10
@export var shipShieldRegenDelay = 15
@export var shipShieldRegenDelayMax = 15
@export var shipRegenShieldAmount = 0.8
@export var isHitOnShip: bool = false
var shipDashCooldown = 0;
#-----damage
@export var player_damage = 2
@export var player_bullet_delay = 0.16
var player_type = "Plasma Bullet"

#-----------world vars------------
var enemyTargetedNode;
@export var score: float = 0;
#@export var level_stage = 1;
@export var scraps = 500;
@export var energy = 0;
var tournament = false
var laserAmmo = 10;
var maxAmmo = 10;
var difficulty = 0

#------------------stage var-------------------
var stageBreakFloat = 0.0;
var maxBreakInt = 3;
var isNextStage = false
var isInStageBreak = false;

#----------is_statement-------------------------
var isPaused = false;
var isInDialogue = false
var isInPausedDialogue = false
var isPlaying = false
@export var isBoss = false
var isBossSpawned = false

var isLowQualityMode = false #disable most particles

var isIntroDone = false
var isDebugging = false
#-----------Shop Interaction---------------------
@export var isPressedShop: bool = false

#---------------shop upgrade values------------------------

	

func shop_proccessing(_delta):
	pass
	




var upgradeTree;

# shield Regen == shield == Range == Reload == Piercing == Speed == Swap
var details = [
	"Upgrade your shield\nregen and time\nto recover faster\n\n400 scraps = +0.2",
	"Upgrade your shield to\nwithstand more \nenemy damages.\n\n500 scraps = +1",
	"Increase your range\nfor your spirit cursor.\n\n300 scraps = +25",
	"Increase your spirit\ncursor attack to\nkill enemies faster.",
	"Increase piercing to\nyour enemy and still\ncontinue traveling.",
	"Icrease your bullet\nSPEED!",
	"Buy a type of bullet\nfor your liking",
	"Increase damage!",
	"Press this button to\nBuy the weapon."
	]


#PlayerStat Update ---------------------------------------------
var bulletStr = ["plasma_bullet","homing_missile","laser"]
func playerStatRestart(num):

	bullet_type = num;

	
	var updateStat1 = upgradeTree[bulletStr[bullet_type]]
	#--
	player_bullet_delay = updateStat1["upgradeTier"]["reloadTier"][updateStat1["reload"]]
	#--
	
	if bullet_type == 0:
		player_type = "Plasma Bullet"
		
	elif bullet_type == 1 and upgradeTree["boughtHM"] == true:
		
		player_type = "Homing Missile"
	elif bullet_type == 2 and upgradeTree["boughtL"] == true:
		player_type = "Piercing Laser"
		
	else:
		player_type = "Not bought yet"
		
		
		
#----------- Local Reset GameRule----------------
@export var enemy_curr = 0;
@export var enemy_cap = 1;
@export var enemy_cap_increase = 1;
var enemy_killed = 0

#------------Local Upgrades shop_interaction ---------------

func _ready():
	_reset()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta):
	shop_proccessing(delta)
	#next stage progress
	var enemies = get_tree().get_nodes_in_group("_enemy")
	if enemy_curr == enemy_cap and enemies.size() == 0 or (enemies.size() == 0 and GlobalScript.isBossSpawned == true):
		stageBreakFloat += delta;
		isInStageBreak = true
	if stageBreakFloat >= maxBreakInt and isNextStage == false:
		#print("in the next stage before ==>")
		GlobalScript.isBoss = false
		GlobalScript.isBossSpawned = false
		isNextStage = true;
		isInStageBreak = false
		
	
	if GlobalScript.isHitOnShip == true and GlobalScript.shipShieldRegenDelay >= 0:
		GlobalScript.shipShieldRegenDelay -= delta
	else:
		GlobalScript.isHitOnShip = false
		GlobalScript.shipShieldHealth =  GlobalScript.shipShieldHealth + delta*shipRegenShieldAmount if shipShieldHealth < shipMaxShield else shipMaxShield


#----------------- Save/Load data ---------------------


#-------------------------------dialogs
@export var stageNum = 1;
@export var dialogueNum = 0
var stageAvail = [1,2]

#template: {"inStage":,"data": [{"dial":"","char":0}]},
# template: {"dial":"","char":0},

var stageDialogeDict = [
	{
		"inStage": 1,
		"data": [
		{"dial":"Greetings fellow entity. Hmmmm, it seems we haven't met before.","char": 0},
		{"dial":"A human entity? I heard your kind before. A strong relation to apes or\na living entity in a floating rock in spaces you call earth.","char" : 0},
		{"dial":"The name's Cursor, a Spirit Cursor. Your name is control of my will to defend\nany kind of threat to this vessel. For you see, I am awoken by\nyour Vehicle known as a Mothership by a strange energy around this\nSector.","char":0},
		{"dial":"You are in grave danger. You travelled in a dangerous Sector known as Null.\nA place that has been known for 45,788 years in my kind.\nThough it is a dangerous place, you have awoken me to defend it.\nand you are likely to be safe.","char":0},
		{"dial":"I have senses the Vessel near us. Do you wanna fight them to accept the\nchallenge of a dangerous Sector? or do you prefer to blast away\nOut of the sector? Whatever you decide, it is too late to run\naway now.Your fate has sealed.","char":0},
		{"dial":"Move me closer to the vessel to attack\nuse W,A,S,D to move the vessels.","char":0}
		]
	},
	{
		"inStage": 2,
		"data": [
		{"dial":"You destoryed a civilian Vessels! You have alerted the Civilian Threat System! ","char": 0},
		{"dial":"Hello there Spirit. It is good to see you again. It seems you have found\nanother vessel. How pathetic of you. I should have keep\nyou lock away sleeping forever when i have the chance.","char" : 2},
		{"dial":"I awake when I have the chance. You should know this by now. Your system\nis a threat to all ally in my system. I can't defeat you, but at least\nI can reduce your total population little by little.","char":0},
		{"dial":"Hahaha. We multiply faster than what you can think. You have no such power\nhere.","char":2},
		]
	},
	{
		"inStage": 3,
		"data": [
		{"dial":"Attention all Biotech, we have intruder in our Null Star System. It is\napproaching to us and killing our civilian vessels. Prepare for battle.","char": 1},
		{"dial":"We have totally alerted the whole system. I will explain later about the\nprevious conversation. Lets us focus being alive.","char" : 0}
		]
	},{
		"inStage": 7,
		"data": [
		{"dial":"If you want the answer of what happen. I am a spirit who assign to eliminate\nthis sector alone.I have been assign a task that will forever my duty\nto keep my system stay into balance.","char": 0},
		{"dial":"Only this sector called Null is the threat to all living beings that they\nmodify their liking just to spread their culture around the galaxy. I have\nbeen protecting them form this sector for 30,000 years\nand i never want anyone to die from them.","char" : 0}
		]
	},{
		"inStage": 10,
		"data": [
		{"dial":"Spirit. You shouldn't come here. Your pathetic Vessel will not stand again,\nno matter how many times you possesed another vessel. Fight me like a man\nyou coward!","char": 1},
		{"dial":"You don't play fair GV, and neither should I. My only objective is to\neliminate all of your kind. I have no mercy on you now!","char" : 0}
		]
	},{
		"inStage": 11,
		"data": [
		{"dial":"You have defeated him? Good, but he will come back in every 10th waves.\nThe Boss we fought is the Galactic Vessel, one of the soliders and conquerer\nof this sector.","char":0},
		{"dial":"He can duplicate himself quickly and approach you, we must prepare and\nkill them as much as possible to eliminate their population. Are you ready?","char":0}
		]
	},{
		"inStage": 20,
		"data": [
		{"dial":"I have come back to you!","char":1},
		{"dial":"Here we go again.","char":0}
		]
	},{
		"inStage": 24,
		"data": [
		{"dial":"I am getting some strange signals coming in our sector","char":0},
		{"dial":"I will update you into that, for now. Prepare for the worst at wave\n25","char":0}
		]
	},{
		"inStage": 25,
		"data": [
		{"dial":"Hold on, it's DABABY","char":0},
		{"dial":"I mean the Embryo of the Null!","char":0}
		]
	},{
		"inStage": 26,
		"data": [
		{"dial":"Well that was close. Let's proceed","char":0}
		]
	},{
		"inStage": 30,
		"data": [
		{"dial":"I am back!","char":1},
		{"dial":"Awww shit. Here we go again...","char":0}
		]
	},{
		"inStage": 40,
		"data": [
		{"dial":"I am back for more domination!!","char":1},
		{"dial":"Awww shit. Here we go again...","char":0}
		]
	},{
		"inStage": 41,
		"data": [
		{"dial":"Life Cursor... I hear you...","char":3},
		{"dial":"Life Cursor. I will banish you...!","char":3}
		]
	},{
		"inStage": 45,
		"data": [
		{"dial":"Why didn't you run away?","char":3},
		{"dial":"Why did you come here again?.","char":3},
		{"dial":"I am coming to kill you grave!","char":0}
		]
	},{
		"inStage": 49,
		"data": [
		{"dial":"Hahaha don't be so overconfident.","char":3},
		{"dial":"I can sense your fear!","char":3},
		{"dial":"Let us see about that.","char":0}
		]
	},{
		"inStage": 50,
		"data": [
		{"dial":"You have come! Give up! Epithesi!","char":3}
		]
	},{
		"inStage": 51,
		"data": [
		{"dial":"Well player. We did it.","char":0},
		{"dial":"We destory the source of null","char":0},
		{"dial":"What comes next is after you.","char":0},
		]
	},
	{
		"inStage": 200,
		"data": [
		{"dial":"If you watch this far...\n\nCongratulation... You won.","char": 0},
		{"dial":"But going any further won't reduce population anymore.","char" : 0},
		{"dial":"Population grow faster than we are killing.","char" : 0},
		{"dial":"We can rest, or fight forever.","char" : 0},
		{"dial":"Whatever you decide. Thanks for your service.","char" : 0}
		
		]
	},
	
]





func _reset():
	#print("resetted")
	var reset_upgradeTree = {
	"plasma_bullet": {"damage":0,"speed":0,"piercing":0,"reload":0,"upgradeTier":
			{
				"damageTier": [3,9,13,19,23,26,30,33,35,38,40,44,47,50,55],
				"speedTier": [500,700,800,1000,1200,1400,1600,2000],
				"piercingTier": [0,1,3,4,5,6,7,8,10,20],
				"reloadTier": [0.16,0.15,0.14,0.13,0.12,0.1,0.08]

			}
		},
	"homing_missile": {"damage":0,"piercing":0,"reload":0,"upgradeTier":
			{
				"damageTier": [30,35,50,60,70],
				"piercingTier": [0],
				"reloadTier": [0.5,0.4,0.3,0.2,0.1]
			}
		},
	"laser": {"damage":0,"reload":0,"upgradeTier":
			{
				"damageTier": [200,500,700,1000,2000],
				"reloadTier": [6,4,3,2.4,2]
			}
		},
	"shieldRegen": [0.8,1.5,2,4,8,16,24,36,48,60],
	"shieldR":0,

	"rangeTier": [250,400,600,650,700,800,1000],
	"range":0,

	"shieldTier":[10,12,14,16,18,20,22,23,24,25],
	"shieldH":0,

	"costOrder": 
		{"pbCostBegin":[200,200,500,100], # damage, speed, pierce, reload
		"pbCostNext":[1.2,1.3,1.1,1.4],

		"hmCostBegin":[600,0,600], #damage pierce reload
		"hmCostNext":[1.3,1.7,1.3],

		"lCostBegin":[1000,800],  #damage reload
		"lCostNext":[1.2,1.4],

		"srCostBegin":300,
		"srCostNext":1.6,

		"rCostBegin":700,
		"rCostNext":1.1,

		"shCostBegin":700,
		"shCostNext":1.2,
		},
	"boughtHM":false,
	"boughtL":false
	}
	upgradeTree = reset_upgradeTree
	score = 0
	isPaused = false;
	isInDialogue = false
	isInPausedDialogue = false
	isPlaying = false
	stageBreakFloat = 0.0;
	maxBreakInt = 3;
	isNextStage = false
	isInStageBreak = false;
	isPressedShop = false
	scraps = 500
	enemy_curr = 0;
	enemy_cap = 9;
	enemy_cap_increase = 1;
	enemy_killed = 0
	laserAmmo = 10
	shipMaxShield = 10
	shipShieldHealth = 10
	shiphealth = 50
	dialogueNum = 0
	stageNum = 1;
	difficulty = 0
	currentTime = 0
