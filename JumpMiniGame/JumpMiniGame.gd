extends "res://BaseMiniGame/BaseMiniGame.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = $Character
var initialPosY := 0.0
export var speed = 300.0
export var gravity := 98.0
var jumpForce := 0.0
var isJumping:= false

var timerWin = 0.0
export var timeToWin = 2.2
# Called when the node enters the scene tree for the first time.
func _ready():
	initialPosY = player.position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	timerWin+= delta
	if (timerWin > timeToWin):
		timerWin = 0.0
		_finish_game(true)


	if (Input.is_action_just_pressed("ui_accept")&& !isJumping):
		jumpForce = -speed
		isJumping = true
		$JumpSound.pitch_scale = rand_range(0.9, 1.1)
		$JumpSound.play()

	if (isJumping):
		print(jumpForce)
		
		jumpForce += gravity * delta
		if (jumpForce > 0):
			jumpForce+= gravity*delta
		player.position.y += jumpForce*delta
		if (player.position.y >= initialPosY && jumpForce > 0):
			print("entro")
			isJumping = false
			player.position.y = initialPosY
			#jumpForce = 0
		
	pass
