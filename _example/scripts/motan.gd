extends Sprite3D

@export var verity: Array[AudioStreamWAV]
@onready var song: AudioStreamPlayer3D = $song
@onready var interact_area_3d: InteractArea3D = $InteractArea3D
var index: int = 0

func _on_interact_area_3d_action_start(action: InteractAction) -> void:
	match action.hint:
		": )":
			play_and_increment()

func _on_interact_area_3d_action_finish(action: InteractAction) -> void:
	match action.hint:
		"Again!":
			interact_area_3d.disable_action("Again!")
			index = 0
			song.stream = verity[index]
			index += 1
			song.play()
			song.finished.connect(func():interact_area_3d.hide_action("Again!"))
			song.finished.connect(func():interact_area_3d.enable_action(": )"))

func play_and_increment() -> void:
	interact_area_3d.disable_action(": )")
	song.stream = verity[index]
	index += 1
	song.play()
	song.finished.connect(func():interact_area_3d.enable_action(": )"))
	if index > 7:
		interact_area_3d.disable_action(": )")
		song.finished.connect(func():interact_area_3d.show_action("Again!"))
