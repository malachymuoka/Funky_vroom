extends Node2D

var player:CharacterBody2D
var axe:Node2D = preload("res://small_axe.tscn").instantiate()
var direction:Vector2 = Vector2(0,0)


var speed = 0.5
var accel = 0.015
var health = 100
var in_pain = false
var slow = false
var has_axe = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if has_axe == true:
		add_child(axe)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# calls the health_count method from globalstats
	
	GlobalStats.health_count(health, $".")
	
	acceleration_control()
	locate_and_track()
	if in_pain == true:
		knockback()
	else:
		position -= speed *direction.normalized()
	
	if has_axe == true:
		
		if $slow_down.transform.get_scale() != Vector2(2.5, 2.5):
			$slow_down.scale =  Vector2(2.5, 2.5)
	
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
		
		direction = position - player.position
		if player.position.x >= position.x:
			$the_car_sprite.flip_h = true
		else:
			$the_car_sprite.flip_h = false

# Controls the acceleration of the carbite

func acceleration_control():
	if speed < 1.2 && slow == false:
		speed+=accel
		
			
	elif slow == true:
		if has_axe == false &&speed >0.8:
			speed-=accel*1.5
		elif has_axe == true &&speed >0.35:
			speed-=accel*2
			axe.spin = true

#while pain is true, the carbite is knocked away from the player
# becomes whiter to indicated it can not receive pain
func knockback():
	position += 0.3 *direction.normalized()
	
# if a carbite is too close to the player,
#sets "slow" to true, Slowing down the carbite

func _on_slow_down_body_entered(body: Node2D):
	if body.name == "player":
		slow = true
		axe.spin = true

# Sets "slow" to false if the carbite is far
#Away enough from the player

func _on_slow_down_body_exited(body: Node2D):
	if body.name == "player":
		slow = false
		axe.spin = false

#set pain back to false, sets the 7th layer to true
# and returns to its orginal color scheme

func _on_knock_back_duration_timeout() -> void:
	$knock_back_duration.stop()
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
		 
		$pain.set_collision_layer_value(7, false) 
		$pain.set_collision_mask_value(6, false) 
		$pain.set_collision_mask_value(1, false) 
		modulate = Color(2.0,2.0,2.0)
		$knock_back_duration.start()
		in_pain = true
		
