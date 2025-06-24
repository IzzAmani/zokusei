extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    $Tablet.visible = false
    
    $Node2D/Tree.player_enter.connect(
        func(show: bool):
            $Tablet.visible = show    
    )
