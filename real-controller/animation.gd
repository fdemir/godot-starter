extends Node

@onready var animation_tree: AnimationTree = $"../AnimationTree"
@onready var playback = animation_tree.get("parameters/playback")
@onready var player: CharacterBody3D = $".."
@onready var camera: Camera3D = $"../Camera3D"

var target_direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	if player == null or animation_tree == null:
		return

	var is_sprinting = player.is_sprinting

	if player.input_dir.length() > 0.1:
		var target_blend = Vector2(player.input_dir.x, -player.input_dir.y)

		var current_run = animation_tree.get("parameters/Locomotion/RunBlend/blend_position")
		var smooth_run = current_run.lerp(target_blend, delta * 10.0)
		animation_tree.set("parameters/Locomotion/RunBlend/blend_position", smooth_run)

		var current_sprint = animation_tree.get("parameters/Locomotion/SprintBlend/blend_position")
		var smooth_sprint = current_sprint.lerp(target_blend, delta * 10.0)
		animation_tree.set("parameters/Locomotion/SprintBlend/blend_position", smooth_sprint)

		# Use run animations when sprinting backward
		var is_moving_backward = player.input_dir.y > 0
		var target_speed = 1.0 if (is_sprinting and not is_moving_backward) else 0.0
		var current_speed = animation_tree.get("parameters/Locomotion/SpeedBlend/blend_amount")
		var smooth_speed = lerp(current_speed, target_speed, delta * 8.0)
		animation_tree.set("parameters/Locomotion/SpeedBlend/blend_amount", smooth_speed)
