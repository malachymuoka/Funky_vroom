extends CharacterBody2D
# REMEMBER THAT THE PLAYER'S COLLISION IS WHAT
# SENDS IT BACK TO THE BEGINNING AND AREA_OF DEATH
# IS WHAT HURTS IT

var hor = 0
var ver = 0
var speed: int 
var diy: int
var dix: int
var direction: Vector2 = Vector2(0,0) 
var god_mode: bool = false
var invin:bool = false
var special_invin:bool = false
var bullet_count = 6
var loaded = false
var parry: bool = false
var par_wait:bool = false
var par_streak = 0
var par_success = false



var health = 10
var MAG = 1
var DEX = 1
var STR =1

var CAN_sprint = false
var CAN_attack = false
var CAN_teleport = false
var CAN_PARRY = false

var can_move_after_an_attack_from_time = true
var can_attack_from_time  =true
var can_warp_from_time = true
var can_PARRY_from_time = true

#variables for buying items

var chu_ching: int =0
var can_start_buying: bool = false
var name_of_item: String 
var value: int


	
func _ready() -> void:
	speed = 100 *DEX
	
	pass 


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(_delta: float) -> void:
	
	
	#all conditional methods in the process function
	GLOBAL_STATS()
	if CAN_teleport and can_warp_from_time and can_move_after_an_attack_from_time:
		teleport()
	if CAN_attack and can_attack_from_time and bullet_count>0:
		ATTACK()
	if CAN_PARRY and can_PARRY_from_time and (parry == true || Input.is_action_just_pressed("parry")):
		PARRY()
	DISPLAY_ATTACK()
	if can_start_buying:
		money_system()
		
	#all NON conditional methods in the process function		
	
	need_to_reload()
	I_AM_INVINCIBLE()
	DISPLAY_HEALTH()
	control_time()
	GOD_MODE()
	direc()
	money_count()
	die_of_death(false)
	mute()
	
# Controls how the player moves and collides with other objects

func _physics_process(_delta: float) -> void:
	
	#The line of code basically prevents the player 
	#from moving after attacking with their weapon
	if can_move_after_an_attack_from_time && parry == false:
		direction = Input.get_vector("left","right","up","down")
		velocity = direction*speed
		move_and_slide() 
		animate()
	else:
		$Sprite2D.frame =0
	
	HURRY_UP()
		
		
		
		
#______		                               |     |
#|		|       |  ______     ______       |                            _________
#|__    |	    | |      |   |        ---------  |     ____________    |         |                
#|		|       | |      |   |             |     |     |          |    |         |
#|		|       | |      |   |             |     |     |          |    |         | 
#|	    |_______| |      |   |______       |     |     |__________|    |         |

		
		
		
		
		
		
		
		
		
		
	
# Animation for the player based on the diretion they are
# going.	

func animate():
	if direction:
		if direction.x == -1 :
			$Sprite2D.animation = "left"
		if direction.x == 1 :
			$Sprite2D.animation = "right"
		if( direction.x == 0):
			if direction.y == -1:
				$Sprite2D.animation = "up"
			if direction.y ==1:
				$Sprite2D.animation = "down"
	
	else:
		$Sprite2D.frame =0
# simply mutes the background music
func mute()-> void:
	if Input.is_action_just_pressed("mute"):
		if GlobalScne.get_child(0).audio == false:
			GlobalScne.get_child(0).audio = true
			GlobalScne.get_child(0).stream.loop = true
			GlobalScne.get_child(0).stream_paused = false
			
		elif GlobalScne.get_child(0).audio == true:
			GlobalScne.get_child(0).audio = false
			GlobalScne.get_child(0).stream.loop = false
			GlobalScne.get_child(0).stream_paused = true
		
		
# Simply causes the player to sprint if they have the shoes
#Also speeds up their animation

func HURRY_UP():
	
	if Input.is_action_pressed("sprint"):
		
		$Sprite2D.set_speed_scale(1.4)
		speed = 200 *DEX
		
	else :
		$Sprite2D.set_speed_scale(1.0) 
		speed = 100 +(15*DEX)
			

# if the player has the parry, once the player clicks on
# the parry button, it will start the parry Phase
# If hit during this phase, then the child will ignore all damage,
# kill the thing that hurt them, and its cooldown is lowered

func PARRY()-> void:
		
		if parry == false:
		
			parry = true
			par_wait= true
			$Node/parry_fail_success.start()
			modulate= Color(20.0, 20.0, 20.0)
			$PAR_SPLING.show()
		if par_wait == true:
			
			pass
		else:
			if par_success == false:
				GlobalStats.par_streak = 0
			parry = false
			can_PARRY_from_time = false
			par_success = false
			$Node/PARRY.start()
			
		
	
# causes the player to go godmode by setting 
# its layer 1 and masks values to false if
# god_mode is true 

func GOD_MODE()->void:
	if god_mode == true:	
		set_collision_layer_value(1,false)	
		$"area_of death".set_collision_mask_value(3, false)
		$"area_of death".set_collision_mask_value(5, false)
	else:
		set_collision_layer_value(1,true)	
		
#upon getting hit by a move that doesn't instantly kill the
# player, the invincibility frames will kick in.
#Functions basically like GOD_MODE but it goes away after a second
#and doesn't ignore the carbinjor( unless special invincibility is 
# triggered)
#wanted to do the meme but it would make it too long

func I_AM_INVINCIBLE()-> void:
	if invin == true:		
		$Sprite2D.modulate= Color(2.0, 2.0, 2.0)
		$"area_of death".set_collision_mask_value(3, false)
		if special_invin == true:
			$"area_of death".set_collision_mask_value(5, false)
		# makes the player invincible to instant death
		
		#$"area_of death".set_collision_mask_value(5, false)
		
	else:
		$Sprite2D.modulate= Color(1.0, 1.0, 1.0)
		$"area_of death".set_collision_mask_value(3, true)
		$"area_of death".set_collision_mask_value(5, true)
		# makes the player invincible to instant death
		
		

# displays the thing your're using to 
#Stab/shoot things to death. Also, if you
# have the bulletkin gun, displays the amount of
#bullets you have.


func DISPLAY_ATTACK()->void:
	#variables I am using for this function
	var weapon_image = $Camera2D/CanvasLayer/display_weapon/what_weapon_is
	var amount_of_bullets_to_hid:int = 6 - bullet_count
	
	if CAN_attack:
		$Camera2D/CanvasLayer/display_weapon.show()
		
		if GlobalStats.weapon == true:
			$Camera2D/CanvasLayer/display_bullet.show()
		else:
			$Camera2D/CanvasLayer/display_bullet.hide()
	else:
		$Camera2D/CanvasLayer/display_weapon.hide()
		$Camera2D/CanvasLayer/display_bullet.hide()
	#if the weapon is Car_Buster, then it will change 
	#the sprite to a sword. If they have the gun, then
	#then it'll show bullet_buster
	
	if GlobalStats.weapon == false:
		weapon_image.position = Vector2(1080.5,512.5)
		weapon_image.scale = Vector2(4.611,5.7)
		weapon_image.texture = preload("res://graphics/stuff_I_made/sw-pixilart.png")
	elif GlobalStats.weapon == true:
		weapon_image.position = Vector2(1085.5,509)
		weapon_image.scale = Vector2(0.74,1.1)
		weapon_image.texture = preload("res://graphics/stuff_I_made/weed-pixilart.png")
		
	for i in range(1,amount_of_bullets_to_hid+1):
		#print($Camera2D/CanvasLayer/display_bullet.get_child(i).name)
		$Camera2D/CanvasLayer/display_bullet.get_child(i).hide()
	

# displays your health

func DISPLAY_HEALTH()-> void:
	var remov = 10-( GlobalStats.health)
	var add = GlobalStats.health
	var list = $Camera2D/CanvasLayer/display_health.get_children()
	list = list.slice(1,list.size())
	
	# part that hides health
	
	list.reverse()
	for i in list:
		for n in i.get_children():
			if remov > 0:
				
				n.hide()
				remov -=1
	
	#part that shows health
	
	list.reverse()
	for i in list:
		i = i.get_children()
		i.reverse()
		for n in i:
			if add > 0:
				
				n.show()
				add-=1
	
# Stab/shoot things to death

func ATTACK()->void:
	if Input.is_action_just_pressed("attack!"):
		# creates the actual sword/gun based on
		#GlobalStats.weapon. if it's false, then 
		# the player will use the sword
		#,otherwise,they'll use the gun
		var stabby_mic_shotty
		if GlobalStats.weapon == false:
			stabby_mic_shotty =preload("res://weapon.tscn").instantiate()
		elif GlobalStats.weapon == true:
			stabby_mic_shotty =preload("res://weapon_that_gun.tscn").instantiate()
			
		#determines the sword's/gun's location and rotation 
		#based on dix and diy
		
		#SWORD
		
		if stabby_mic_shotty.name == "Car_Buster":
			stabby_mic_shotty.damage = 50 * (1 + 0.1 *(GlobalStats.STR))
			GlobalScne.find_child("sound_effects").find_child("sword_slash").play(0.5)
			if dix == 1:
				stabby_mic_shotty.position =  Vector2(20,0)
				stabby_mic_shotty.rotation_degrees +=90
				
			elif dix == -1:
				stabby_mic_shotty.position = Vector2(-20,0)
				stabby_mic_shotty.rotation_degrees -=90

			if diy == 1:
				stabby_mic_shotty.position = Vector2(0,20)
				stabby_mic_shotty.rotation_degrees -= 180
				
			elif diy == -1:
				stabby_mic_shotty.position =Vector2(0,-20)
				stabby_mic_shotty.rotation_degrees=0
				
		
		#GUN
		
		elif stabby_mic_shotty.name == "Bullet_buster":
			
			GlobalScne.find_child("sound_effects").find_child("shot").play()
			if bullet_count>0:
				bullet_count -=1
			if bullet_count<=0:
				loaded = false
			if dix == 1:
				stabby_mic_shotty.position +=  Vector2(14,0)
				stabby_mic_shotty.get_node("pew_pew").flip_h = true
				stabby_mic_shotty.direction_gun = Vector2(1,0)
				
			elif dix == -1:
			
				stabby_mic_shotty.position += Vector2(-12,0)
				stabby_mic_shotty.rotation_degrees =0
				stabby_mic_shotty.direction_gun = Vector2(-1,0)
			if diy == 1:
				stabby_mic_shotty.position += Vector2(0,14)
				stabby_mic_shotty.rotation_degrees-=90 
				stabby_mic_shotty.direction_gun = Vector2(0,1)
			elif diy == -1:
				stabby_mic_shotty.position +=Vector2(0,-14)
				stabby_mic_shotty.rotation_degrees= 90
				stabby_mic_shotty.direction_gun = Vector2(0,-1)
			
		#(hopfully) spawns the sword's/gun's infront of the player
	 
		add_child(stabby_mic_shotty)
		can_attack_from_time = false
		can_move_after_an_attack_from_time = false
		
# TELEPORTATION!!

func teleport()->void: 
			
	# the ACTUAL teleporting part
	
	if  Input.is_action_just_pressed("telep"):
		position = Vector2(position.x+ dix *20* GlobalStats.MAG,position.y+diy * 20 * GlobalStats.MAG)
		can_warp_from_time = false
		
		
# determines the direction of things	
	
func direc()->void:
	if $Sprite2D.animation == "left":
		dix= -1
	elif $Sprite2D.animation == "right":
		dix= 1
	else: 
		dix = 0
		
	if $Sprite2D.animation == "up":
		diy= -1
	elif $Sprite2D.animation == "down":
		diy= 1
	else: 
		diy = 0



#Warp's cool down

func _on_warp_time_timeout() -> void:
# teleport's cooldown

	if can_warp_from_time == false:
		can_warp_from_time = true 
	
# Attack's cooldown

func _on_attack_time_timeout() -> void:
	if can_attack_from_time == false:

		can_attack_from_time = true

 # Resests PARRY'S cooldown

func _on_parry_timeout() -> void:
	if can_PARRY_from_time == false:
		if $Node/PARRY.wait_time <= 0.5:
			$Node/PARRY.wait_time = 1
		can_PARRY_from_time = true
		$Node/PARRY.stop()

# triggers the following effects when parry_fail_success times out
# or a parry was succesful

func _on_parry_fail_success_timeout() -> void:
	par_wait = false
	$PAR_SPLING.hide()
	modulate= Color(1.0,1.0, 1.0)
	$Node/parry_fail_success.stop()
	
# controls when the player can move after an attack

func _on_moving_after_attacking_timeout() -> void:
	
	can_move_after_an_attack_from_time = true

#disable/re-enabling the timers by first pausing them when
#the player can do a move again and unpausing them 
#when the player performs the actions

func control_time()->void:
	#teleport
	
	if can_warp_from_time == true:
		$Node/warp_time.paused = true
	else:
		
		$Node/warp_time.paused = false
		
	# attack
	
	if can_attack_from_time == true:
		$Node/attack_time.paused = true
		
	else:
		
		$Node/attack_time.paused = false
		
	
	
	
	# Moving AFTER an attack
	
	if can_move_after_an_attack_from_time == true:
		$Node/moving_after_attacking.paused = true
		
	else: 
		$Node/moving_after_attacking.paused = false


# displays the amount of coins the player
#currently has
func money_count()->void:
	$Camera2D/CanvasLayer/Label.text = str(GlobalStats.chu_ching)

 # changes maain scene


	

#when the player enters the shop, they
#Will be sent to the shop scene. Also lets 
#a player pull up the ui to buy something 
#upon getting close to a bin/stand
# That and it will also instantly kill the player
# if they touch an object that's on layer 5, or if
# it's on the 3rd layer, then it will only hurt the player
#Also if its a car then it will trigger special invinciblility 
# where the player can't be hurt or instant killed
#Also determines whether a parry was successful or not.
# If it was, then the player will parry the attack and reduce 
# the cooldown of the next parry. Normally, this would istantly kill
# whatever enemy created/ was part of the attack, however, if 
# said attack would instantly kill the player, the enemy would be stunned
# instead
# if the player is in range of a key or coin, it will be collected

func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.name == "to_shop" || area.name == "back_to_shop_from_parther":
		call_deferred("change_scene_to_shop")
	if area.name == "leave_shop":
		call_deferred("change_scene_to_gaming")
	if area.name == "to_parther_world":
		call_deferred("change_scene_to_PARRY")
	if area.get_parent().name.substr(0,3) == "bin":
		name_of_item = area.get_parent().name	
		can_start_buying = true
		$Camera2D/CanvasLayer/buy_buttton.show()
	if area.name == "Sell_bin":
		$Camera2D/CanvasLayer/sell_buttton.show()
	if area.name == "BUY_PARRY":
		if GlobalStats.carbinjor_heads >0 :
			$Camera2D/CanvasLayer/special_buy_button.show()
		else:
			$Camera2D/CanvasLayer/angelic_hint.show()
	if area.name == "lock_interact_Area":
		if GlobalStats.Da_angel_key == true:
			area.get_parent().queue_free()
			GlobalStats.Da_angel_key = false
			$Camera2D/CanvasLayer/angelic_hint_for_key.hide()
			GlobalStats.parther_door_unlocked = true
			GlobalScne.find_child("sound_effects").find_child("unlock").play()
		else:
			$Camera2D/CanvasLayer/angelic_hint_for_key.show()
	if 	area.get_collision_layer_value(5) == true:
		die_of_death(true)
	if area.get_collision_layer_value(3) == true:
		$Node/invincibility.start()
		$"Sprite2D".self_modulate.lightened(1)
		invin = true
		
		if parry == true:
			area.queue_free()
			$"no_sugar".play(0)
			$Node/parry_fail_success.emit_signal("timeout")
			$Node/PARRY.wait_time == 0.5
			special_invin = true
			par_success = true		
			GlobalStats.chu_ching += 1+GlobalStats.par_streak
			GlobalStats.par_streak +=1
			
			pass
		
		else:
			$"oof".play(0.35)
			GlobalStats.health-=1
			
		
	
		
		
		

#Stops player from pull up the ui to buy something 
#upon leaving a bin/stand. Also clears name_of_item
# and value

func _on_area_2d_area_exited(area: Area2D) -> void:
	
	if area.get_parent().name.substr(0,3) == "bin":
		can_start_buying = false
		$Camera2D/CanvasLayer/buy_buttton.hide()
		value = 0
		name_of_item =""
	if area.name == "Sell_bin":
		$Camera2D/CanvasLayer/sell_buttton.hide()
	if area.name == "BUY_PARRY":
		$Camera2D/CanvasLayer/special_buy_button.hide()
		$Camera2D/CanvasLayer/angelic_hint.hide()
	if area.name == "lock_interact_Area":
		$Camera2D/CanvasLayer/angelic_hint_for_key.hide()	
#Main System that controls the way the player purchases items

func money_system()->void:
	if name_of_item == "bin_shoe":
		value = 2
	elif name_of_item == "bin_teleport":
		value = 7
	elif name_of_item == "bin_buster":
		value = 10
	elif name_of_item == "bin_shooter":
		value= 30
	elif name_of_item == "bin_magic" ||  name_of_item == "bin_strength" ||  name_of_item == "bin_dex"  :
		value = 5
	elif name_of_item == "bin_full_heal":
		value =6 *(10-GlobalStats.health)
	elif name_of_item == "bin_heal":
		value =8
	
	
	$Camera2D/CanvasLayer/buy_buttton/Label.text = "Would you like to \n buy: "+ name_of_item + " for " + str(value)
	
	
	
	
	
		
#OTHER Main System that determines if a player buys something depending 
#on how much money they have

func _on_button_button_down()->void:	
	if value <= GlobalStats.chu_ching:
		GlobalScne.find_child("sound_effects").find_child("purchase").play()
		
		GlobalStats.chu_ching-=value
		print(GlobalStats.chu_ching)
		if name_of_item == "bin_shoe":
			GlobalStats.CAN_sprint = true
		elif name_of_item == "bin_teleport":
			GlobalStats.CAN_teleport = true
			print( GlobalStats.CAN_teleport)
			print( CAN_teleport)
			
		elif name_of_item == "bin_buster":
			GlobalStats.CAN_attack = true
			GlobalStats.weapon = false
		elif name_of_item == "bin_shooter":
			GlobalStats.CAN_attack = true
			GlobalStats.weapon = true
		elif name_of_item == "bin_strength":
			GlobalStats.STR+= 1
		elif name_of_item == "bin_magic":
			GlobalStats.MAG+= 1
		elif name_of_item == "bin_dex":
			GlobalStats.DEX+= 1
			
		elif name_of_item == "bin_full_heal":
			GlobalStats.health = 10
		elif name_of_item == "bin_heal":
			GlobalStats.health +=1
			
	else:
		print("sorry, but you can't buy " +name_of_item)
		
		
#using the global script global_stats
#, updates the player's current stats
# and what they can do

func GLOBAL_STATS()->void:
	CAN_sprint = GlobalStats.CAN_sprint
	CAN_attack = GlobalStats.CAN_attack
	CAN_teleport = GlobalStats.CAN_teleport
	CAN_PARRY =GlobalStats.CAN_PARRY
	
	MAG = GlobalStats.MAG
	DEX = GlobalStats.DEX
	STR = GlobalStats.STR
	
	

# reloads the gun if they have it.
# I mean it's kindof in the the name of the function
# dumbass (okay it also shows all the bullet pngs in 
# display_bullet but that should've also been obvious as well) 

func _on_reload_time_timeout() -> void:
	bullet_count = 6
	GlobalScne.find_child("sound_effects").find_child("reload").play()
	$Node/reload_time.stop()
	for i in $Camera2D/CanvasLayer/display_bullet.get_children():
		i.show()
	
	
	
# checks to see if the gun needs to be reloaded

func need_to_reload()->void:
	
	if bullet_count<=0 and loaded == false:
		loaded = true
		
		$Node/reload_time.start()


func change_scene_to_shop()->void:
	get_tree().change_scene_to_file("res://shop_area.tscn")
	
func change_scene_to_gaming()->void:
	get_tree().change_scene_to_file("res://gaming.tscn")
func change_scene_to_PARRY()-> void:
	get_tree().change_scene_to_file("res://PARRY.tscn")

#  When pressing the sell button
# , you seell everythign you have ( in game, of course

func _on_button_pressed() -> void:
	# basic stat upgrades
	if GlobalStats.MAG >=1:
		GlobalStats.chu_ching += 5*(GlobalStats.MAG-1)
		GlobalStats.MAG= 1
	if GlobalStats.STR >=1:
		GlobalStats.chu_ching += 5*(GlobalStats.STR-1)
		GlobalStats.STR= 1
	if GlobalStats.DEX >=1:
		GlobalStats.chu_ching += 5*(GlobalStats.DEX-1)
		GlobalStats.DEX= 1
	
	# unique upgrades 
	if GlobalStats.CAN_attack == true:
		if GlobalStats.weapon == true:
			GlobalStats.chu_ching += 30
		else:
			GlobalStats.chu_ching += 10
	GlobalStats.CAN_attack = false
	
	if GlobalStats.CAN_sprint ==true :
		GlobalStats.chu_ching += 2 
		GlobalStats.CAN_sprint = false
	if GlobalStats.CAN_teleport ==true:
		GlobalStats.chu_ching +=7
		GlobalStats.CAN_teleport == false

# the player dies and goes to the ded screen		
			
func die_of_death(instded:bool)->void:
	if GlobalStats.health<=0 || instded == true:
		get_tree().change_scene_to_file("res://ded_screen.tscn")
	
		
# ends both forms of invincibility

func _on_invincibility_timeout() -> void:
	
	invin = false 
	special_invin= false
	$Node/invincibility.stop()

# trades a carbinjor head for PRARY on click
func _on_special_button_pressed() -> void:
	GlobalStats.carbinjor_heads-=1 
	GlobalStats.CAN_PARRY = true
	
	
	
	
