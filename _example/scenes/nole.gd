extends Sprite3D

@onready var well: AudioStreamPlayer3D = $well

func _on_noelle_area_3d_action_finish(_action: InteractAction) -> void:
	well.play()
