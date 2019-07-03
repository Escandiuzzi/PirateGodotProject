extends HSlider

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	value = AudioServer.get_bus_volume_db(0);

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VolumeS_value_changed(value):
	AudioServer.set_bus_volume_db(0,value);
