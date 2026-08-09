extends Node2D

func place(): $"../SelectionList".automaps[$"../SelectionList".index].tile_place(global_position)
func remove(): $"../SelectionList".automaps[$"../SelectionList".index].tile_place(global_position, true)

func mouse_move():
	global_position = get_global_mouse_position()
	if Input.is_action_pressed("click_left"): 
		place()
	if Input.is_action_pressed("click_right"):
		remove()

func _input(event):
	if event is InputEventMouseMotion:
		mouse_move()
	if event.is_action("click_left"): 
		place()
	if event.is_action("click_right"):
		remove()
