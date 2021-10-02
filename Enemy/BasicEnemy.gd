extends KinematicBody2D

onready var tween = $Tween
export var health:= 3
export var hitTime := 0.2
export(Color, RGBA) var colHit

var originalColor:Color

export var speed := 200

var actualSpeed : Vector2

var target
var knockBackPixels := 100
var pause = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	originalColor = self.modulate
	pass # Replace with function body.

func _on_Area2D_body_entered(body):
	if (body.name == "Player"):
		target = body
	pass

func _hit(pos):
	health -= target.attack
	if (rand_range(0,1) < target.crit_prob):
		health-= target.attack
	var direction = pos - self.position
	direction = -direction.normalized()
	move_and_collide(direction * knockBackPixels)
	tween.interpolate_property(self, "modulate", originalColor, colHit, hitTime)
	tween.interpolate_property(self, "modulate", colHit, originalColor, hitTime, 0, 2, hitTime)
	tween.start()
	if (health <= 0):
		_destroy()
	pass

func _destroy():
	pause = true
	$CollisionShape2D.queue_free()
	self.visible = false
	pass

func _physics_process(delta):
	if (!pause):
		move_and_slide(actualSpeed)

		for i in get_slide_count():
			var collision = get_slide_collision(i)
			if (collision.collider.name == "Player"):
				collision.collider._hit(position, self)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target :
		var direction = target.position - self.position
		direction =	direction.normalized()
		actualSpeed = direction * speed
	if  tween.is_active():
		actualSpeed = Vector2(0,0)
	pass