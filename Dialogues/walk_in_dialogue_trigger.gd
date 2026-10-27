extends Area2D

@export_file("*.json") var d_file: String
var dialogue = []
var current_dialogue_id = 0
var d_active = false

func _ready() -> void:
	$dialogue_box.visible = false


func _on_body_entered(body: Node2D) -> void:
	if d_active or body.name != "Player":
		return
	
	start_dialogue()

func start_dialogue():
	d_active = true
	$dialogue_box.visible = true
	
	var player = get_tree().current_scene.find_child("Player", true, false)
	if player:
		player.is_in_dialogue = true
	
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

func _input(event: InputEvent) -> void:
	if d_active and event.is_action_pressed("Interact"):
		next_script()

func load_dialogue():
	if FileAccess.file_exists(d_file):
		var file = FileAccess.open(d_file, FileAccess.READ)
		if file:
			var text = file.get_as_text()
			file.close()
			return JSON.parse_string(text)
	return []

func next_script():
	current_dialogue_id += 1
	
	if current_dialogue_id >= dialogue.size():
		$dialogue_box.visible = false
		await get_tree().create_timer(0.3).timeout
		d_active = false
		
		# UNFREEZE THE PLAYER
		var player = get_tree().current_scene.find_child("Player", true, false)
		if player:
			player.is_in_dialogue = false
			
		# CHOOSE ONE:
		queue_free() # Option A: Deletes this trigger forever so the cutscene only plays ONCE.
		# current_dialogue_id = 0 # Option B: Un-comment this instead if you want it to replay every single time you walk here.
		return
		
	$dialogue_box/ColorRect/RichTextLabel.text = dialogue[current_dialogue_id]['name']
	$dialogue_box/ColorRect/RichTextLabel2.text = dialogue[current_dialogue_id]['text']
