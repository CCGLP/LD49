extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var tween = $Tween
export var name_stat = "Velocity"
export(Texture) var texture 
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = " - %s =" % name_stat
	$TextureRect.texture = texture
	pass # Replace with function body.

func _setValue(value, pValue):
	if (value is float):
		$numberLabel.text = "%2.2f"%value
	else:
		$numberLabel.text = String(value)
	if (value > pValue):
		$arrow.modulate = Color.green
		tween.interpolate_property($arrow, "rect_rotation", 0, -90, 0.4)
		tween.start()
	elif(value < pValue):
		$arrow.modulate = Color.red
		tween.interpolate_property($arrow, "rect_rotation", 0, 90, 0.4)
		tween.start()

	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
