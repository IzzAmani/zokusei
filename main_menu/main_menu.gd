extends Control

#signal show_menu
var clicked = false

func _ready() :
    #$GameStart.play("startup")
    #start_anim()
    pass
    
    
func start_anim() :
    print("starting main")
    clicked = false
    
    $BG/AnimationPlayer.play("bganiamte")
    $GameStart.play("startup")
    
    print($GameStart.get_animation_list())
    print("shouldve played startup")
    
    
func _input(event: InputEvent) -> void:
    #if event.is_pressed() && clicked == false:
    if event.is_action_pressed("leftClick") and !clicked : 
        print("Played pressed start!")
        clicked = true
        
        show_menu()
        $Flash.visible = false
        
        
func show_menu() -> void:
    print("Showing Menu")
    $Hint/HintAnim.play("RESET")
    $GameStart.play("showmenu")


    #if scene.name == "MainMenu" :
        #print("yes main")
        #$"../MainMenu/".start_anim()
func _on_game_start_animation_finished(anim_name: StringName) -> void:
    print("finished anim")
    if anim_name == "startup":
        print("startup finished")
        $GameStart.play("flash")
        $TextureRect/TitleAnim.play("floating_title")
        $Hint/HintAnim.play("blinking")

func _process(delta) :
    if $GameStart.is_playing() :
        print("Playing: ", $GameStart.current_animation)
