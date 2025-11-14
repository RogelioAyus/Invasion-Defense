extends CanvasLayer
@onready var options = $Control/VBoxContainer/Adjust/Options
@onready var sizeOptions = $Control/VBoxContainer/Adjust2/Options

@export var InEditor = false

# Called when the node enters the scene tree for the first time.
func _ready():
	options.item_selected.connect(optionList)
	sizeOptions.item_selected.connect(changeSize)
	for i in windowSize:
		sizeOptions.add_item(i)
		
	for i in windowOptions:
		options.add_item(i)
	options.selected = 3
	if !InEditor:
		self.hide()
	pass
const windowSize: Dictionary = {
	"800 x 600" : Vector2(800,600),
	"1024 x 768" : Vector2(1024,768),
	"1152 x 648" : Vector2(1152,648),
	"1280 x 720" : Vector2(1280,720),
	"1920 x 1080" : Vector2(1920,1080),
	"2560 x 1440" : Vector2(2560,1440),
}
const windowOptions: Array[String] = [
	"Fullscreen",
	"Boarderless Fullscreen",
	"Window Mode",
	"Window Boarderless"
]
func changeSize(index: int):
	DisplayServer.window_set_size(windowSize.values()[index])
func optionList(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db($Control/VBoxContainer/music.value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"),linear_to_db($Control/VBoxContainer/sound.value))




func _on_exit_pressed():
	$Tutorial.hide()


func _on_tutorial_pressed():
	$Tutorial.show()


func _on_exitSettings():
	$".".hide()


func _on_exit_about_pressed():
	$About.hide()


func _on_about_pressed():
	$About.show()


func exitDetailsAbout():
	$aboutDetails.hide()


func _on_credits_pressed():
	$aboutDetails.show()


func guideOpen():
	$guides.show()


func guideClose():
	$guides.hide()


func _on_check_box_toggled(toggled_on):
	GlobalScript.isLowQualityMode = toggled_on


func _on_check_debug(toggled_on):
	GlobalScript.isDebugging = toggled_on
