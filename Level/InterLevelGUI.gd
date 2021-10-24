extends Control
onready var tween = $Tween

onready var globals = get_node("/root/Globals")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var level
var levelNumber
var timer := 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func _start(speed,attack, timeAttack, crit, health, knockBack):
	tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1),0.4);
	tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0),1,0, 2, 2.5); 
	if (timer < 3):
		tween.start();
	level.pause(true)
	$Label.text = "LEVEL " + String(levelNumber)
	$StatsContainer/StatSpeed._setValue(speed, globals.pSpeed)
	$StatsContainer/StatTimeAttack._setValue(timeAttack, globals.pTimeAttack)
	$StatsContainer/StatAttack._setValue(attack, globals.pAttack)
	$StatsContainer/StatCrit._setValue(crit, globals.pCritProb)
	$StatsContainer/StatHealth._setValue(health, globals.pHealth)
	$StatsContainer/StatKnock._setValue(knockBack, globals.pKnockBack)
	pass

func _zeroLevel():
	visible = false
	timer = 5
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+= delta
	if (timer > 1 && !tween.is_active()):
		level.pause(false)
		queue_free()
	pass
