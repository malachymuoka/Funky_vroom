extends Area2D
var dir = Vector2(-1,0) 
var speed = 50
var player 
# determines the behaviour of the car in special 
# cases

var lock_on:bool = false
var targetting:bool = false
var lck_num:int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rn = randi_range(0,2)
	if rn == 0:
		$Sprite2D.texture = preload("res://graphics/cars/red.png")
	elif rn == 1:
		$Sprite2D.texture = preload("res://graphics/cars/green.png")
	elif rn == 2:
		$Sprite2D.texture = preload("res://graphics/cars/yellow.png")
	if position.x <=0 :
		dir = -dir
		$Sprite2D.flip_h = true

# here, the car targets the player character 
# and flips its sprite depending on the position of the 
# player

func _process(delta: float) -> void:
	
	
	if lock_on == true:
		if targetting == true:
			if $targetting_time.is_stopped() == true:
				$targetting_time.start()
			
			if player.position.x >position.x :
				$Sprite2D.flip_h = true
			else:
				$Sprite2D.flip_h = false
			var pos = (player.position-position).normalized()
			
		
			
			dir = Vector2(pos)
			$Sprite2D2.position = dir*15
			#look_at(-pos*10)
		else:
			
			$Sprite2D2.hide()
			speed*=1.5
			lock_on = false
	
	else: 
		position += dir *speed*delta 
	pass
func _physics_process(_delta: float) -> void:
	pass

	



func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free() # Replace with function body.


# if the car is near the player during
# the carbinjor's taunt ability, redirects 
# towards the player's position.
# If it's a bullet or the swors, then it will die of 
#death

func _on_area_entered(area: Area2D) -> void:
	
	if area.name == "cars_lock_on_area" and area.visible == true and lck_num <1 :
		
		$Sprite2D2.show()
		player = area.get_parent()
		lock_on = true
		targetting = true
		lck_num +=1
	if area.name == "Car_Buster":
		queue_free()
		
	if area.get_child(0).name == "gun_collide":
		area.pierced+=1
		queue_free()

# ends the targetting phase

func _on_targetting_time_timeout() -> void:
	targetting = false # Replace with function body.
	$targetting_time.stop()
