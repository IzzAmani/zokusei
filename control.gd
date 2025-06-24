extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Panel/VBoxContainer.size = $Panel/VBoxContainer.size * 0.9
    pass

func change_visibility() :
    pass
