@tool
extends AutoMapLayer


func get_tile(neighbors : Array[bool] = [false, false, false, false]) -> Array: 
	##	accepts an array of our "final" tile's 4 neighbors, sampled from the "layout" TileMapLayer
	##	returns [ atlas X, atlas Y, transform byte ], eg: 
	#		tile at (2, 0) w/random transforms
	##			[ 2, 0, trans_random() ]
	#		tile at (0, 5-9), flipped horizontally + diagonally
	##			[ 0, randi_range(5, 9), FH + T ]
	# Transform bytes are created by adding together special numbers that signify transform operations.
	# These numbers are saved as compact constants:
	#	T: Transpose (Diagonal flip, always applied first)
	#	FH: Flip Horizontal
	#	FV: Flip Vertical
	# Visualization / cheat-sheet: https://laffcat.neocities.org/tut_5tile/byte_cheat_sheet.png
	
	match neighbors: ## 5 top-down tiles w/full randomization
		# midtiles - |██|
		[true, true, true, true]: return [ randi_range(0, 5), randi_range(0, 1), trans_random() ]
		# vertical edges - |▄▄|, |▀▀|
		[false, false, true, true]: return [ randi_range(0, 5), 5, either(0, FH) ]
		[true, true, false, false]: return [ randi_range(0, 5), 5, either(FV, FH+FV) ]
		# hortizontal edges - | █|, |█ |
		[false, true, true, false]: return [ randi_range(0, 5), 5, either(T, T+FV) ]
		[true, false, false, true]: return [ randi_range(0, 5), 5, either(T+FH, T+FH+FV) ]
		# top outer corners - | ▄|, |▄ |
		[false, false, true, false]: return [ randi_range(0, 5), 2, either(0, T) ]
		[false, false, false, true]: return [ randi_range(0, 5), 2, either(FH, T+FH) ]
		# bottom outer corners - | ▀|, |▀ |
		[false, true, false, false]: return [ randi_range(0, 5), 2, either(FV, T+FV) ]
		[true, false, false, false]: return [ randi_range(0, 5), 2, either(FH+FV, T+FH+FV) ]
		# top inner corners - |▄█|, |█▄|
		[false, true, true, true]: return [ randi_range(0, 5), 3, either(0, T) ]
		[true, false, true, true]: return [ randi_range(0, 5), 3, either(FH, T+FH) ]
		# bottom inner corners - |▀█|, |█▀|
		[true, true, true, false]: return [ randi_range(0, 5), 3, either(FV, T+FV) ]
		[true, true, false, true]: return [ randi_range(0, 5), 3, either(FH+FV, T+FH+FV) ]
		# diagonals - |▀▄|, |▄▀|
		[true, false, true, false]: return [ randi_range(0, 5), 4, either( either(0, T), either(FH+FV, T+FH+FV) ) ]
		[false, true, false, true]: return [ randi_range(0, 5), 4, either( either(FH, T+FH), either(FV, T+FV) ) ]
		# empty - |  |
		[false, false, false, false]: return [ -1, -1, -1 ] # no tile
	
	# shouldn't reach this par draws the offending neibhor configuration in console
	print("ERROR: AutoMapLayer.get_tile() - failed to match input. Did you remove lines from the 'match neighbors:' block?\n"
		+ ". " if !neighbors[0] else "0 " + ".\n" if !neighbors[1] else "0\n"
		+ ". " if !neighbors[3] else "0 " + "." if !neighbors[2] else "0"
		)
	return [-1, -1, -1] # neighbor match failed; clear tile
