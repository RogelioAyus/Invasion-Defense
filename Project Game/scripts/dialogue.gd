extends CanvasLayer
@onready var spriteGroup = [%red, %blue, %green,%portrait]
@onready var c3 = [%red, %blue, %green]
@onready var bgmusic = $"../BgMusic"
@onready var pausedL = $"../pausedLayer"
@export var character = 0;
@export var inEditor = true;
@export var dialogueValueIndex: int;
var aniName = ["spiritCursor","galacticVessel","bv","bv2","bv3"]
var audioVoice = [preload("res://Music/sfx/spirit_cursor_voice.wav"),
	preload("res://Music/sfx/galacticVessel_voice.wav"),
	preload("res://Music/sfx/destroy1.wav"),
	preload("res://Music/sfx/grave_voice.wav")
]
var characterVoices = ["res://Music/sfx/spirit_cursor_voice.wav","res://Music/sfx/galacticVessel_voice.wav"]


#31 make a new line ---------------------- setup--------------------
var charPortList = [];
var dialogueList = [];
var diagLines = 0;
var stringDelay: float = 0;
var stringDelayMax: float = 0.05;
var curStr = 0;
var maxStr = 0;

var isForceShipped = false;

var isStopped = false;

func _ready():
	setupDialogue(GlobalScript.stageDialogeDict[dialogueValueIndex])


func changeProtrait(numCha):
	for i in spriteGroup:
		i.animation = aniName[numCha]
	$voices.stream = audioVoice[numCha]

func _resetAmmo():
	GlobalScript.laserAmmo = 10
		
func setupDialogue(dialogueData):
	curStr = 0;
	maxStr = 0;
	diagLines = 0;
	stringDelay = 0;
	$Node2D/Text.text = ""
	show()
	if dialogueData["inStage"] != GlobalScript.stageNum and !inEditor:
		GlobalScript.isPlaying = true
		GlobalScript.isInDialogue = false
		get_tree().paused = false
		GlobalScript.isPaused = false
		isForceShipped = false
		GlobalScript.isNextStage = false
		isStopped = false
		GlobalScript.stageNum += 1;
		hide()
		resetEnemy()
		_resetAmmo()
		isStopped = true
		if true: #setup boss level later
			pass
		$voices.stop()
		return
	GlobalScript.dialogueNum += 1;
	charPortList = [];
	dialogueList = [];
	for i in dialogueData["data"]:
		dialogueList.append(i["dial"])
		charPortList.append(i["char"])
	GlobalScript.isNextStage = false
	GlobalScript.isInDialogue = true
	GlobalScript.isPlaying = false
	isStopped = false
	#isForceShipped == false
	changeProtrait(charPortList[diagLines])
	GlobalScript.stageNum += 1;
	
	
	$AnimationPlayer.play("RESET")
	$AnimationPlayer.play_backwards("Tra")
	if !inEditor:
		bgmusic.stop() 
		$"../dialogueMusic".play()
	

func dialogueProcess(delta):
	if (Input.is_action_just_pressed("space") or Input.is_action_pressed("shift")) and diagLines < dialogueList.size()-1 and curStr == maxStr and GlobalScript.isInPausedDialogue == false:
		diagLines += 1;
		curStr = 0
		$Node2D/Text.text = ""
		isForceShipped = false
		changeProtrait(charPortList[diagLines])
	elif (Input.is_action_just_pressed("space") or Input.is_action_pressed("shift")) and curStr < maxStr and GlobalScript.isInPausedDialogue == false:
		$Node2D/Text.text = dialogueList[diagLines];
		isForceShipped = true
		curStr = maxStr
	elif (Input.is_action_just_pressed("space") or Input.is_action_pressed("shift")) and GlobalScript.isInPausedDialogue == false and GlobalScript.isPlaying == false:
		GlobalScript.isPlaying = true
		GlobalScript.isInDialogue = false
		get_tree().paused = false
		GlobalScript.isPaused = false
		isForceShipped = false
		hide()
		resetEnemy()
		_resetAmmo()
		isStopped = true
		if true: #setup boss level later
			pass
		$voices.stop()
		if !inEditor:
			bgmusic.play()
			$"../dialogueMusic".stop()
		
	maxStr = dialogueList[diagLines].length()
	if stringDelayMax >= stringDelay:
		stringDelay += delta;
	elif curStr < maxStr and isStopped == false and isForceShipped == false:
		curStr += 1
		$voices.stop()
		$voices.pitch_scale = randf_range(0.5,1)
		$voices.play()
		$Node2D/Text.text += str(dialogueList[diagLines][curStr-1])
		stringDelay = 0


func _process(delta):
	
	dialogueProcess(delta)
	for i in c3:
		i.position = Vector2(randf_range(-3,3),randf_range(-3,3));

func _input(event):
	if event.is_action_pressed("esc"):
		GlobalScript.isPaused = true
		if GlobalScript.isInDialogue and GlobalScript.isPaused:
			GlobalScript.isInPausedDialogue = true
		
		pausedL.show()
		get_tree().paused = !get_tree().paused
		
func resetEnemy():
	if GlobalScript.stageNum in [11,21,26,31,41,51]:
		GlobalScript.isBoss = true
	elif GlobalScript.stageNum >= 52:
		Transition.transition("res://TSCN Scenes/the_end.tscn")
	GlobalScript.enemy_curr = 0
	if range(0,10).has(GlobalScript.stageNum):
		GlobalScript.enemy_cap += GlobalScript.enemy_cap_increase
		print("working 1")
	elif range(10,20).has(GlobalScript.stageNum):
		GlobalScript.enemy_cap += GlobalScript.enemy_cap_increase +1
		print("working 2")
	elif range(20,30).has(GlobalScript.stageNum):
		GlobalScript.enemy_cap += GlobalScript.enemy_cap_increase +1
		print("working 3")
	elif range(30,40).has(GlobalScript.stageNum):
		GlobalScript.enemy_cap += GlobalScript.enemy_cap_increase +1
		print("working 4")
	else:
		GlobalScript.enemy_cap += GlobalScript.enemy_cap_increase
		print("not working ")
		
	GlobalScript.enemy_cap = GlobalScript.enemy_cap if GlobalScript.enemy_cap < (50 + 50*GlobalScript.difficulty) else (50 + 25*GlobalScript.difficulty)
	GlobalScript.stageBreakFloat = 0
	GlobalScript.enemy_killed = 0
