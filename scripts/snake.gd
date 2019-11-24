extends Spatial

onready var head: Spatial = $head
onready var body: Spatial = $body
onready var Segment := preload("res://prefabs/segment.tscn")
onready var root := $".."

signal on_eat_food(food)
signal on_death()

export var t: float = 2.0
var _t: float = t
var tail: Array = []

var grow_counter := 0
var is_in_air := false
var is_alive := true

var direction := Vector3.FORWARD
var current_up := Vector3.UP

func _ready() -> void:
    _t = t
    for child in body.get_children():
        tail.append(child)

func get_pos() -> Vector3:
    return head.translation

func _process(delta) -> void:
    if is_in_air:
        _t -= delta * 3
    else:
        _t -= delta

    if not is_alive:
        return
        
    if not is_in_air and Input.is_action_just_pressed('ui_left'):
        direction = direction.cross(-current_up)

    if not is_in_air and Input.is_action_just_pressed('ui_right'):
        direction = direction.cross(current_up)

    if not is_in_air and Input.is_action_just_pressed("ui_accept"):
        jump()

    head.transform = head.transform.looking_at(head.translation + direction, current_up)
    $indicator.translation = root.clamp(root.flip(head.translation, current_up))

    if _t <= 0:
        move_forward()
        _t = t

    for food_node in get_tree().get_nodes_in_group('food'):
        if food_node is Spatial && food_node.translation == head._target_pos:
            eat(food_node)

func jump():
    is_in_air = true
    var tmp = direction
    direction = current_up
    current_up = -tmp

func eat(food_node: Spatial):
    get_tree().queue_delete(food_node)
    emit_signal("on_eat_food", food_node)
    grow()
    
func die():
    emit_signal("on_death")
    is_alive = false
    $indicator.visible = false
    
    head.die()
    for segment in tail:
        segment.die()

func grow():
    grow_counter += 5

func is_touching_self():
    var head_pos = head._target_pos
    for segment in tail:
        var segment_pos = segment._target_pos
        if head_pos.distance_to(segment_pos) < 1:
            return true
    return false

func move_forward():
    var last_pos = head._target_pos
    var next_pos = last_pos + (direction * 2)
    
    if root.is_out_of_bounds(next_pos):
        is_in_air = false
        var tmp = self.direction
        self.direction = self.current_up
        self.current_up = -tmp
        
#    head.global_translate(direction * 2)
    head.translate_pos(direction * 2)
    
    if is_touching_self():
        die()

    for segment in tail:
        var tmp = segment.translation
#        segment.translation = last_pos
        segment.update_pos(last_pos)
#        segment.look_at()
        last_pos = tmp

    if grow_counter > 0:
        grow_counter -= 1
        var new_segment := Segment.instance()
        add_child(new_segment)
        new_segment.translation = last_pos
        new_segment.update_pos(last_pos)
        tail.append(new_segment)

