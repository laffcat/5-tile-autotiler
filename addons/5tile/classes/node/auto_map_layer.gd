@tool
class_name AutoMapLayer
extends TileMapLayer
## 5- to 15-tile dual-grid autotiler, configured in script extensions. Robust support for randomization

#@export var update_test := false: 
#	set(b): if b: update()
## The TileMapLayer containing the layout of our AutoMap. Usually uses a basic one-tile TileSet.
@export var layout : TileMapLayer
## Generates a tile layout from our "layout".
@export_tool_button(&'Update', "Callable") var update_button := update
## If true, calls 'randomize()' every time 'Update' is pressed, giving the engine a new RNG seed.
@export var reroll_seed := true
## Properly lines up AutoMap position when 'update' is pressed.
## Final position is 'layout' position + 1/2 of tile size.
@export var auto_align := true
## Source ID of the tileset we'd like to operate with. Usually 0.
@export var source_id := 0

# tile transform bits
const T = TileSetAtlasSource.TRANSFORM_TRANSPOSE
const FH = TileSetAtlasSource.TRANSFORM_FLIP_H
const FV = TileSetAtlasSource.TRANSFORM_FLIP_V

## 50% chance to return 'a' or 'b'. Used for tile transform bits.
func either( a:int, b:int ) -> int: return a if randi()%2 else b 
## Returns a random tile transform byte.
func trans_random() -> int: return 0 + either(0,T) + either(0,FH) + either(0,FV)

const TILE_ERROR : Array[int] = [-9999, -9999, -9999]
func get_tile(neighbors : Array[bool] = [false, false, false, false]) -> Array: 
	push_error("AutoMapLayer.get_tile() - Detailed below as '[!] Standard Output'")
	print_rich("[b][color=red]ERROR[/color] [color=cornflowerblue]in [color=#65e4fd]AutoMapLayer.get_tile()[/color]:[/color][/b] "+
		"This function must be overridden in an extension script! See steps below:\n"+
		"	1. Create a new [color=MediumSpringGreen]AutoMapLayer[/color] node in the Scene Tree, or select the node creating this error (named [color=#8da5f3]%s[/color]).\n" % name+
		"	2. Click the 'extend script' button in the top-right of the widget.\n"+
		"	3. Next to the 'Template' option, select '[color=khaki]AutoMapLayer: New AutoMap[/color]'.\n"+
		"	4. Open the node's new script and edit [color=#e47fb8]return[/color] values under [color=#65e4fd]get_tile()[/color].\n"+
		"Canelling update operation...")
	return TILE_ERROR # no tile
	## create an AutoMapLayer, extend its script, use "New AutoMap" script template, then edit the get_tile() function in there
	
##	logic for filling AutoMap from "layout" TileMap

func tile_exists(layer : TileMapLayer, coord : Vector2i) -> bool:
		return true if layer.get_cell_atlas_coords(coord) != Vector2i(-1, -1) else false
		
func get_neighbors(layer : TileMapLayer, coords : Vector2i) -> Array[bool]:
	return [
		tile_exists(layer, coords)					,
		tile_exists(layer, coords + Vector2i(1, 0))	,
		tile_exists(layer, coords + Vector2i(1, 1))	,
		tile_exists(layer, coords + Vector2i(0, 1))	]

const OFFSETS : Array[Vector2i] = [ Vector2i(0, 0), Vector2i(0, -1), Vector2i(-1, 0), Vector2i(-1, -1) ]
func update():
	if get_tile() == TILE_ERROR: return
	if !layout:
		push_error("AutoMapLayer.update() - Detailed below as '[!] Standard Output'")
		print_rich("[b][color=red]ERROR[/color] [color=cornflowerblue]in [color=#65e4fd]AutoMapLayer.update()[/color]:[/color][/b] "+
			"Must assign 'layout' TileMapLayer for '[color=#8da5f3]%s[/color]'! Cancelling..." % name)
		return
	clear()
	if reroll_seed: randomize()
	if auto_align: global_position = layout.global_position + tile_set.tile_size * .5
	
	var already_set : Array[Vector2i]
	for coord in layout.get_used_cells():
		for OFF in OFFSETS:
			var at := coord + OFF
			if at in already_set: continue
			already_set.append(at)
			var tile_data = get_tile(get_neighbors(layout, at))
			set_cell(at, source_id, Vector2i(tile_data[0], tile_data[1]), tile_data[2])
		














##
