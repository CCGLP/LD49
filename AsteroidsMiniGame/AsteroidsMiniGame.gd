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
			_fire(get_global_mouse_position())

func _fire(lookTransform):
	if (timeToShootTimer > timeToShoot):
		timeToShootTimer = 0
		$ShootSound.pitch_scale = rand_range(0.9,1.1)
		$ShootSound.play()
		var bullet = bulletScene.instance()
		bullet.position = player.position
		bullet._start((lookTransform - player.global_position).normalized())
		add_child(bullet)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeToSurviveTimer += delta
	timeToShootTimer += delta
	if timeToSurviveTimer >= timeToSurvive:
		timeToSurviveTimer = 0
		_finish_game(true)


	var lookTransform:= Vector2(0,0)
	if (Input.get_connected_joypads().size() > 0):
		lookTransform = Vector2(Input.get_action_strength("right_stick_right") + Input.get_action_strength("ui_right")- Input.get_action_strength("right_stick_left") - Input.get_action_strength("ui_left"), -Input.get_action_strength("right_stick_up") - Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down") + Input.get_action_strength("right_stick_down"))
		lookTransform = lookTransform *100
		lookTransform = self.global_position + lookTransform
		if (Input.is_action_just_released("ui_accept")):
			_fire(lookTransform)
	else:
		lookTransform = get_global_mouse_position()
	player.look_at(lookTransform)
	pass
