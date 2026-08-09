extends Node2D


var selectangles : Array[Node] = []
var automaps : Array[Node]
var index := 0
var tim : Timer 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tim = Timer.new()
	add_child(tim)
	automaps = $"../AutoMapFinals".get_children() 
	var y := 0
	
	var chud := $"../Camera2D/selectangle1"
	for each in automaps.size():
		var next := chud.duplicate()
		$"../Camera2D".add_child(next)
		next.position = Vector2(chud.position.x, y + 2)
		y += chud.position.y + chud.size.y
		selectangles.append(next)
	chud.queue_free()

	selection_flash()
	list_update()

func selection_flash():
	if tim.time_left:
		tim.stop()
		tim.timeout.emit()
		await get_tree().process_frame
		
	var dimmed : Array[Node] = []
	for i in automaps.size():
		if i == index: continue
		automaps[i].self_modulate = Color.GRAY
		dimmed.append(automaps[i])
	tim.start(.3)
	
	await tim.timeout
	for each in dimmed:
		each.self_modulate = Color.WHITE

func list_update():
	for i in selectangles.size():
		if i == index:
			selectangles[i].color = Color.WHITE
		else:
			selectangles[i].color = Color.RED

func selection_cycle():
	index += 1
	index %= selectangles.size()
	selection_flash()
	list_update()

func _input(event: InputEvent):
	if event.is_action_pressed("ui_accept"):
		selection_cycle()















##
