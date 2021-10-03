extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var speed := 500
var target := Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready asteroide")
	pass # Replace with function body.

func _on_area_entered(area:Area2D):
	print("Hola")
	if area.name.find_last("Bullet")!= -1:
		queue_free()
		get_parent().get_node("ExplosionSound").pitch_scale = rand_range(0.9,1.1)
		get_parent().get_node("ExplosionSound").play()
	elif (area.name == "Character"):
		get_parent()._finish_game(false)
	
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position+= ((target-position).normalized()*delta*speed)
	
pass
