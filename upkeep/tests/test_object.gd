@tool
extends GutTest
class_name MockServer

var expected_method = ""
var expected_data = {}
var response_to_return = "OK"
var called = false
var called_with = null


func handle_request(method_name, data):
	called = true
	called_with = data
	assert_eq(method_name, expected_method)
	assert_eq(data["object_id"], expected_data["object_id"])
	return response_to_return

func test_ready_calls_server_add_object():
	var mock_server = MockServer.new()
	
	mock_server.expected_method = "add_object"
	mock_server.expected_data = {"object_id": 123}
	
	var test_obj = preload("res://scripts/object.gd").new()
	var dummy_parent = Node2D.new()
	dummy_parent.add_child(test_obj)
	
	test_obj.set_dependencies(mock_server, false)
	
	test_obj.object_id = 123
	
	test_obj._ready()
	
	assert_true(mock_server.called, "Server.handle_request was not called.")
	assert_eq(mock_server.called_with["object_id"], test_obj.object_id, "Object IDs do not match.")
