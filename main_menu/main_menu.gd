extends Control
signal show_menu
var clicked = false

func _input(event: InputEvent) -> void:
    if event.is_pressed() && clicked == false:
        print("done")
        clicked = true
        emit_signal("show_menu")
        $Flash.visible = false
        
