extends Node2D

var object_id = self.get_instance_id()
var placeable = false
var parent_node
@export var moveable = true
var DEBUG_MODE = Server.DEBUG_MODE

var _server = Server
var _debug_mode = DEBUG_MODE

# function to help with testing
func set_dependencies(server_instance, debug_mode: bool):
	_server = server_instance
	_debug_mode = debug_mode

func _ready():
	parent_node = get_parent()
	
	if _debug_mode:
		print("Object ready start.")
		
	var response = _server.handle_request("add_object", {
		"object_id": object_id,
		"object": self
	})
	
	if _debug_mode:
		print("Server Response to Add: ", response)
