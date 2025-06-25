extends AnimationPlayer


func _on_animation_finished(anim_name: StringName) -> void:
    if anim_name == "startup":
        play("flash")
        $"../TextureRect/AnimationPlayer".play("floating_title")
        $"../Hint/AnimationPlayer".play("blinking")


func _on_main_menu_show_menu() -> void:
    play("showmenu")
