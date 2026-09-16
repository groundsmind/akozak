extends Node3D

@onready var nom: AudioStreamPlayer3D = $sounds/nom
@onready var splat: AudioStreamPlayer3D = $sounds/splat
@onready var scary: AudioStreamPlayer3D = $sounds/scary
@onready var rise: AudioStreamPlayer3D = $sounds/rise
@onready var ui: AudioStreamPlayer3D = $sounds/ui

@onready var donut: MeshInstance3D = $Donut
@onready var eaten_donut: CSGMesh3D = $"EatenDonut"
@onready var donut_eat_particles: GPUParticles3D = $"donutEat"
@onready var donut_interact_area: InteractArea3D = $DonutInteractArea
@onready var donut_mat: Material
var destroyed: bool = false

func _ready() -> void:
	donut_mat = donut.get_active_material(0)

func _on_donut_interact_area_action_finish(action: InteractAction) -> void:
	match action.hint:
		"Eat":
			if not destroyed:
				donut.hide()
				eaten_donut.show()
				donut_eat_particles.emitting = true
				
				donut_interact_area.disable_action("Eat")
				donut_interact_area.enable_action("Ponder")
		"Destroy":
			donut.hide()
			eaten_donut.hide()
			destroyed = true
			scary.play(0.45)
			
			donut_interact_area.disable_action("Eat")
			donut_interact_area.disable_action("Glaze")
			donut_interact_area.enable_action("Ponder")
			donut_interact_area.disable_action("Destroy")

func _on_donut_interact_area_action_start(action: InteractAction) -> void:
	match action.hint:
		"Eat":
			nom.play()
		"Destroy":
			ui.play()
		"Glaze":
			if not destroyed:
				donut_mat.albedo_color = Color(randf_range(0.0,1.0), randf_range(0.0,1.0), randf_range(0.0,1.0))
				splat.play(0.14)
		"Ponder":
			donut.show()
			eaten_donut.hide()
			destroyed = false
			rise.pitch_scale = randf_range(0.5, 2.0)
			rise.play()
			
			donut_interact_area.enable_action("Eat")
			donut_interact_area.enable_action("Glaze")
			donut_interact_area.disable_action("Ponder")
			donut_interact_area.enable_action("Destroy")

func _on_donut_interact_area_action_cancel(action: InteractAction) -> void:
	match action.hint:
		"Eat":
			nom.stop()
