class_name InteractAction
extends Resource

@export var key: Key = KEY_E
@export var hint: String = "Interact"
@export var repeats: bool = true
@export_category("Hold")
@export var hold: bool = false
@export var duration: float = 0.5
@export_category("Visibility")
@export var enabled: bool = true
@export var visible: bool = true
var interacting: bool = false
