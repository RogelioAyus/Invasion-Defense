extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()



func _on_yes_pressed():
	get_tree().quit()


func _on_no_pressed():
	hide()
