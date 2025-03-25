extends Area2D

var tiles = []
var solved = []
var click = false

func _ready():
	start()

func start():
	tiles = [$CollisionShape2D/tile, $CollisionShape2D/tile2, $CollisionShape2D/tile3, $CollisionShape2D/tile4, $CollisionShape2D/tile5, $CollisionShape2D/tile6, $CollisionShape2D/tile7, $CollisionShape2D/tile8, $CollisionShape2D/tile9, $CollisionShape2D/tile10, $CollisionShape2D/tile11, $CollisionShape2D/tile12, $CollisionShape2D/tile13, $CollisionShape2D/tile14, $CollisionShape2D/tile15, $CollisionShape2D/tile16]
	solved = tiles.duplicate()
	shuffle_tiiles()

func shuffle_tiiles():
	var prev = 99
	var afterPrev = 98
	for t in range(0, 1000):
		var tile = randi() % 16
		if tiles[tile] != $CollisionShape2D/tile16 and tile != prev and tile != afterPrev:
			var rows = int(tiles[tile].position.y /125)
			var cols = int(tiles[tile].position.x / 125)
			check_empty(rows, cols)
			afterPrev = prev
			prev = tile

func _process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and click:
		var click_copy = click
		print(click.position)
		click = false
		var rows = int(click_copy.position.y / 125)
		var cols = int(click_copy.position.x / 125)
		check_empty(rows, cols)
		if tiles == solved:
			print("You win!")

func check_empty(rows, cols):
	var empty = false
	var done = false
	var pos = rows * 4 + cols
	while !empty and !done:
		var new_pos = tiles[pos].position
		if rows < 3:
			new_pos.y += 125
			empty = find_empty(new_pos, pos)
			new_pos.y -= 125
		if rows > 0:
			new_pos.y -= 125
			empty = find_empty(new_pos, pos)
			new_pos.y += 125
		if cols < 3:
			new_pos.x += 125
			empty = find_empty(new_pos, pos)
			new_pos.x -= 125
		if cols > 0:
			new_pos.x -= 125
			empty = find_empty(new_pos, pos)
			new_pos.x += 125
		done = true

func find_empty(position, pos):
	var new_rows = int(position.y / 125)
	var new_cols = int(position.x / 125)
	var new_pos = new_rows * 4 + new_cols
	if tiles[new_pos] == $CollisionShape2D/tile16:
		swap(pos, new_pos)
		return true
	else:
		return false

func swap(tile_src, tile_dst):
	var temp_pos = tiles[tile_src].position
	tiles[tile_src].position = tiles[tile_dst].position
	tiles[tile_dst].position = temp_pos
	var temp_tile = tiles[tile_src]
	tiles[tile_src] = tiles[tile_dst]
	tiles[tile_dst] = temp_tile
	

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		click = event
