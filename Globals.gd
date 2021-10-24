extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var enemyNumber := 2
var glitchedEnemyNumber := 1
var timerSpawn := 0.0
var currentLevel:= 0
var highScore := 0
var width:= 0
var height := 0
var alreadySended:= false
var pSpeed:= 0
var pAttack:=0
var pTimeAttack:= 0
var pCritProb:= 0
var pHealth:= 0
var pKnockBack:=0

var buffs:=0

var config = {
	"api_key": "rfp0g6PeYW72O54dlFczE5Htim5iaS8e2mwLJQeY",
	"game_id": "UnRogue",
	"game_version": "1.0.0",
	"log_level": 1
}
var SilentWolf;

func _ready():
    SilentWolf = get_node("/root/SilentWolf")
    SilentWolf.configure(config)
    pass

func _send_score(player, score):
    if (!alreadySended):
        SilentWolf.Scores.persist_score(player, score)
        alreadySended = true
    pass

func _print_HighScores():
    yield(SilentWolf.Scores.get_high_scores(), "sw_scores_received")
    print("Scores: " + str(SilentWolf.Scores.scores))
    pass

var globals_reset:= true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
