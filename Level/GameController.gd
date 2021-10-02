extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var enemyNumber:=2
export var glitchedEnemyNumber := 0
export(PackedScene) var playerScene
export(PackedScene) var enemyScene
export(PackedScene) var glitchedEnemyScene
export(PackedScene) var doorScene
export(PackedScene) var miniGameTestScene
export(Array, PackedScene) var miniGameScenes
onready var globals = get_node("/root/Globals")
var random
var player
var dungeon 
var door
var currentGlitch

var enemies = [] 
# Called when the node enters the scene tree for the first time.
func _ready():

	_set_parameters()
	dungeon = $SimpleDungeon
	dungeon._start();
	player = playerScene.instance()
	player.position = _getRandomPositionInDungeon()
	for i in enemyNumber:
		var enemy = enemyScene.instance()
		enemy.position = _getRandomPositionInDungeon()
		add_child(enemy)
		enemies.append(enemy)
	for i in glitchedEnemyNumber:
		var enemy = glitchedEnemyScene.instance()
		enemy.position = _getRandomPositionInDungeon()
		add_child(enemy)
		enemies.append(enemy)
	
	add_child(player)
	player.connect("Unstable", self, "_unstability_calls")


	door = doorScene.instance()
	door.position = _getRandomPositionInDungeon()
	add_child(door)

	door.connect("DoorEnter", self, "_nextLevel")


	pass # Replace with function body.

func _finish_minigame(good):
	if (currentGlitch && good):
		currentGlitch._destroy()
	pass
func pause(value):
	player.pause = value
	for enemy in enemies:
		if (enemy):
			enemy.pause = value
	pass

func _unstability_calls(glitch):
	currentGlitch = glitch
	var miniGameScene = miniGameScenes[random.randi_range(0, miniGameScenes.size()-1)]
	var miniGame = miniGameScene.instance()
	miniGame.position = player.position
	get_node("/root").add_child(miniGame)
	pass
func _set_parameters():
	enemyNumber = globals.enemyNumber
	glitchedEnemyNumber = globals.glitchedEnemyNumber
	pass

func _nextLevel():
	print("DOOR ENTER")
	globals.enemyNumber += 3
	globals.glitchedEnemyNumber += 1
	get_tree().reload_current_scene()

	pass
func _getRandomPositionInDungeon():
	random = RandomNumberGenerator.new();
	random.randomize();
	var i = 0; 
	var x = 0;
	var y = 0;
	while (i == 0):
		x = random.randi_range(0, dungeon.width-1)
		y = random.randi_range(0, dungeon.height-1)
		i = dungeon.map[x][y]
		if (i == 1):
			break;
	return Vector2(x * 64, y * 64);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_K):
		var minigame = miniGameTestScene.instance()
		minigame.position = player.position
		add_child(minigame)
	pass
