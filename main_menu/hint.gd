extends Label

func _on_show_menu() -> void:
    print("ok!")
    $AnimationPlayer.play("RESET")
