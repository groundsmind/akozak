extends MeshInstance3D

var target_rotation: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	rotation = lerp(rotation, target_rotation, delta*3)

func _on_prism_interact_action_start(action: InteractSource) -> void:
	target_rotation = Vector3(randf_range(0,2*PI), randf_range(0,2*PI), randf_range(0,2*PI))
