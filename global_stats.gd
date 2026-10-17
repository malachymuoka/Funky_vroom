extends Node


# for the child

var chu_ching = 2000
var CAN_sprint = false
var CAN_attack = false
var CAN_teleport = false
var CAN_PARRY = false
var par_streak = 0
var carbinjor_heads = 0
var weapon: bool  = true
var Da_angel_key = true
var parther_door_unlocked = false
var key_for_chain_event = false

#stats( which are also for the child)
var health:int = 10
var MAG = 1
var DEX = 1
var STR =1

# for (mostly carbinjor) gaming specifically

var current_time = 0

var car_speed = 1
var carbinjor_health =200
var carbinjor_slash = false
var carbinjor_axe_spin = false
var carbinjor_taunt= false
var carbinjor_throw = false

var difficulty_ramp = 00
var increase_carbin_at = 3
var number_of_car = 0
var number_of_coins = 3
var increase_number_of_coins = 3

# for events

var chain_event = true


var final = false

var forboding = false
var trigger_5 = 0
var modu = Color(1, 1, 1.0, 1.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# fyi This is going to determine most events
func _process(delta: float) -> void:
	pass 
		
		
#deletes object if their health is below 0
func health_count(health: int, it_be_judged: Node2D):
	if health <=0:
		it_be_judged.queue_free()
	


#Reduces red and green parts of modulate 5_times
func reduce_specific_colors()-> void:
	modu -= Color(0.1,0.15,0,0)
	trigger_5+=1
	if trigger_5 >= 5:
		forboding = false
