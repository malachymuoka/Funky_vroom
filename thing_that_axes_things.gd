extends Node2D




#for axe spin
var axe_spin_ready = true
var spin_duration = true
var axed: Node2D = preload("res://big_axe.tscn").instantiate()
var attacking: bool = false
var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# axes the player if they're to close
func _process(delta: float) -> void:
	
	if $"..".player != null:
		player = $"..".player
	
	
	if GlobalStats.carbinjor_axe_spin == true && axe_spin_ready == true && (sqrt(pow(abs(player.position.x-global_position.x),2)+pow(abs(player.position.y-global_position.y),2))<=60 || attacking == true):
		
		axe_spin()



# first gets the postion of the player tangent to the carbinjor. then, it
# swaps the x and y of that position, with x being -y. then rotates the axe
# itself alongside its parent so it goes a full half circle around the carbinjor
func axe_spin()-> void:
	
	attacking = true
	#adds axe
	
	if is_ancestor_of(axed) == false:
		$swoosh.play(0.5)
		var pos = (player.global_position- $"..".global_position).normalized()
		
		
		#var #half_absolute_value_of_x= abs(pos.x/2)
		#var #half_absolute_value_of_y = abs(pos.y /2)
		#print(str(half_absolute_value_of_x)+" , "+str(half_absolute_value_of_y))
		var py = pos.y
		pos.y =pos.x
		pos.x = -py
		
		
		
		axed.position = pos*10
		axed.look_at(pos*(45))
		axed.rotation +=0.85
		add_child(axed)
		
		
	if spin_duration == true:
		if $".."/cooldowns_for_attacks/axe_spin_cooldowns/spin_duration.is_stopped() ==true:
			$".."/cooldowns_for_attacks/axe_spin_cooldowns/spin_duration.start()
		axed.get_child(0).rotation -=0.000375
		rotation-=0.075
		pass
			
		
	
	else:
		axe_spin_ready = false
		attacking = false
		axed.get_child(0).rotation =0
		rotation = 0
		spin_duration = true
		axed.position = Vector2(0,0)
		$".."/cooldowns_for_attacks/axe_spin_cooldowns.start()
		remove_child(axed)

		
		

func _on_spin_duration_timeout() -> void:
	spin_duration =false
	$".."/cooldowns_for_attacks/axe_spin_cooldowns/spin_duration.stop()
	
	

func _on_axe_spin_cooldowns_timeout() -> void:
	axe_spin_ready = true
	axed = preload("res://big_axe.tscn").instantiate()
	$".."/cooldowns_for_attacks/axe_spin_cooldowns.stop() # Replace with function body.
