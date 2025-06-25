extends Node

var active_scene: Node = null

func _ready() :
    active_scene = get_node("/root/MainMenu")
    
    
func change_scene(scene_path: String) :
    if active_scene :
        active_scene.queue_free()
    
    var scene = load(scene_path).instantiate()
    get_tree().root.add_child(scene)
    active_scene = scene
    
func _input(evt):
    if evt.is_action_pressed("pauseMenu"):
        change_scene("res://main_menu/main_menu.tscn")
