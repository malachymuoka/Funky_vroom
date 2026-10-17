extends AudioStreamPlayer

var audio: bool = false
# this script is used to determine what music will(and won't) be playing in the background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if get_tree().current_scene!= null && audio == true:
		
		if GlobalStats.final == true :
				if GlobalStats.forboding == true && stream != preload("res://audio/Ridiculon_-_Anima_Vendit_Deal_With_the_Devil_The_Binding_Of_Isaac_-_Rebirth_OST_(mp3.pm).mp3"):
					stream = preload("res://audio/Ridiculon_-_Anima_Vendit_Deal_With_the_Devil_The_Binding_Of_Isaac_-_Rebirth_OST_(mp3.pm).mp3")			
					stream.loop = true
					playing = true
				elif GlobalStats.forboding == false:
					playing = false
		elif GlobalStats.final == false:		
				if get_tree().current_scene.name == "Gaming" && stream != preload("res://audio/S31-City on Speed.ogg"):
				
					stream = preload("res://audio/S31-City on Speed.ogg")
					stream.loop = true
					playing = true	
				
				elif get_tree().current_scene.name == "shop_area" && stream != preload("res://audio/bgm.ogg") :
				
					stream = preload("res://audio/bgm.ogg")
					stream.loop = true
					playing = true	
		
				elif get_tree().current_scene.name == "PARRY" && stream != preload("res://audio/Angel Room.mp3") :
					stream = preload("res://audio/Angel Room.mp3") 
					stream.loop = true
					playing = true	
				
		
		elif get_tree().current_scene.name != "shop_area" && get_tree().current_scene.name != "Gaming" && get_tree().current_scene.name != "PARRY":
			if playing == true:
				playing = false
	
