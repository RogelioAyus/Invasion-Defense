extends Node2D

#func _input(event):
	#if GlobalScript.isPressedShop and event.is_action_pressed("space"):
		#$"../../.."._shopExit()
