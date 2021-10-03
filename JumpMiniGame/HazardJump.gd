extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed = 300.0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("area_entered", self, "on_area_entered")
	pass # Replace with function body.

func on_area_entered(area: Area2D):
	if (area.name == "Character"):
		get_parent()._finish_game(false)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += speed*delta
	pass
