extends Control

var animation_playing := false


func show_menu(show: bool) -> void:
    if show :
        mouse_filter = Control.MOUSE_FILTER_STOP
        visible = true
        get_tree().paused = true
        $Anim.play("SlideIn")
        animation_playing = true
        
    else :
        mouse_filter = Control.MOUSE_FILTER_IGNORE
        $Anim.play("SlideOut")
        animation_playing = true


func _on_anim_animation_finished(anim_name: StringName) -> void:
    if anim_name == "SlideIn" :
        animation_playing = false
        
    elif anim_name == "SlideOut" :
        get_tree().paused = false
        visible = false
        animation_playing = false


func _input(evt):
    var tablet_node = $"../Tablet"
    if evt.is_action_pressed("pauseMenu") :
        if tablet_node.visible :
            tablet_node.visible = false
        
        elif !animation_playing :
            show_menu(!get_tree().paused)


func _on_resume_pressed() -> void:
    show_menu(false)


func _on_quit_pressed() -> void:
    get_tree().root.get_node("GameManager").change_scene("res://main_menu/main_menu.tscn")
