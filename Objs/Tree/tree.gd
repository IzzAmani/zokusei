extends StaticBody2D

signal player_enter(entering: bool)

@onready var label = $InteractLabel 

func _ready():
    label.visible = false

func _on_tree_range_body_entered(body: Node2D):
    if (body.name == "Player"):
        label.visible = true
        emit_signal("player_enter", true)
    
func _on_tree_range_body_exited(body: Node2D):
    if (body.name == "Player"):
        label.visible = false
        emit_signal("player_enter", false)
