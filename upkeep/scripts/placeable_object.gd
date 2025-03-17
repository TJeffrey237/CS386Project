extends "draggable_object.gd"

@export var valid_locations : Array[Vector2] = []
@export var lock_in_place : Array[bool] = []

func _ready():
	super()
	placeable = true
	if DEBUG_MODE:
		print("Making location creation request")
	Server.handle_request("create_place_locations", {"object_id": object_id, "valid_locations": valid_locations})
