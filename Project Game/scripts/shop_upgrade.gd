extends Node2D
@onready var button = $Button
@onready var main_game = $"../../.."
@onready var button_sprite = %"button sprite"
@onready var lvl = $level

@export var sprite:Texture;
@export var ID_shop: int;

@export var ifLevelable = false

@export var isScroller = false

func play():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	if isScroller == true:
		$Button.self_modulate = Color(1,1,0,1)
	button_sprite.texture = sprite
	button.disabled = true
	
	if ifLevelable:
		lvl.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_button_pressed():
	main_game.onShopChoice(self)
