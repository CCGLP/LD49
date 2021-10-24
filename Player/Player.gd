extends KinematicBody2D

signal Unstable
signal End
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT
onready var tweenCamera = $Camera2D/Tween
onready var camera = $Camera2D
export var cameraOffset = 100;
export var speedMin = 100;
export var speedMax = 600;
export var attackMin = 1;
export var attackMax = 4
export var timeAttackMin = 0.1
export var timeAttackMax = 0.3
export var knockBackPixelsMin = 50
export var knockBackPixelsMax = 200
export var critProbMin = 0.1
export var critProbMax = 0.4
export var healthMin = 3
export var healthMax = 10


var healthStep = 1
var critStep = 0.02
var knockStep = 10
var timeAttackStep = 0.02
var attackStep = 1
var speedStep = 30


onready var tween = $TweenArma
onready var tweenHit = $TweenHit
export var speed:=300; 
export var attack := 2
export var health:= 3
var actualSpeedX := 0
var actualSpeedY := 0

var is_attacking := false
var timerAttack:= 0.0

export(Color, RGBA) var colHit
onready var globals = get_node("/root/Globals")

var originalColor:Color
export var hitTime:= 0.3
export var crit_prob = 0.2
export var unstability_value := 0.3
export var unstability_check := 3
var unstability_timer:= 0.0
export var timeAttack := 0.5
export var knockBackPixels := 100
var pause = false
onready var gui = $CanvasLayer/GUI
var interLevelgui; 


# Called when the node enters the scene tree for the first time.
func _ready():
	_init_stats()
	interLevelgui._start(speed, attack, timeAttack, crit_prob, health, knockBackPixels)
	originalColor = self.modulate
	set_life_ui()
	_save_previous_stats()
	tweenHit.interpolate_property($square, "modulate", originalColor, colHit, hitTime*5)
	tweenHit.interpolate_property($square, "modulate", colHit, originalColor, hitTime*5, 0, 2, hitTime*5)
	tweenHit.start()
	pass # Replace with function body.

func _init_stats():
	var random = RandomNumberGenerator.new()
	random.randomize()
	speed = random.randi_range(speedMin, speedMax)
	attack = random.randi_range(attackMin, attackMax)
	timeAttack = random.randf_range(timeAttackMin, timeAttackMax)
	knockBackPixels = random.randi_range(knockBackPixelsMin, knockBackPixelsMax)
	crit_prob = random.randf_range(critProbMin, critProbMax)
	health = random.randi_range(healthMin, healthMax)

	for i in globals.buffs:
		var index = random.randi_range(0, 6)
		match index:
			0:
				speed+= speedStep
			1:
				attack+= attackStep
			2:
				timeAttack+= timeAttackStep
			3:
				timeAttack+= timeAttackStep
			4:
				health+= healthStep
			5: 
				crit_prob+= critStep
	globals.buffs = 0
	pass

func _save_previous_stats():
	globals.pSpeed = speed
	globals.pAttack = attack
	globals.pTimeAttack = timeAttack
	globals.pKnockBack = knockBackPixels
	globals.pHealth = health
	globals.pCritProb = crit_prob
	pass

func _buff():
	globals.buffs += 1
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (!pause):
		move_and_slide(Vector2(actualSpeedX,actualSpeedY))

	pass

func _on_Arma_body_entered(body):
	if (!pause):
		body._hit(position)
	pass

func set_life_ui():
	var container = gui.get_node("LifeContainer")
	var h = 0
	for life in container.get_children():
		if (h<health):
			h+=1
			life.visible = true
		else:
			life.visible = false
	pass

func _shakeCamera():
	if (!tweenCamera.is_active()):
		var rand = Vector2(0,0)
		rand.x = rand_range(-80,80)
		rand.y = rand_range(-80,80)
		var timeToShake = rand_range(0.2, 0.4)
		tweenCamera.interpolate_property($Camera2D, "offset", $Camera2D.offset, rand,timeToShake, TRANS,EASE)
		tweenCamera.interpolate_property($Camera2D, "offset", $Camera2D.offset, Vector2(0.0,0.0), timeToShake, TRANS,EASE, timeToShake)
		tweenCamera.start()
	pass


func _hit(pos, enemy):
	if (!tweenHit.is_active()):
		#_shakeCamera()
		$HitSound.pitch_scale = rand_range(0.9,1.1)
		$HitSound.play()
		var direction = pos - self.position
		direction = -direction.normalized()
		move_and_collide(direction * knockBackPixels)
		tweenHit.interpolate_property($square, "modulate", originalColor, colHit, hitTime)
		tweenHit.interpolate_property($square, "modulate", colHit, originalColor, hitTime, 0, 2, hitTime)
		tweenHit.start()
		if (enemy && enemy.name.find_last("GlitchedEnemy") != -1):
			$GlitchSound.pitch_scale = rand_range(0.9,1.1)
			$GlitchSound.play()
			$Camera2D/GUI/Glitch.visible = true
			gui.visible = false
			emit_signal("Unstable", enemy)
		elif health <= 1:
			emit_signal("End")
		else: 
			health -= 1
			set_life_ui()
		

	pass

func _process(delta):
	if (!pause):
		unstability_timer += delta
		if (unstability_timer > unstability_check):
			unstability_timer = 0
			var rand_value = rand_range(0,1)
			print("Hey unstabilityChecks " + String(rand_value))
			if (rand_value < unstability_value):
				print("UNSTABLE")
				emit_signal("Unstable")
			
		var lookTransform:= Vector2(0,0)
		if (Input.get_connected_joypads().size() > 0):
			lookTransform = Vector2(Input.get_action_strength("right_stick_right") - Input.get_action_strength("right_stick_left"), -Input.get_action_strength("right_stick_up") + Input.get_action_strength("right_stick_down"))
			lookTransform = lookTransform *100
			lookTransform = self.global_position + lookTransform
		else:
			lookTransform = get_global_mouse_position()			
		look_at(lookTransform)
		$Camera2D.global_rotation = 0.0
		if Input.is_action_pressed("ui_right"):
			actualSpeedX = speed
		elif Input.is_action_pressed("ui_left"):
			actualSpeedX = -speed
		else:
			actualSpeedX = 0

		if Input.is_action_pressed("ui_up"):
			actualSpeedY = -speed
		elif Input.is_action_pressed("ui_down"):
			actualSpeedY = speed
		else:
			actualSpeedY = 0

		if Input.is_action_just_released("ui_accept") && !is_attacking:
			$Arma/CollisionShape2D.set_disabled(false)
			timerAttack = 0
			is_attacking = true
			tween.interpolate_property($Arma, "rotation_degrees", 0, 140,timeAttack)
			tween.start()
		if is_attacking:
			timerAttack += delta
			if timerAttack > timeAttack:
				$Arma/CollisionShape2D.set_disabled(true)
				timerAttack = 0
				is_attacking = false

		
		

	pass
