extends Area2D

const TILE_SIZE = 125
const OFFSET = Vector2(326, 74)

var DEBUG_MODE = Server.DEBUG_MODE
var tiles = []
var solved = []
var click = false

signal exit_pressed

func _ready():
	tiles = [
		$CollisionShape2D/tile1, $CollisionShape2D/tile2, $CollisionShape2D/tile3, 
		$CollisionShape2D/tile4, $CollisionShape2D/tile5, $CollisionShape2D/tile6, 
		$CollisionShape2D/tile7, $CollisionShape2D/tile8, $CollisionShape2D/tile9, 
		$CollisionShape2D/tile10, $CollisionShape2D/tile11, $CollisionShape2D/tile12, 
		$CollisionShape2D/tile13, $CollisionShape2D/tile14, $CollisionShape2D/tile15, 
		$CollisionShape2D/tile16
	]
	solved = tiles.duplicate()
	shuffle_tiles()


func shuffle_tiles():
	for tile in tiles:
		var random_tile = tiles[randi() % 16]
		var pos1 = int(tile.position.y / TILE_SIZE) * 4 + int(tile.position.x / TILE_SIZE)
		var pos2 = int(random_tile.position.y / TILE_SIZE) * 4 + int(random_tile.position.x / TILE_SIZE)
		swap(pos1, pos2)


func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and click:
		var click_copy = click
		print(click.position)
		click_copy.position -= OFFSET
		click_copy.global_position -= OFFSET
		click = false
		var rows = int(click_copy.position.y / TILE_SIZE)
		var cols = int(click_copy.position.x / TILE_SIZE)
		print("Rows: ", rows, " Cols: ", cols)
		check_empty(rows, cols)
		if tiles == solved:
			$Exit.visible = true;


func check_empty(rows, cols):
	var empty = false
	var done = false
	var pos = rows * 4 + cols
	print("Position: ", pos)
	while not empty and not done:
		var new_pos = tiles[pos].position
		print("New Position (pre-swap): ", new_pos)
		if rows < 3:
			empty = find_empty(rows + 1, cols, rows, cols)
		if rows > 0:
			empty = find_empty(rows - 1, cols, rows, cols)
		if cols < 3:
			empty = find_empty(rows, cols + 1, rows, cols)
		if cols > 0:
			empty = find_empty(rows, cols - 1, rows, cols)
		print("New Position (post-swap): ", new_pos)
		done = true


func find_empty(new_rows, new_cols, rows, cols):
	print("New Rows: ", new_rows, " New Cols: ", new_cols)
	var new_pos = new_rows * 4 + new_cols
	var old_pos = rows * 4 + cols
	if tiles[new_pos] == $CollisionShape2D/tile16:
		swap(old_pos, new_pos)
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


func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		click = event


func _on_exit_pressed() -> void:
	if DEBUG_MODE:
		print("Exit signal received.")
	var exit_button = get_node("Exit")
	if exit_button.visible:
		emit_signal("exit_pressed")
		queue_free()
