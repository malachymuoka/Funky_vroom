extends Node2D
var spin = false
var player:CharacterBody2D  
var direction:Vector2
var speed:int = 1
var extend:Vector2 = Vector2(0,0)
@onready var n_a:Node2D = $normal_axe
@onready var s_a:Node2D = $spinning_axe
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	locate_and_track()
	
	if spin == false:
		n_a.PROCESS_MODE_INHERIT
		n_a.show()
		s_a.PROCESS_MODE_DISABLED
		s_a.hide()
		if position != Vector2(0,0):
			return_to_origin()
			if position.length()<= Vector2(0.5,0.5).length():
				position = Vector2(0,0)
				
	elif spin == true:
		s_a.PROCESS_MODE_INHERIT
		s_a.show()
		n_a.PROCESS_MODE_DISABLED
		n_a.hide()
		spin_to_player()
		


# simply locates where the player is 

func locate_and_track()-> void:
	if player == null:
		for i in get_tree().current_scene.get_children():
			if i.name != "player" && i.get_child(0)!= null:
				for n in i.get_children():
					if n.name == "player":
						player = n
			elif i.name == "player"	:
				player = i
	elif player!= null:
		direction = ( global_position-player.position)
		

# returns the axe to the center of carbite

func return_to_origin()-> void:
	position -= speed *(position - Vector2(0,0)).normalized()
	#if position.x > 0:
		#position.x-=speed
	#if position.x < 0:
		#position.x+=speed
	#if position.y > 0:
		#position.y-=speed
	#if position.y < 0:
		#position.y-=speed

# moves the axe towards the player

func spin_to_player()-> void:

	if(player.position - global_position).length() > 1:
		
		if(position - Vector2(0,0)).length()<25 || (player.position - get_parent().position).length() <45:
			position -= speed*direction.normalized()
		else:
			position = -25.1*direction.normalized()
	else:
		pass
