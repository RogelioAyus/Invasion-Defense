extends Node2D


func _ready():
	get_tree().paused = false
	$AnimationPlayer.play("comic")
	GlobalSql.savedata(GlobalScript.namePlayer,GlobalScript.score,GlobalScript.currentTime,GlobalScript.difficulty)


func _on_button_pressed():
	Transition.transition("res://TSCN Scenes/Main.tscn")
