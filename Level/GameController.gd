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
export(Curve) var spawnGlitchCurve
export var lengthSpawnCurve = 120
var timerSpawn:= 0.0
var timerSpawnTrue = 0.0
onready var globals = get_node("/root/Globals")
var random
var player
var dungeon 
var door
var currentGlitch

var enemies = [] 
var gui

var pause = false
# Called when the node enters the scene tree for the first time.
func _ready():
	_reset_game()

	
	player = playerScene.instance()
	gui = player.get_node("CanvasLayer").get_node("GUI")
	_set_parameters()
	dungeon = $SimpleDungeon
	dungeon._start();
	player.get_node("cameraGame").limit_bottom = 64*dungeon.height-32;
	player.get_node("cameraGame").limit_right = 64*dungeon.width-32;


	player.position = _getRandomPositionInDungeon()

	for i in enemyNumber:
		var enemy = enemyScene.instance()
		enemy.position = _getRandomPositionInDungeon()
		add_child(enemy)
		enemies.append(enemy)
	
	
	add_child(player)
	player.connect("Unstable", self, "_unstability_calls")
	player.connect("End", self, "_end_game")


	door = doorScene.instance()
	door.position = _getRandomPositionInDungeon()
	add_child(door)

	door.connect("DoorEnter", self, "_nextLevel")


	pass # Replace with function body.

func _end_game():
	globals.globals_reset = true
	var end_game = load("res://EndGame/EndGame.tscn").instance()
	var root = get_node("/root")
	root.add_child(end_game)
	queue_free()
	pass

func _reset_game():
	if (globals.globals_reset):
		globals.globals_reset = false
		globals.currentLevel = 0
		globals.timerSpawn = 0.0
		globals.glitchedEnemyNumber = 1
		globals.width = $SimpleDungeon.width
		globals.height = $SimpleDungeon.height
		globals.enemyNumber = enemyNumber
	pass

func _finish_minigame(good):
	gui.visible = true
	player.get_node("Camera2D").get_node("GUI").get_node("Glitch").visible = false
	player.camera.current = false
	player.get_node("cameraGame").current = true
	if (currentGlitch && good):
		if (currentGlitch.health > 0) : 
			currentGlitch._destroy()
	elif(!good):
		player.health-= 1
		player._hit(currentGlitch.position, null)
		if (currentGlitch):
			currentGlitch._on_lose(player.position)
	pass
func pause(value):
	self.pause = value
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
	player.camera.current = true
	player.get_node("cameraGame").current = false
	get_node("/root").add_child(miniGame)

	pass
func _set_parameters():
	gui.get_node("Level").text = "Level " + String(globals.currentLevel)
	enemyNumber = globals.enemyNumber
	glitchedEnemyNumber = globals.glitchedEnemyNumber
	timerSpawn = globals.timerSpawn
	$SimpleDungeon.width = globals.width
	$SimpleDungeon.height = globals.height
	pass

func _nextLevel():
	print("DOOR ENTER")
	get_node("/root/GlobalAudio").play()
	globals.currentLevel+=1
	globals.enemyNumber += 1
	globals.glitchedEnemyNumber += 1
	globals.width+=2
	globals.height+=2
	globals.timerSpawn = timerSpawn
	if (globals.currentLevel > globals.highScore):
		globals.alreadySended = false
		globals.highScore = globals.currentLevel
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
	if (!pause):
		timerSpawnTrue+= delta
		timerSpawn += delta
		if (timerSpawnTrue > spawnGlitchCurve.interpolate_baked(timerSpawn/lengthSpawnCurve)):
			timerSpawnTrue = 0
			var enemy = glitchedEnemyScene.instance()
			enemy.position = _getRandomPositionInDungeon()
			add_child(enemy)
			enemies.append(enemy)
		
	pass
