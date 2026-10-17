extends Node2D

#(pm means process_mode!)


var debug: Control = preload("res://debug.tscn").instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connects the debug button with the pressed signal
	#so when it is clicked, the player will enter god_mode
	debug.get_node("Button").connect("pressed", GOD_MODE)
	if GlobalStats.final == true:
		modulate = GlobalStats.modu
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if $player.position.x < 144:
		debug.position.x = 144;
	elif $player.position.x > 250:
		debug.position.x = 250;	
	else:
		debug.position.x  = $player.position.x
	
	if $player.position.y < 81:
		debug.position.y = 81
	elif  $player.position.y > 568:
		debug.position.y = 568
	else:
		debug.position.y = $player.position.y
	
	if Input.is_action_just_pressed("debug"):
		god_mode_debug()
	parther_door_stays_open()
	if GlobalStats.final == true:
		set_colors()
		
		
		
#pauses the game by setting all objects in gaming to pm_pausible
#if they are set to pm_inherit ( basically this makes them able 
#to be paused when the scene tree(the main scene that the program
# is on) pause boolean( which determines whether the scene is paused
#or not) is true), and then sets the gaming scene pause boolean to
#be true, or false if its already true. then, it adds the menu
# with the god_mode button( which is debug at the center of the
# screen. 	
	
func god_mode_debug()-> void:
	
	for i in get_children():
		
		if i != debug:
			if i.process_mode == PROCESS_MODE_INHERIT:
				i.process_mode = PROCESS_MODE_PAUSABLE
			else:
				i.process_mode = PROCESS_MODE_INHERIT
	get_tree().paused = !get_tree().paused
	if get_tree().paused == true:
		add_child(debug)	
	else:		
		remove_child(debug)
		
# Makes the child ignore most objects by disabling their layer
func GOD_MODE()-> void:
	
	$player.god_mode = !$player.god_mode
	print($player.god_mode)
	
# just makes sure the door stays gone when the player
#opens it

func parther_door_stays_open()-> void:
	if GlobalStats.parther_door_unlocked == true && $gate/lock in $gate.get_children():
		$gate/lock.queue_free()

# Set the colors for the finally in gaming sence
func set_colors()->void:
	modulate = GlobalStats.modu
