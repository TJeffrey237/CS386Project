extends Node2D

var object_id = self.get_instance_id()
var DEBUG_MODE = Server.DEBUG_MODE

func _ready():
	
	if DEBUG_MODE:
		print("Object ready start.")
		
	var response = Server.handle_request("add_object", {
		"object_id": object_id,
		"object": self
	})
	
	if DEBUG_MODE:
		print("Server Response to Add: ", response)
