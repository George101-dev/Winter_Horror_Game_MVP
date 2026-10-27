extends Area2D

@export_file("*.json") var d_file: String
var dialogue = []
var current_dialogue_id = 0
var d_active = false

func _ready() -> void:
	$dialogue_box.visible = false

func _input(event: InputEvent) -> void:
	if d_active:
		if event.is_action_pressed("Interact"):
			next_script()
		return
	if event.is_action_pressed("Interact") and has_overlapping_bodies():
		start_dialogue()

func start_dialogue():
	d_active = true
	$dialogue_box.visible = true
	var player = get_tree().current_scene.find_child("Player", true, false)
	if player:
		player.is_in_dialogue = true # Flip the frozen switch on the player
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

func next_script():
	if dialogue == null or dialogue.size() == 0:
		$dialogue_box.visible = false
		d_active = false
		
		
	
	current_dialogue_id += 1
	if current_dialogue_id >= dialogue.size():
		$dialogue_box.visible = false
		await get_tree().create_timer(0.3).timeout
		d_active = false
		var player = get_tree().current_scene.find_child("Player", true, false)
		if player:
			player.is_in_dialogue = false # Let the player move again!
		print("Error: The dialogue data array is empty! Check your JSON formatting.")
		return
	$dialogue_box/ColorRect/RichTextLabel.text = dialogue[current_dialogue_id]['name']
	$dialogue_box/ColorRect/RichTextLabel2.text = dialogue[current_dialogue_id]['text']

func load_dialogue():
	if FileAccess.file_exists(d_file):
		var file = FileAccess.open(d_file, FileAccess.READ)
		if file:
			var text = file.get_as_text()
			file.close()
			return JSON.parse_string(text)
	return []
