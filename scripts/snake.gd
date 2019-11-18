extends Spatial

onready var head: Spatial = $head
onready var body: Spatial = $body
onready var Segment := preload("res://prefabs/segment.tscn")
onready var root := $".."

export var t: float = 2.0
var _t: float = t
var tail: Array = []

var grow_counter := 0
var is_in_air := false

var direction := Vector3.FORWARD
var current_up := Vector3.UP

func _ready() -> void:
    _t = t
    for child in body.get_children():
        tail.append(child)


func _process(delta) -> void:
    _t -= delta

    if not is_in_air and Input.is_action_just_pressed('ui_left'):
        direction = direction.cross(-current_up)

    if not is_in_air and Input.is_action_just_pressed('ui_right'):
        direction = direction.cross(current_up)

    if not is_in_air and Input.is_action_just_pressed("ui_accept"):
        jump()

    head.look_at(head.translation + direction, current_up)

    if _t <= 0:
        move_forward()
        _t = t

    for food_node in get_tree().get_nodes_in_group('food'):
        if food_node is Spatial && food_node.translation == head._target_pos:
            print('om nom')
            eat(food_node)

func jump():
    is_in_air = true
    var tmp = direction
    direction = current_up
    current_up = -tmp

func eat(food_node: Spatial):
    get_tree().queue_delete(food_node)
    grow()

func grow():
    grow_counter += 1

func is_touching_wall():
    pass

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

    for segment in tail:
        var tmp = segment.translation
#        segment.translation = last_pos
        segment.update_pos(last_pos)
#        segment.look_at()
        last_pos = tmp

    if grow_counter > 0:
        print('growing...')
        grow_counter -= 1
        var new_segment := Segment.instance()
        body.add_child(new_segment)
        new_segment.translation = last_pos
        tail.append(new_segment)

