extends Control


func _on_save_pressed():
	GlobalSql.savedata(GlobalScript.namePlayer,GlobalScript.score,GlobalScript.currentTime,GlobalScript.difficulty)
	procceeding()


func _on_delete_pressed():
	procceeding()


func procceeding():
	GlobalScript.dialogueNum = 0
	GlobalScript.stageNum = 1
	GlobalScript.isPaused = false
	var enemy = get_tree().get_nodes_in_group("_enemy");
	for i in enemy:
		i.queue_free()
	var bullet = get_tree().get_nodes_in_group("_bullet");
	for i in bullet:
		i.queue_free()
	GlobalScript._reset()
	Transition.transition("res://TSCN Scenes/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()



func _on_go_back_pressed():
	hide()
