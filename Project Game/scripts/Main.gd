extends Node2D
@onready var tour = $CL2/CheckButton
@onready var difSLider= $CL2/difficulty
@onready var sID = $"CL2/Student ID"
@onready var eID = $CL2/enterID


@onready var diff = preload("res://customs/diff_tres.tres")
# Called when the node enters the scene tree for the first time.
func _ready():
	diff_part.emitting = false
	tour.button_pressed = GlobalScript.tournament
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$AudioStreamPlayer.play()
	$CL2.hide()
	$"CL3 - Leaderboard".hide()


func _on_cancel_pressed():
	$CL2.hide()

var textL = ["Sterile:\n- The sector is weaken\n- Lowest score points\n- Lowest enemy Population",
	"Medium:\n- Enemy health increase\n- Gaining 2x more score points\n- Sector is defended properly",
	"Insane:\n- Average Score points\n- More health to the enemies by 50%\n- Sector is reinforeced",
	"Cataclysm:\n- Death is likely\n- Enemies are 2x resistant\n- Highest Score points\n- Overpopulated Sector and heavily alerted"
	]
var color = [Color(0,0,0,1),Color(1,0.5,0,1),Color(1,0,0,1),Color(1,1,0,1)]
var iconDIff = [preload("res://sprites/icons/Sterile.png"),preload("res://sprites/icons/Medium.png"),preload("res://sprites/icons/Insane.png"),preload("res://sprites/icons/Catalyst .png")]
func _process(_delta):
	GlobalScript.tournament = tour.button_pressed
	if tour.button_pressed == true:
		sID.show()
		eID.show()
		GlobalScript.difficulty = 3
		$CL2/difficulty.value = GlobalScript.difficulty
		difSLider.editable = false
	else:
		eID.hide()
		sID.hide()
		difSLider.editable = true

	$CL2/difficulty/text.text = textL[$CL2/difficulty.value]
	$CL2/difficulty/Symbol.texture = iconDIff[$CL2/difficulty.value]
	diff.color = color[$CL2/difficulty.value]


func _onExitLeaderboard():
	$"CL3 - Leaderboard".hide()


@onready var diff_part = $CL2/DiffPart

func _on_difficulty_value_changed(value):
	$CL2/changeDif.pitch_scale = (value)+1
	if value == 3:
		diff_part.emitting = true
	else:
		diff_part.emitting = false
	#print(value)
	$CL2/changeDif.play()


func _on_check_button_toggled(toggled_on):
	if toggled_on == true:
		sID.text = ""


	


func _on_exit_Credits():
	$"CL4 - Credits".hide()
