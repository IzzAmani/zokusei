extends Area2D

signal change_room(current_room)


func _ready() -> void :
    add_to_group("Doors")
    
func _on_body_entered(player: Node2D) -> void :
    if player.name != "Player":
        return
        
    emit_signal("change_room", Vector2(player.direction.x, 0))
