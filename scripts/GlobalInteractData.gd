extends Node

var available_actions: Array[InteractSource]
var current_area: InteractArea3D

signal interacting(interaction)
signal interaction_over(interaction)
signal interaction_available(interacts: Array[InteractSource], interact_area: InteractArea3D)
signal interaction_unavailable()

func set_interactor(interacts: Array[InteractSource], interact_area: InteractArea3D) -> void:
	available_actions = interacts
	current_area = interact_area
	interaction_available.emit(interacts, interact_area)

func clear_interactor() -> void:
	current_area = null
	interaction_unavailable.emit()

func is_interacting(action: InteractSource) -> void:
	interacting.emit(action)

func finished_interaction(action: InteractSource) -> void:
	interaction_over.emit(action)
