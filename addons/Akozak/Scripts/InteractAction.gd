@tool
class_name InteractAction
extends Resource

@export var key: Key = KEY_E
@export var hint: String = "Interact"
@export var repeats: bool = true
@export var hold: bool = false:
	set(value):
		hold = value
		notify_property_list_changed()
@export var duration: float = 0.5
@export var visible: bool = true
@export var enabled: bool = true
@export var text_color: Color = Color.WHITE
var interacting: bool = false

func _validate_property(property: Dictionary) -> void:
	if property.name == "duration" and not hold:
		property.usage &= ~PROPERTY_USAGE_EDITOR
