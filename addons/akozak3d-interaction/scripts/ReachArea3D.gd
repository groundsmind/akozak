class_name ReachArea3D
extends Area3D

@export var reach_length: float = 1.0
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	collision_shape_3d.shape.length = reach_length
