extends Node2D

var is_in_cutscene_2: bool = false
@onready var player = get_tree().current_scene.find_child("Player", true, false)
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cutscene_trigger_1: Area2D = $Cutscene_Triggers/cutscene_trigger1
@onready var cutscene_trigger_2: Area2D = $Cutscene_Triggers/cutscene_trigger2
@onready var walk_in_dialogue_trigger_3 = $walk_in_dialogue_trigger3


func _ready() -> void:
	walk_in_dialogue_trigger_3.event_line_reached.connect(_on_event_line_reached)
	player.is_in_cutscene = true
	animation_player.play("intro")
	await animation_player.animation_finished
	player.is_in_cutscene = false
	

func _input(event: InputEvent) -> void:
	if is_in_cutscene_2 == true and event.is_action_pressed("Interact"):
		is_in_cutscene_2 = false
		animation_player.play("sees_cabin")
		await animation_player.animation_finished
		if animation_player.animation_finished and walk_in_dialogue_trigger_3.event_index > 2:
			animation_player.play("sees_cabin_ends")
			player.is_in_cutscene = false
			cutscene_trigger_2.queue_free()
		return

func _on_cutscene_trigger_1_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player.is_in_cutscene = true
		animation_player.play("back")
		await animation_player.animation_finished
		player.is_in_cutscene = false
		cutscene_trigger_1.queue_free()
		return

func _on_cutscene_trigger_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player.is_in_cutscene = true
		is_in_cutscene_2 = true
		return

func _on_event_line_reached():
	print("hi")
