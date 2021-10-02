extends KinematicBody2D

signal Unstable
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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

var originalColor:Color
export var hitTime:= 0.3
export var crit_prob = 0.2
export var unstability_value := 0.3
export var unstability_check := 3
var unstability_timer:= 0.0
export var timeAttack := 0.5
export var knockBackPixels := 100
var pause = false
# Called when the node enters the scene tree for the first time.
func _ready():
	originalColor = self.modulate
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (!pause):
		move_and_slide(Vector2(actualSpeedX,actualSpeedY))

	pass

func _on_Arma_body_entered(body):
	body._hit(position)
	pass


func _hit(pos, enemy):
	if (!tweenHit.is_active()):
		var direction = pos - self.position
		direction = -direction.normalized()
		move_and_collide(direction * knockBackPixels)
		health -= 1
		tweenHit.interpolate_property(self, "modulate", originalColor, colHit, hitTime)
		tweenHit.interpolate_property(self, "modulate", colHit, originalColor, hitTime, 0, 2, hitTime)
		tweenHit.start()
		if (enemy.name.find_last("GlitchedEnemy") != -1):
			emit_signal("Unstable", enemy)
		elif health <= 0:
			get_tree().reload_current_scene()
		

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
			
		var mouseposition = get_global_mouse_position()
		look_at(mouseposition)

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
