extends "res://BaseMiniGame/BaseMiniGame.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var bulletScene
var player 

var timeToSurvive := 4
var timeToSurviveTimer := 0.0

var timeToShoot:= 0.08
var timeToShootTimer:= 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Character
	pass # Replace with function body.

func _unhandled_input(event):
	if (event is InputEventMouseButton):
		if (event as InputEventMouseButton).button_index == 1 :
			_fire()

func _fire():
	if (timeToShootTimer > timeToShoot):
		timeToShootTimer = 0
		$ShootSound.pitch_scale = rand_range(0.9,1.1)
		$ShootSound.play()
		var bullet = bulletScene.instance()
		bullet.position = player.position
		bullet._start((get_global_mouse_position() - player.global_position).normalized())
		add_child(bullet)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeToSurviveTimer += delta
	timeToShootTimer += delta
	if timeToSurviveTimer >= timeToSurvive:
		timeToSurviveTimer = 0
		_finish_game(true)
	player.look_at(get_global_mouse_position())
	pass
