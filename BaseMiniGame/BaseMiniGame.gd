extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var level = get_node("/root/Level")
	if (level):
		level.pause(true)
	pass # Replace with function body.

func _finish_game(good):
	var level = get_node("/root/Level")
	level._finish_minigame(good)
	if (level):
		level.pause(false);
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
