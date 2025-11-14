extends CanvasLayer
@onready var audio = $audio



func transition(target: String) -> void:
	audio.play()
	get_tree().paused = true
	GlobalScript.isPlaying = false
	$AnimationPlayer.play("Transition")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("Transition")
	
