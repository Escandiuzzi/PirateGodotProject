extends Button

var ingredients;
var i_name;
var path;

func _set_name(_name):
	i_name = _name;
	pass;
func _get_name():
	return i_name;
	pass;

func _set_ingredients(_ingredients):
	ingredients = _ingredients;
	pass;
func _get_ingredients():
	return ingredients;
	pass;

func _set_path(_path):
	path = _path;
	pass;
func _get_path():
	return path;
	pass;
