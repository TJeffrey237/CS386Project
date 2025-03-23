extends "draggable_object.gd"

@export var valid_locations : Array[Vector2] = []
@export var lock_in_place : Array[bool] = []

func _ready():
	super()
	placeable = true
	if DEBUG_MODE:
		print("Making location creation request")
	parent_node.add_piece(self)
	
func _process(_delta):
	var response
	response = super(_delta)
	if response:
		var placed = response["placed"]
		if placed:
			parent_node.check_completion()
