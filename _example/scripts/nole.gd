extends Sprite3D

@onready var well: AudioStreamPlayer3D = $well
@onready var hi: AudioStreamPlayer3D = $hi
@onready var noelle_area_3d: InteractArea3D = $NoelleArea3D

func _on_noelle_area_3d_action_finish(action: InteractAction) -> void:
	match action.hint:
		"?":
			well.play()
			noelle_area_3d.hide_action("?")
			noelle_area_3d.show_action("Hi")
		"Hi":
			hi.play()
