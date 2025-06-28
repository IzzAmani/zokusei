extends Control

#signal show_menu
var clicked := false
var anim_started := false
    
func _ready() -> void :
    start_anim()
    
func start_anim() :
    clicked = false
    anim_started = true
    
    $BG/AnimationPlayer.play("bganiamte")
    $GameStart.play("startup")
    
    print($GameStart.get_animation_list())
    
    
func _input(event: InputEvent) -> void:
    #if event.is_pressed() && clicked == false:
    if event.is_action_pressed("leftClick") and !clicked and !anim_started: 
        print("Played pressed start!")
        clicked = true
        
        show_menu()
        $Flash.visible = false
        
        
func show_menu() -> void:
    print("Showing Menu")
    $Hint/HintAnim.play("RESET")
    $GameStart.play("showmenu")


func _on_game_start_animation_finished(anim_name: StringName) -> void:
    if anim_name == "startup":
        $GameStart.play("flash")
        $TextureRect/TitleAnim.play("floating_title")
        $Hint/HintAnim.play("blinking")
        anim_started = false
