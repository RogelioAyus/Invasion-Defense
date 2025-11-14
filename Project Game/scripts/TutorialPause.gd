extends Control



func _on_continue():
	$"..".hide()


func _on_back():
	Transition.transition("res://TSCN Scenes/Main.tscn")
