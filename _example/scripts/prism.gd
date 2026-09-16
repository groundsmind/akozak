extends Node3D

@onready var mesh: MeshInstance3D = $mesh
var target_rotation: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	mesh.rotation = lerp(mesh.rotation, target_rotation, delta*3)

func _on_prism_interact_area_action_start(_action: InteractAction) -> void:
	target_rotation = Vector3(randf_range(0,2*PI), randf_range(0,2*PI), randf_range(0,2*PI))
