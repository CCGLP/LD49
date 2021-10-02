extends "res://BaseMiniGame/BaseMiniGame.gd"

onready var tween = $Tween

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mouseUp := false
export var maxClickNumber:= 10
export var animTime = 0.1
var clicks := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Label.text = String(maxClickNumber)
	pass # Replace with function body.

func _on_mouse_entered():
	mouseUp = true
	pass

func _on_mouse_exited():
	mouseUp = false
	pass

func _unhandled_input(event):
	if (event is InputEventMouseButton):
		if (event as InputEventMouseButton).button_index == 1 && mouseUp && (event as InputEventMouseButton).pressed:
			clicks+=1
			$Control/Label.text =String (maxClickNumber - clicks)
			print("CLICK")
			if (clicks >= maxClickNumber):
				self._finish_game(true)
			if (!tween.is_active()):
				tween.interpolate_property($StaticBody2D, "scale", Vector2(1,1), Vector2(2,2), animTime);
				tween.interpolate_property($StaticBody2D, "scale", Vector2(2,2), Vector2(1,1), animTime, 0, 2, animTime);
				tween.start();

pass
