class_name InteractArea3D
extends Area3D

@onready var timer: Timer
signal action_start(interaction_name)
signal action_end(interaction_name)
signal interaction_available
signal interaction_unavailable

@export var interactions: Array[InteractSource] = []

func _ready() -> void:
	set_process_unhandled_input(false)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var key = event.keycode
		for action in interactions:
			if key == action.key:
				action_start.emit(action.hint)
				get_tree().create_timer(action.duration).timeout.connect(func(): action_end.emit(action.hint))
				get_viewport().set_input_as_handled()

func _on_area_entered(_area: Area3D) -> void:
	set_process_unhandled_input(true)
	GlobalInteractData.set_interactor(interactions, self)
	interaction_available.emit()

func _on_area_exited(_area: Area3D) -> void:
	set_process_unhandled_input(false)
	GlobalInteractData.clear_interactor()
	interaction_unavailable.emit()
