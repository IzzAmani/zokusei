extends StaticBody2D

@onready var label = $InteractLabel 

func _ready():
    label.visible = false

func _on_tree_range_body_entered(body: Node2D):
    if (body.name == "Player"):
        label.visible = true
    
func _on_tree_range_body_exited(body: Node2D):
    if (body.name == "Player"):
        label.visible = false
