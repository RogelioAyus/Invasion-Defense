extends Control
@onready var are_you_sure = $AreYouSure
@onready var main_menu_quitting = $MainMenuQuitting


# Called when the node enters the scene tree for the first time.
func _ready():
	$"..".hide()




func _input(event):
	if event.is_action_pressed("esc"):
		_on_start_pressed()


func _on_start_pressed():
	if GlobalScript.isInDialogue == false:
		get_tree().paused = false
		GlobalScript.isPaused = false
	GlobalScript.isInPausedDialogue = false
	$"..".hide()


func _on_exit_pressed():
	are_you_sure.show()


func _on_main_menu_pressed():
	main_menu_quitting.show()


func _on_settings_pressed():
	ClSettings.show()
