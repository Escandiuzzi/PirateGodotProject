extends Area2D

signal MouseHover;
signal MouseHoverExit;

func _on_Area2D_mouse_enter():
    if true:
        emit_signal("MouseHover");

func __on_Area2D_mouse_exit():
	if true:
        emit_signal("MouseHoverExit");