extends TextureProgress

var parent_id = -1;

func _set_parent_id(_id):
	parent_id = _id;
	pass;

func _get_parent_id():
	return parent_id;
	pass;