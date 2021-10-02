extends Area2D

signal DoorEnter
onready var tween = $Tween

export (Color, RGBA) var colorEnd
export var animTime = 0.2
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var originalColor; 

# Called when the node enters the scene tree for the first time.
func _ready():
	originalColor = self.modulate
	pass # Replace with function body.

func _on_Door_body_entered(body):
	if (body.name == "Player"):
		emit_signal("DoorEnter")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!tween.is_active()):
		tween.interpolate_property(self, "modulate", originalColor, colorEnd,animTime)
		tween.interpolate_property(self, "modulate", colorEnd, originalColor,animTime, 0, 2, animTime)
		tween.start()
	pass
