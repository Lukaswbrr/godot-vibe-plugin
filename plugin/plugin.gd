@tool
extends EditorScript

var panel = EditorInterface.get_base_control()

func _run() -> void:
	#menubar_editor_test()
	print("running...")
	var node_class = menubar_editor_get_test().get_class()
	fastapi_request_test("In Godot Engine, what is " + node_class + "?")


func fastapi_request_test(message: String) -> void:
	var http_test = HTTPRequest.new()
	http_test.request_completed.connect(func(request, response_code, headers, body):
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		print(response.response)
	)
	
	EditorInterface.get_edited_scene_root().add_child(http_test)
	
	var post_message = JSON.stringify({
		"message": message
	})
	
	var post_headers = [
		"Content-Type: application/json"
	]
	
	var error = http_test.request("http://127.0.0.1:8000/chat", post_headers, HTTPClient.METHOD_POST, post_message)

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

# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(response)
