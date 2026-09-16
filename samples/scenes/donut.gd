extends MeshInstance3D

@onready var donut_eat: GPUParticles3D = $"../donutEat"
var destroyed: bool = false
var mat = get_active_material(0)
@onready var eaten_donut: CSGMesh3D = $"../EatenDonut"

func _on_donut_interact_action_start(action: InteractSource) -> void:
	match action.hint:
		"Eat":
			if not destroyed:
				hide()
				eaten_donut.show()
				donut_eat.emitting = true
		"Destroy":
			hide()
			eaten_donut.hide()
			destroyed = true
		"Glaze":
			mat.albedo_color = Color(randf_range(0.0,1.0), randf_range(0.0,1.0), randf_range(0.0,1.0))
		"Ponder":
			show()
			eaten_donut.hide()
			destroyed = false
