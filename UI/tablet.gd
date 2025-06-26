extends Control

func _ready() -> void :
    print("Tablet initiated")
    var tablet_scr = $Panel/TabletScreen
    
    # Adding new attr control for each custom attributes each trees have
    for object in get_tree().get_nodes_in_group("Objects") :
        for attr_key in object.attributes :
            var attr_value = object.attributes[attr_key]
            #var attr_value = tree.attributes[attr_key][0]
            
            var new_attr = VBoxContainer.new()
            var attr_label = Label.new()
            var attr_input: Node
              
            # Add label
            attr_label.text = attr_key + ": "
            attr_label.add_theme_font_size_override("font_size", 69)
            new_attr.add_child(attr_label)    
            
            print("Attr_value: ", attr_value)
            # Add input based on type
            if typeof(attr_value) == TYPE_BOOL :
                attr_input = Button.new()
                attr_input.text = "Enabled" if attr_value else "Disabled"
                
                attr_input.pressed.connect(update_button.bind(object, attr_key, attr_input))
                #attr_input.pressed.connect(func():
                    #print("Pressed Button!!!! ", attr_value)
                    #object.attributes[attr_key] = !attr_value
                    #attr_input.text = "Enabled" if attr_value else "Disabled"
                #)
                
                
            elif typeof(attr_value) == TYPE_INT :
                attr_input = SpinBox.new()
                attr_input.min_value = 0
                attr_input.max_value = 100
                #attr_input.value_changed.connect(value_altered.bind(attr_key, object))
            
            else :
                attr_input = Button.new()
                attr_input.text = "HI"
                
            attr_input.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
            new_attr.add_child(attr_input)
            
            # Add the attr line onto the tablet screen
            tablet_scr.add_child(new_attr)
            new_attr.add_to_group("Buttons")



func update_button(obj, key, btn) :
    print("HUH ", obj)
    if key == "Collision" :
        obj.update_attr(key, !obj.attributes[key])  #NOT the disability
        obj.get_node("TreeHitbox/CollisionShape2D").disabled = !obj.attributes[key]
        btn.text = "Enabled" if obj.attributes[key] else "Disabled"

















#func value_altered(new_value, attr_name: String, object: Node) -> void:
    #print("Alt Values: ", object, " ", new_value, " ", attr_name)
    #
    #if attr_name == "Collision" :
        #new_value = !new_value
        #
        #object.update_attr(attr_name, new_value)
        #object.get_node("CollisionShape2D").disabled = new_value
