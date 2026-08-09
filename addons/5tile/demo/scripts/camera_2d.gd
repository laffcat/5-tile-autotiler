extends Camera2D

@export var pan_speed := 100.0

func _process(delta):
	var cam_direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if cam_direction:
		position += pan_speed * cam_direction * delta
		$"../PaintCursor".mouse_move()
