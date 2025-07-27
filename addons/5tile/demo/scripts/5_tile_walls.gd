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
	
	match neighbors: ## data entry time!
		# midtiles - |██|
		[true, true, true, true]: return [ 0, 0, 0 ]
		# vertical edges - |▄▄|, |▀▀|
		[false, false, true, true]: return [ 2, 0, 0 ]
		[true, true, false, false]: return [ 2, 0, FV ]
		# hortizontal edges - | █|, |█ |
		[false, true, true, false]: return [ 2, 0, T ]
		[true, false, false, true]: return [ 2, 0, T+FH ]
		# top outer corners - | ▄|, |▄ |
		[false, false, true, false]: return [ 3, 0, FH ]
		[false, false, false, true]: return [ 3, 0, 0 ]
		# bottom outer corners - | ▀|, |▀ |
		[false, true, false, false]: return [ 3, 0, FH+FV ]
		[true, false, false, false]: return [ 3, 0, FV ]
		# top inner corners - |▄█|, |█▄|
		[false, true, true, true]: return [ 1, 0, FH ]
		[true, false, true, true]: return [ 1, 0, 0 ]
		# bottom inner corners - |▀█|, |█▀|
		[true, true, true, false]: return [ 1, 0, FH+FV ]
		[true, true, false, true]: return [ 1, 0, FV ]
		# diagonals - |▀▄|, |▄▀|
		[true, false, true, false]: return [ 4, 0, FH ]
		[false, true, false, true]: return [ 4, 0, 0 ]
		# empty - |  |
		[false, false, false, false]: return [ -1, -1, -1 ] # no tile
	
	# shouldn't reach this par draws the offending neibhor configuration in console
	print("ERROR: AutoMapLayer.get_tile() - failed to match input. Did you remove lines from the 'match neighbors:' block?\n"
		+ ". " if !neighbors[0] else "0 " + ".\n" if !neighbors[1] else "0\n"
		+ ". " if !neighbors[3] else "0 " + "." if !neighbors[2] else "0"	)
	return [-1, -1, -1] # neighbor match failed; clear tile
