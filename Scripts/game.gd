extends Node2D

var is_cutscene_active: bool = false
@onready var player = get_tree().current_scene.find_child("Player", true, false)
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cutscene_trigger_1: Area2D = $Cutscene_Triggers/cutscene_trigger1
@onready var cutscene_trigger_2: Area2D = $Cutscene_Triggers/cutscene_trigger2


func _ready() -> void:
	player.is_in_cutscene = true
	animation_player.play("intro")
	await animation_player.animation_finished
	player.is_in_cutscene = false

func player_input_1():
	if Input.is_action_pressed("Interact") and player.is_in_cutscene == true:
		animation_player.play("sees_cabin")
		await animation_player.animation_finished
		animation_player.play("RESET")
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
		player_input_1()
		return
