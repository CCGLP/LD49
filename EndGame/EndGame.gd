extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var globals = get_node("/root/Globals")
export(PackedScene) var gameScene
var pressed := false

# Called when the node enters the scene tree for the first time.
func _ready():
	$HighScore.text = "High Score: Level " + String(globals.highScore)
	$SendButton.connect("pressed", self, "_send")
	
	pass # Replace with function body.

func _send():
	if ($TextEdit.text != "name"):
		globals._send_score($TextEdit.text, globals.highScore)
		globals._print_HighScores()
	pass
func _process(delta):
	if (Input.is_key_pressed(KEY_SPACE) && !pressed):
		pressed = true
		var root = get_node("/root")
		var game = gameScene.instance()

		root.add_child(game)
		root.get_tree().set_current_scene(game)
		queue_free()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
