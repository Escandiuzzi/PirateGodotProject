extends Node


# Internal node references
onready var navigation_map = $NavigationMap
onready var player = $Player
onready var node2D = $Node2D
onready var flag = $Flags;

var current_menu;

func _unhandled_input(event):
	if Input.is_action_pressed("right_click"):
		_calculate_new_path();
	pass

# Calculates a new path and gives to sidekick
func _calculate_new_path():
	
	if not current_menu == null:
		current_menu._player_moved_hide();
		current_menu = null;
	
	var path;
	path = navigation_map._get_path(player.position, node2D.get_global_mouse_position())

	# If we got a path...
	if path:
		
		# Remove the first point (it's where the sidekick is)
		path.remove(0)
		
		# Sets the sidekick's path
		player.path = path
	pass


func _on_Flag_current_menu_opened(menu):
	current_menu = menu;
	pass 