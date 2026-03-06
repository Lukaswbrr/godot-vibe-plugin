@tool
extends EditorScript

var panel = EditorInterface.get_base_control()
var prompt = "Create two nodes, one named Node1 as Node2D and the other Node2 as Node3D. Then, remove the node named Node1"

func _run() -> void:
	print("running...")
	var node_class = menubar_editor_get_test().get_class()
	fastapi_request_test(prompt)


func fastapi_request_test(message: String) -> void:
	var http_test = HTTPRequest.new()
	http_test.request_completed.connect(func(request, response_code, headers, body):
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var json_data = json.get_data()
		#print(json_data)
		#print(json_data.response)
		
		var json_response = JSON.parse_string(json_data.response)
		print(json_response)
		parse_instructions(json_response)
	)
	
	EditorInterface.get_edited_scene_root().add_child(http_test)
	
	var post_message = JSON.stringify({
		"message": message
	})
	
	var post_headers = [
		"Content-Type: application/json"
	]
	
	var error = http_test.request("http://127.0.0.1:8000/chat", post_headers, HTTPClient.METHOD_POST, post_message)

func parse_instructions(instructions: Dictionary) -> void:
	for k in instructions:
		var instruction = instructions[k].keys()[0]
		var parameters = instructions[k].values()[0]
		
		_execute_instruction(instruction, parameters)

func _execute_instruction(instruction: String, parameters: Dictionary) -> void:
	match instruction:
		"create_node":
			var node_name = parameters["node_name"]
			var node_type = parameters["node_type"]
			
			var node_data = {
				"name": node_name
			}
			
			_create_node(node_type, node_data)
		"remove_node":
			print("remove_node not implemented.")

func _create_node(node: String, data: Dictionary = {}) -> void:
	var current_scene = EditorInterface.get_edited_scene_root()
	var object: Object
	
	match node:
		"Node3D":
			print("Node3D instruction found")
			object = Node3D.new()
			
			for k in data:
				object.set(k, data[k])
		"Node2D":
			print("Node2D instruction found")
			object = Node2D.new()
			
			for k in data:
				object.set(k, data[k])
		_:
			print("create_node: Invalid instruction node.")
	
	if !object:
		print("Object null")
		return
	
	current_scene.add_child(object)
	object.owner = current_scene


#region NOT_USED
## For functions that may be reworked in the future.

func menubar_editor_test() -> void:
	var vbox = panel.get_children()[0]
	var editortitle = vbox.get_children()[0]
	var menubar = editortitle.get_children()[0]
	var scene: PopupMenu = menubar.get_children()[0]
	
	scene.popup_centered()

func menubar_editor_get_test() -> Object:
	var vbox = panel.get_children()[0]
	var editortitle = vbox.get_children()[0]
	var menubar = editortitle.get_children()[0]
	var scene: PopupMenu = menubar.get_children()[0]
	
	return scene
#endregion
