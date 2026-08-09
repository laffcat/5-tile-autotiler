@tool
extends AutoMapLayer

## Uses fancier randomization techniques than the other examples. 
# Made with an older version of this script, so forgive the less-helpful formatting :P

func get_tile(neighbors : Array[bool] = [false, false, false, false]) -> Array: 
	match neighbors: ## neighbor array layout: [7, 9, 3, 1]
		[false, false, false, false]: return [ -1, -1, 0 ]
		# midtiles
		[true, true, true, true]: return [ 1, 1, 0 ] if randi()%7 else [ randi_range(4, 5), randi()%9, trans_random() ]
		# top edges
		[false, false, true, true]: return [ 1, 0, 0 ]
		# bottom edges
		[true, true, false, false]: 
			return [ 1, 2, 0 ] if randi()%3 else ( # Roll for whether we'll use a variant, then roll again for a rare variant.
				[ randi()%4, randi_range(3, 4), 0 ] if randi()%3 else [ randi()%4, randi_range(7, 8), 0 ]
			)
		# side edges
		[false, true, true, false]: return [ 0, 1, 0 ]
		[true, false, false, true]: return [ 0, 1, FH ]
		# top outer corners
		[false, false, true, false]: return [ 0, 0, 0 ]
		[false, false, false, true]: return [ 0, 0, FH ]
		# top inner corners
		[false, true, true, true]: return [ 3, 2, FH ]
		[true, false, true, true]: return [ 3, 2, 0 ]
		# bottom outer corners
		[false, true, false, false]: return [ 0, 2, 0 ] if randi()%7 else [ randi()%2, 5, 0 ]
		[true, false, false, false]: return [ 2, 2, 0 ] if randi()%7 else [ 2 + randi()%2, 5, 0 ]
		# bottom inner corners
		[true, true, false, true]: return [ 2, 1, 0 ] if randi()%7 else [ randi()%2, 6, 0 ]
		[true, true, true, false]: return [ 3, 1, 0 ] if randi()%7 else [ 2 + randi()%2, 6, 0 ]
		# double trouble
		[true, false, true, false]: return [ 2, 0, 0 ]
		[false, true, false, true]: return [ 3, 0, 0 ]

	# shouldn't reach this part, draws the offending neibhor configuration in console
	print("ERROR: AutoMapLayer.get_tile() - failed to match input. Did you remove lines from the 'match neighbors:' block?\n"
		+ ". " if !neighbors[0] else "0 " + ".\n" if !neighbors[1] else "0\n"
		+ ". " if !neighbors[3] else "0 " + "." if !neighbors[2] else "0"	)
	return [-1, -1, -1] # neighbor match failed; clear tile
