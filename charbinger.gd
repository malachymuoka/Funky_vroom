extends Node2D

var player: CharacterBody2D
var direction: Vector2 = Vector2(0,0)


var speed: int = 1
var speed_blast:Vector2 = Vector2(0,0)
var accel: float = 0.05
var health:int = 75
var in_pain:int

var in_range: bool = true
var blast_cooldown : bool = false
var blast: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# calls the health_count method from globalstats
	
	GlobalStats.health_count(health, $".")
	
	animate()
	knockback()
	locate_and_track()
	acceleration_control()



# Controls what sprite is displayed for 
# the charbinjor

func animate():
	if blast == false:
		if direction.y >= 0 && (direction.x <= 0.5 && direction.x >= -0.5):
			$car_animate.animation = "normal_up"
			$car_animate.flip_h = false
		elif direction.y <= 0 && (direction.x <= 0.5 && direction.x >= -0.5):
			$car_animate.animation = "normal_down"
			$car_animate.flip_h = false
		elif direction.x >= 0 && (direction.y <= 0.5 && direction.y >= -0.5):
			$car_animate.animation = "normal_front"
			$car_animate.flip_h = false
		elif direction.x <= 0 && (direction.y <= 0.5 && direction.y >= -0.5):
			$car_animate.animation = "normal_front"
			$car_animate.flip_h = true
	elif blast == true:
		
		if direction.y >= 0 && (direction.x <= 0.5 && direction.x >= -0.5):
			$car_animate.animation = "charge_up"
			$car_animate.flip_h = false
		elif direction.y <= 0 && (direction.x <= 0.5 && direction.x >= -0.5):
			$car_animate.animation = "charge_down"
			$car_animate.flip_h = false
		elif direction.x >= 0 && (direction.y <= 0.5 && direction.y >= -0.5):
			$car_animate.animation = "charge_front"
			$car_animate.flip_h = false
		elif direction.x <= 0 && (direction.y <= 0.5 && direction.y >= -0.5):
			$car_animate.animation = "charge_front"
			$car_animate.flip_h = true
		

# tracks the player down by getting it from the list
# of children in the current scene 

func locate_and_track()-> void:
	if player == null:
		
		for i in get_parent().get_children():
			if i.name != "player" && i.get_child(0) != null:
				for x in i.get_children():
					if x.name == "player":
						player = x
	if player != null:
		
		direction =( position - player.position).normalized()
	



#while pain is true, the carbite is knocked away from the player
# becomes whiter to indicated it can not receive pain
func knockback():
	position += 0.3 *direction.normalized()
	

#set pain back to false, sets the 7th layer to true
# and returns to its orginal color scheme

func _on_knock_back_duration_timeout() -> void:
	$timers/knock_back_duration.stop()
	$pain.set_collision_layer_value(7, true) 
	$pain.set_collision_mask_value(6, true) 
	$pain.set_collision_mask_value(1, true) 
	modulate = Color(1.0,1.0,1.0)
	in_pain = false
	
# If a hitbox enters the pain area, then it will
# Call knockback for a set duration, brighten 
# itself and sets the 7th layer to false

func _on_pain_area_entered(area: Area2D) -> void:
	if area.get_collision_layer_value(6) == true:
		health-= area.damage
		$pain.set_collision_layer_value(7, false) 
		$pain.set_collision_mask_value(6, false) 
		$pain.set_collision_mask_value(1, false) 
		modulate = Color(2.0,2.0,2.0)
		$timers/knock_back_duration.start()
		in_pain = true

# controls the speed of the charbinjor 
# while "blast" is and isn't true o

func acceleration_control():
	if blast == false:
		position -= speed*direction
	elif blast == true:
		
		if speed_blast.length() >= 2:
			speed_blast = 2* direction 
		else: 
			speed_blast += accel*direction 
		position -= speed_blast



	
# two signals that check if the player is in range of
# the charbinjor

func _on_charge_area_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player" :
		in_range = true

func _on_charge_area_area_exited(area: Area2D) -> void:
	if area.get_parent().name == "player" :
		in_range = false
	
	

func _on_charge_duration_timeout() -> void:
	blast = false
	$timers/charge_duration.stop()
	$timers/charge_cooldown.start()
