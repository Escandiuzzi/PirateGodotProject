extends Node

# Internal node references
onready var navigation_map = $NavigationMap
onready var player = $Player
onready var node2D = $Node2D

func _unhandled_input(event):
	if Input.is_action_pressed("right_click"):
		_calculate_new_path();
	pass

# Calculates a new path and gives to sidekick
func _calculate_new_path():
	# Finds path
	var path = navigation_map.get_caminho(player.position, node2D.get_global_mouse_position())

	# If we got a path...
	if path:
		
		# Remove the first point (it's where the sidekick is)
		path.remove(0)
		
		# Sets the sidekick's path
		player.path = path
	pass