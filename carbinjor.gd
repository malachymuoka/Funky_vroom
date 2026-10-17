extends Node2D

var player
var direction
var speed = 0.5
var in_range = false
var attacking:int = 0
var targeted_direction = Vector2(0,0)
var all_offf_cooldowns 
var health = 1000

#for slash
var slash_ready = true
var cur_delay = true
var cur_slash = true

#for taunt
var taunt_ready = true
var charging_up = true
var taunting_phase = true

# variable to sees if all any attacks are 
# available
var pause_inbetween_attacks: bool = false
func _ready() -> void:
	pass
func _process(delta: float)-> void:

	
	locate_and_track()
	all_off_cooldown()
	healthy_carbin()
	
	# will move to the player like normal if NONE of its moves are ready,
	# the wait period is up,or its not in range
	
	 
	if (pause_inbetween_attacks== true || in_range != true || all_offf_cooldowns == false ) && attacking <= 0:
		
		position -= speed * direction.normalized()	
	
	
	if GlobalStats.carbinjor_slash ==true && pause_inbetween_attacks == false && slash_ready==true && (attacking ==1 || attacking==0||(in_range== true && attacking == 0)) :
		carbinjor_slash()
	
	elif GlobalStats.carbinjor_taunt ==true && pause_inbetween_attacks == false && taunt_ready==true && (attacking ==2 || attacking==0||(in_range== true && attacking == 0)) && (player.find_child("cars_lock_on_area").visible == false|| attacking == 2):
		taunt()
	
		
# locates the player within the game
#Also directs it towards the player and 
# inverses its sprite based on the player's position/

func locate_and_track()->void:
	
	if player == null:
		for i in get_parent().get_children():
			if  i.get_child(0) != null:
				
				for x in i.get_children():
					if x.name == "player":
						player = x
			elif i.name == "player":
				player = i
	if player !=null:
		direction =  position - player.position
		if position.x < player.position.x:
			$"death_almighty!".flip_h = true
		else:
			$"death_almighty!".flip_h = false












# Simply dashes towards the player if they are close 
# enough by using while loops to pause parts of the 
# move. Also, the "attacking" variable is set to 1 to 
#basically tell the script which attack/function it should be 
# looping through right now 
		
func carbinjor_slash()-> void:
	attacking = 1
	
	
	#first, it stops for a bit before dashing towards the player
	
	if cur_delay == true:
		
		if $cooldowns_for_attacks/slash_cooldowns/delay.is_stopped() == true:
			GlobalScne.find_child("sound_effects").find_child("warning_for_slash").play()
			$cooldowns_for_attacks/slash_cooldowns/delay.start()
		speed= 0
		
		$"!".show()
	
	#Next, it dashes. It slowly deaccelerates while dashing	
	elif cur_slash == true:	
		$"!".hide()
		if $cooldowns_for_attacks/slash_cooldowns/slash.is_stopped() == true:	
			
			speed = 4
			targeted_direction = direction
			$cooldowns_for_attacks/slash_cooldowns/slash.start() 
		position -= speed * targeted_direction.normalized() 
		
		if speed >0:
			speed -= 0.055
		
	# speed it then set back to normal.
	# Also begins its cooldown and doesn't perform an
	# attack for 3 seconds 
	else:

		speed= 0.5
		slash_ready = false
		attacking = 0
		targeted_direction = Vector2(0,0)
		pause_inbetween_attacks = true
		cur_delay = true
		cur_slash = true
		
		$cooldowns_for_attacks/wait_period.wait_time = 3
		$cooldowns_for_attacks/wait_period.start()
		$cooldowns_for_attacks/slash_cooldowns.start()









# puts the carbinjor's slash off cooldown

func _on_slash_cooldown_timeout() -> void:
	slash_ready= true 
	$cooldowns_for_attacks/slash_cooldowns.stop()

	
# ends the delay period
	
func _on_delay_timeout() -> void:
	
	cur_delay = false # Replace with function body.

	$cooldowns_for_attacks/slash_cooldowns/delay.stop()

# ends the slash period	

func _on_slash_timeout() -> void:

	cur_slash = false # Replace with function body.
	$cooldowns_for_attacks/slash_cooldowns/slash.stop()	









# Reveals cars_lock_on_area in the player,
# Making all cars lock on the player

func taunt() -> void:
	attacking = 2
	
	
	#Gets ready to activate the area. while charging, 
	#A warning and the area gets slowly revealed to the player
	#While also brightening the carbinjor and playing a charge up effect
	
	if charging_up == true:
		
		if $cooldowns_for_attacks/taunt/charging.is_stopped() == true:
			$cooldowns_for_attacks/taunt/charging.start()
			$"!"/charging_up.play()
		# sets both warning visible (along with their parent
		
	
		if  player.find_child("taunt_warning").visible ==false:
			player.find_child("taunt_warning").visible = true
		if player.find_child("area_warning").visible ==false:
			player.find_child("area_warning").visible = true
		
		#Slowly increases their visibility
		
		player.find_child("taunt_warning").modulate.a += 0.005
		player.find_child("area_warning").modulate.a += 0.001
		player.find_child("area_warning").rotation+= 0.5
		position -= (speed * direction.normalized())/4
		modulate+= Color(0.05, 0.05, 0.05)
	
	# activates the player's cars_lock_on_area 
	
	elif taunting_phase == true:
		
		if $cooldowns_for_attacks/taunt/taunting.is_stopped() == true:
			$cooldowns_for_attacks/taunt/taunting.start()
		
		player.find_child("cars_lock_on_area").visible = true
		player.find_child("area_warning").rotation+= 2
		position -= (speed * direction.normalized())/2
	else:
		$"!"/charging_up.stop()
		$cooldowns_for_attacks/taunt.start()
		taunt_ready = false
		taunting_phase = true
		charging_up = true
		
		attacking= 0
		$cooldowns_for_attacks/wait_period.wait_time = 3
		$cooldowns_for_attacks/wait_period.start()


#puts taunt off cooldown

func _on_taunt_timeout() -> void:
	taunt_ready = true
	$cooldowns_for_attacks/taunt.stop()


#ends charging phase while making the warning invisible again
# and resets its along with the warning's modulates

func _on_charging_timeout() -> void:
	player.find_child("taunt_warning").visible == false
	player.find_child("taunt_warning").modulate.a = 0
	modulate = Color(1, 1, 1)
	charging_up = false
	$cooldowns_for_attacks/taunt/charging.stop()

#ends taunting phasewhile making the area invisible again
# and resets its along with the area's modulates

func _on_taunting_timeout() -> void:
	
	player.find_child("cars_lock_on_area").visible = false
	player.find_child("area_warning").visible = false
	player.find_child("area_warning").modulate.a = 0
	player.find_child("area_warning").rotation = 0
	taunting_phase = false
	$cooldowns_for_attacks/taunt/taunting.stop()
















#checks to see if any attacks are off cooldown

func all_off_cooldown()->void:
	if (slash_ready == true && GlobalStats.carbinjor_slash) || (taunt_ready && GlobalStats.carbinjor_taunt)== true:
		all_offf_cooldowns = true
	else:
		all_offf_cooldowns = false
	

# On timing out, carbinjor can now do a special move 

func _on_wait_period_timeout() -> void:
	pause_inbetween_attacks= false 

	$cooldowns_for_attacks/wait_period.stop()



# if health goes reaches/m goes below 0, then IT DIES 
# and the player gets a carbinjor head. In addition
# if it was in the gaming scene, it kills every other 
#  carbinjor permanentlyand begins the finally .Also makes a
# manly scream
func healthy_carbin()-> void:
	if health <= 0:
		GlobalStats.carbinjor_heads +=1
		if taunting_phase == true:
			player.find_child("cars_lock_on_area").visible = false
			player.find_child("area_warning").visible = false
			player.find_child("area_warning").modulate.a = 0
			player.find_child("area_warning").rotation = 0
			player.find_child("taunt_warning").visible == false
			player.find_child("taunt_warning").modulate.a = 0
			modulate = Color(1, 1, 1)
		GlobalScne.find_child("sound_effects").find_child("manly_scream").play()
		
		if get_tree().current_scene.name == "Gaming":
			
			get_tree().current_scene.REMOVE_CARBINJORS_PERMANENTLY()
		queue_free()
		
		


# Both functions detect the player in range

func _on_detection_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player":
		in_range = true
		#print(in_range)
	
		
		



func _on_detection_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player":
		in_range = false
		#print(in_range)

#if it makes contact with a sword or bullet, then it gets hurt


	
