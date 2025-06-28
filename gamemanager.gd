extends Node

var active_scene: Node = null
var game_paused: bool = false

func _ready() :
    active_scene = get_node("/root/MainMenu")
    
    
func change_scene(scene_path: String) :
    if active_scene :
        active_scene.queue_free()
    
    var scene = load(scene_path).instantiate()
    get_tree().root.add_child(scene)
    active_scene = scene
    
    if scene.name == "MainMenu" :
        get_tree().paused = false
        $"../MainMenu/".start_anim()
