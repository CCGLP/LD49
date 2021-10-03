extends "res://Enemy/BasicEnemy.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tweenColor = $TweenColor
export(Color,RGBA) var otherColor
export var loseTime = 3.0

# Called when the node enters the scene tree for the first time.
func _ready():
	originalColor = self.modulate
	pass # Replace with function body.

func _on_lose(pos):
	tween.interpolate_property(self, "modulate", originalColor, colHit, loseTime)
	tween.start()
	_knock_back(pos)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!tweenColor.is_active()):
		tweenColor.interpolate_property(self, "modulate", originalColor, otherColor, hitTime)
		tweenColor.interpolate_property(self, "modulate", otherColor, originalColor, hitTime, 0, 2, hitTime)
		tweenColor.start()
	pass
