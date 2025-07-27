@tool
class_name ShuffleMapLayer
extends TileMapLayer
## Simple TileMapLayer extension that randomly shuffles tiles.
## (0, 0) should be a base tile. The rest of your TileSet should be random variants, filling out the rest of the grid.


## If true, calls 'randomize()' every time 'Randomize' is pressed, giving the engine a new RNG seed.
@export var reroll_seed := true
@export_tool_button(&'Randomize', "Callable") var refrech := update
## Tiles have a one in (x) chance to deviate from (0, 0).
@export var randomize_chance := 4

@export var can_transpose := false
@export var can_flip_h := false
@export var can_flip_v := false

## Source ID of the tileset we'd like to operate with. Usually 0.
@export var source_id := 0

func update():
	var grid_size : Vector2i = tile_set.get_source(source_id).get_atlas_grid_size()
	# print("grid size of %s" % grid_size)
	
	var possible_variants : Array[Vector2i] = []
	for x in grid_size.x:
		for y in grid_size.y:
			possible_variants.append(Vector2i(x, y))
	var variant_pool := possible_variants.duplicate()
	print(variant_pool)
	
	if reroll_seed: 
		randomize()
	for coord in get_used_cells():
		var chosen_tile = Vector2i(0, 0) if randi() % randomize_chance else variant_pool.pop_at(randi() % variant_pool.size())
		if variant_pool == []: 
			print("variant pool depleted at %s!" % coord)
			variant_pool = possible_variants.duplicate()
		set_cell(
			coord, 0, chosen_tile,
			( 0 if !(can_transpose and randi()%2) else AutoMapLayer.T ) 
				+( 0 if !(can_flip_h and randi()%2) else AutoMapLayer.FH ) 
				+( 0 if !(can_flip_v and randi()%2) else AutoMapLayer.FV )
		)
