extends Node2D

#(pm means process_mode!)


var vroom_vroom_scene: PackedScene = preload("res://its_vroom_vroom_time.tscn")
var debug: Control = preload("res://debug.tscn").instantiate()
var coni  = preload("res://chu_coin.tscn")
var carbinjor = preload("res://carbinjor.tscn")
 
var numc =0

# for the parther key

var da_key = preload("res://da_key.tscn")

# for chain_event

var key_during_chain_event = preload("res://key_for_chain_event.tscn") 
var chain_during_chain_event = preload("res://chain_event.tscn")
var chain_event = true
# for difficulty

var difficulty_ramp = 0
var increase_carbin_at = 3
var number_of_car = 0




# for the final part of the game
var axeless_carbite_copy: PackedScene = preload("res://carbite.tscn")




func _ready() -> void:
	
	#connects the debug button with the pressed signal
	#so when it is clicked, the player will enter god_mode
	debug.get_node("Button").connect("pressed", GOD_MODE)
	
	
	if GlobalStats.final == true:
		$timers/tim.stop()
	if GlobalStats.final == false:
		THE_CARBINJOR()
	if GlobalStats.final == true:
		modulate = GlobalStats.modu
	 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	
	# sets debug to be at the center
	
	if $objects_for_game/player.position.x < 144:
		debug.position.x = 144;
	elif $objects_for_game/player.position.x > 250:
		debug.position.x = 250;	
	else:
		debug.position.x  = $objects_for_game/player.position.x
	
	if $objects_for_game/player.position.y < 81:
		debug.position.y = 81
	elif  $objects_for_game/player.position.y > 568:
		debug.position.y = 568
	else:
		debug.position.y = $objects_for_game/player.position.y
	
	if Input.is_action_just_pressed("debug"):
		god_mode_debug()
	if GlobalStats.final == true:
		set_colors()
	
# spawns the cars at specific locations
func _on_timer_timeout() -> void:
	
	var deth_crs = vroom_vroom_scene.instantiate()
	deth_crs.speed *= GlobalStats.car_speed
	var pos = $places_where_cars_spawn.get_children().pick_random().position
	deth_crs.position =  pos+ ($places_where_cars_spawn.position )
	
	$objects_for_game.add_child(deth_crs,0)
	deth_crs.y_sort_enabled = true
	deth_crs.connect("body_entered", kill_da_child)
	# Replace with function body.

# sets the child to its original position. Also triggers special invincibility
func kill_da_child(body)-> void:
	
	if(body.name == "player" ):
			GlobalStats.chu_ching+=1
			if body.parry == false :
				#if body.invin == false:
				body.special_invin = true
				$objects_for_game/player.position = Vector2(195,625)
				
		
		
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
	
	$objects_for_game/player.god_mode = !$objects_for_game/player.god_mode
	print($objects_for_game/player.god_mode)

#- Sends the player back to their original position (WITH INVINCIBILITY
# SO THAT DUMBASS CAR WOULD STOP INSTANT KILLING M- ahem I mean the player) and 
# - speeds up the cars along with their spawn rates
# - gives the player some death coins  
#-  repositions all carbinjors along with the coins
# - once the difficulty is pass 7, there will be a 25% chance for the chain event
# to begin
#- chain event, the parther key, carbinjors(for now)
# and coins will not spawn during the finally

func _on_finish_body_entered(body: Node2D) -> void:
	
	# gives the player money
	
	GlobalStats.chu_ching+=10 
	
	# handles spawning/repositioning the carbinjor
	
	if GlobalStats.final == false:
		THE_CARBINJOR()
		for i in get_children():
			if i.name == "carbinjor":
				i.position = Vector2(randf_range(90,325),450)
				
	$objects_for_game/player.position = Vector2(195,625) # Replace with function body.
	
	# Changes the modulate of the shop and gaming nodes
	# To set the mood of the finally 
	if GlobalStats.forboding == true:
		GlobalStats.reduce_specific_colors()
	if GlobalStats.chain_event== true:
		GlobalStats.chu_ching+=10 
	
	#upgrades regular cars
	
	GlobalStats.car_speed +=0.07
	$timers/tim.wait_time -= 0.01
	GlobalStats.difficulty_ramp+=1
	
	#Creates the chain
	if GlobalStats.chain_event == true:
		GlobalStats.chain_event = false
	if randi_range(1,4) == 1 && GlobalStats.difficulty_ramp >= 7 && GlobalStats.final == false:
		GlobalStats.chain_event == true
		spawn_key_and_chain()
	
	#Spawns and clears all coins
	clear_coin( )
	if GlobalStats. difficulty_ramp >= 5:
		numc =GlobalStats.number_of_coins
	if difficulty_ramp >=5 && da_key.instantiate().name not in get_children().map((func(c): return c.name)) :
		var ran = randi_range(1,4)
		if ran == 1:
			
			spawn_da_key()
	$objects_for_game/player.invin = true 
	$objects_for_game/player.special_invin = true 
	$objects_for_game/player/Node/invincibility.start()
	increas_coins()
	make_coin()
	

# randomly spawns coins around the map for the player
func make_coin( )-> void:
	var num = 0
	
	for i in range(0,numc):
		var n_coin = coni.instantiate()
		var x =0
		var y = 0
		while true:
			x = randf_range(135,385)
			y = randf_range(135,525)
			if y > 391 ||  y< 371:
				n_coin.position = Vector2(x,y)
				break
		n_coin.name = n_coin.name + str(num)
		num+=1
		$objects_for_game.add_child(n_coin)
		numc-=1
# will clear out each coin on the screen

func clear_coin( )-> void:
	
	for i in get_children():
		if i.name.substr(0,8) == "chu_coin":
			i.queue_free()

#increases the number of coins spawned every other lap

func increas_coins()-> void:
	if GlobalStats.increase_number_of_coins == 0:
		GlobalStats.number_of_coins+=1
		GlobalStats.increase_number_of_coins =4
	else:
		GlobalStats.increase_number_of_coins-=1

# spawns a number of carbinjors at random locations 
# and impowers them depending on difficulty

func THE_CARBINJOR()->void:
	if GlobalStats.difficulty_ramp >= GlobalStats.increase_carbin_at:
		GlobalStats.number_of_car+=1
		GlobalStats.increase_carbin_at+=17
	
	var num = 0
	
	for i in get_children():
		
		if i.name == "carbinjor":
			num += 1
	
	if GlobalStats.difficulty_ramp >= 4:
		GlobalStats.carbinjor_slash = true			
	if GlobalStats.difficulty_ramp >= 6:
		GlobalStats.carbinjor_axe_spin= true
	if GlobalStats.difficulty_ramp >= 8:
		GlobalStats.carbinjor_taunt= true
	if GlobalStats.difficulty_ramp >= 9:
		GlobalStats.carbinjor_throw= true
	if num < GlobalStats.number_of_car:
		var thing = carbinjor.instantiate()
		
		thing.position = Vector2(randf_range(90,325),450)
		add_child(thing)
	
		
		
# has a chance to spawns the (slighty transluscent) key to parther at a random location		
		
func spawn_da_key()->void:
	
	var key = da_key.instantiate()
	var x =0
	var y = 0
	while true:
		
		x = randf_range(135,385)
		y = randf_range(135,525)
		if y > 391 ||  y< 371:
			key.position = Vector2(x,y)
			break
		else:
			continue
	add_child(key)

# spawns the key at a random location and the chain 

func spawn_key_and_chain()-> void:
	var x =0
	var y = 0
	var key_copy = key_during_chain_event.instantiate() 
	var chain_copy = chain_during_chain_event.instantiate()
	add_child(key_copy)
	add_child(chain_copy)
	chain_copy.global_position = Vector2(190,130)
	while true:
		
		x = randf_range(135,385)
		y = randf_range(135,525)
		if y > 391 ||  y< 371:
			key_copy.global_position = Vector2(x,y)
			break
		else:
			continue
	


#kills ever carbinjor permanently and begins the 
#Finally. ALso halts tim timer to prevent cars from 
# Spawning
func REMOVE_CARBINJORS_PERMANENTLY()->void:
	
	for i in get_children():
		if i.name == "carbinjor":
			i.queue_free()
	GlobalStats.final = true
	GlobalStats.forboding = true
	
	GlobalStats.reduce_specific_colors()
	$timers/tim.stop()

# Set the colors for the finally in gaming sence
func set_colors()->void:
	modulate = GlobalStats.modu
	


# when the carbinjor dies, this function spawns 
# waves of enemys at preset
# locations for the player to fight every lap
# the player must get through 10 of these waves to
# initiate the final boss fight

func finally_engaged()-> void:
	pass
	
