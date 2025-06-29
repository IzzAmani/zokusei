extends Control

@export var scene_text_file: String

var scene_text = {}
var selected_text = []
var is_running = false

@onready var frame = $Frame
@onready var text = $Frame/Text

func _ready():
    self.visible = false
    scene_text = load_em_text()
    DialogManager.connect("display_dialog", on_display_dialog)
    
func load_em_text():
    if scene_text_file:
        var json = JSON.new()
        var string = FileAccess.open(scene_text_file, FileAccess.READ).get_as_text()
        var error = json.parse(string)
        if error == OK:
            return json.data
        else:
            return

func show_text():
    text.text = selected_text.pop_front()

func next_line():
    if selected_text.size() > 0:
        show_text()
    else:
        finish()
        
func finish():
    text.text = ""
    get_tree().paused = false
    self.visible = false
    is_running = false
    

func on_display_dialog(dialog):
    if is_running:
        next_line()
    else:
        get_tree().paused = true
        self.visible = true
        is_running = true
        selected_text = scene_text[dialog].duplicate()
        print(selected_text)
        show_text()
