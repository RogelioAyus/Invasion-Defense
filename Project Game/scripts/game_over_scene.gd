extends Node2D

@onready var death = $death
var quotes = [
	"You have died " + GlobalScript.namePlayer + ", with Dignity and Honor.",
	"You defend the sector well " + GlobalScript.namePlayer +". Let other spirits feel your presence.",
	"Death is inevitable. You print the space with your name " + GlobalScript.namePlayer,
	"Spirit has been relase. Your vessel is free.",
	"No matter how hard you try, nothing's change.",
	"Fragile is a weakness, determination is your will.",
	"An eye for an eye, and the galaxy goes blind.",
	"Wake up, You have died serving the galaxy.",
	"Another death, another courageous spirit.",
	"You have died. That is what happened when you get killed.",
	"Death is taking over you, let it go and rest.",
	"Upon the stars, you choose to hold death by yourself."
]
func _ready():
	if GlobalScript.tournament:
		GlobalSql.savedataTournament(GlobalScript.namePlayer,GlobalScript.score,GlobalScript.currentTime,GlobalScript.difficulty,GlobalScript.studentID)
	else:
		GlobalSql.savedata(GlobalScript.namePlayer,GlobalScript.score,GlobalScript.currentTime,GlobalScript.difficulty)
	$soul2.emitting = true
	#$soul.emitting = true
	death.emitting = true
	$deathplay.play("Sequence")
	$deathSound.play()
	$Tex.text = quotes.pick_random() +"\nScore: " + str(int(GlobalScript.score))
	
func playMusic():
	$Audio.play()


func _on_main_menu_pressed():
	GlobalScript._reset()
	get_tree().change_scene_to_file("res://TSCN Scenes/Main.tscn")

