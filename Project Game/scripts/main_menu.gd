extends Control
#@onready var clabel = $"../../Confirmation/Control/NinePatchRect/Label"
#@onready var cLayer = $"../../Confirmation"

@onready var tournament = $"../../CL3 - Leaderboard/Control/Tournament"
@onready var top_3 = $"../../CL3 - Leaderboard/Control/Top3"

@onready var ap = $AnimationPlayer
@onready var color_rect = $ColorRect
@onready var student_id = $"../../CL2/Student ID"

@onready var s = [$MarginContainer/Title/TextureRect/red, $MarginContainer/Title/TextureRect/blue, $MarginContainer/Title/TextureRect/green]
@onready var NameIn = $"../../CL2/NameIn"
@onready var tx = %NameScore
@onready var buttons = [$MarginContainer/VBoxContainer/start, $MarginContainer/VBoxContainer/tutorial, $MarginContainer/VBoxContainer/leaderboard, $MarginContainer/VBoxContainer/Settings, $MarginContainer/VBoxContainer/credits, $MarginContainer/VBoxContainer/Exit]
var dataSQL;
var begin = false;
var diffList = ["Sterile","Medium","Insane","Cataclysm"]
var topL = ["st","nd","rd","th"]
func hideColorRect():
	color_rect.hide()
	
func _on_exit_pressed():
	get_tree().quit()

func _ready():
	
	if GlobalScript.isIntroDone == false:
		ap.play("Startup")
		GlobalScript.isIntroDone = true
	else:
		ap.play("back")
		color_rect.hide()

func _on_start_button_down():
	GlobalScript.isPaused = true
	$"../../CL2".show()

func _process(_delta):
	var index = 0;
	for j in buttons:
		j.position = Vector2(randf_range(-3,3),randf_range(-3,3))
		j.position += Vector2(0,40*index)
		index += 1
	for i in s:
		i.position = Vector2(randf_range(-10,10),randf_range(-10,10))

func start_game():
	Transition.transition("res://TSCN Scenes/main_game.tscn")
	$"../../AudioStreamPlayer".stop()


func _on_strat_game_pressed():
	if len(NameIn.text) <= 3 or (len(student_id.text) <= 9 and GlobalScript.tournament):
		$"../../CL2/error".play()
		NameIn.text = ""
		student_id.text = ""
		NameIn.placeholder_text = "Must be 4-10 character longer"
		student_id.placeholder_text = "Must be 10 Integer Long"
	else:
		notify(false)
		
func notify(tour: bool):
		GlobalScript.namePlayer = NameIn.text
		GlobalScript.difficulty = $"../../CL2/difficulty".value
		if tour:
			GlobalScript.studentID = student_id.text
		else:
			GlobalScript.studentID = "NULL"
		$"../../CL2".hide()
		start_game()
	
func _on_leaderboard_pressed():
	$"../../CL3 - Leaderboard".show()
	dataSQL = GlobalSql.loaddata()
	tx.text = ""
	setNameData_to_NameScore()

func setNameData_to_NameScore():
	for i in range(0,dataSQL[1]):
		var posTop = topL[i] if i <= 3 else topL[3]
		tx.text += "(" +str(i+1) + posTop + ")Name:" + dataSQL[0][i]["Name"] + "\n    Score:" + str(dataSQL[0][i]["Score"]) + "\n    Time:" + str(dataSQL[0][i]["Time"]) + " sec\n    Difficulty: " + str(diffList[dataSQL[0][i]["Difficulty"]]) + "\n\n\n"
	if dataSQL[1] == 0:
		tx.text = "No record found, be the first!"



func _on_settings_pressed():
	ClSettings.show()


#func _on_confirm_pressed():
#	cLayer.hide()
#	notify(true)


#func _exitTheConfirmation():
#	cLayer.hide()


func _on_tournament_toggled(_toggled_on):
	pass # Replace with function body.


func _on_top_3_toggled(toggled_on):
	tx.text = ""
	if toggled_on == true:
		onlyTop3()
	else:
		setNameData_to_NameScore()

func onlyTop3():
	var limit = 0;
	for i in range(0,dataSQL[1]):
		var posTop = topL[i] if i <= 3 else topL[3]
		tx.text += "(" +str(i+1) + posTop + ")Name:" + dataSQL[0][i]["Name"] + "\n    Score:" + str(dataSQL[0][i]["Score"]) + "\n    Time:" + str(dataSQL[0][i]["Time"]) + " sec\n    Difficulty: " + str(diffList[dataSQL[0][i]["Difficulty"]]) + "\n\n\n"
		limit += 1
		if limit == 3:
			break
	if dataSQL[1] == 0:
			tx.text = "No record found, be the first!"


func _button_tutorial():
	Transition.transition("res://TSCN Scenes/tutorial_game.tscn")


func _show_credits():
	$"../../CL4 - Credits".show()
