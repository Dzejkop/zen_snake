extends Node

onready var food_prefab := preload("res://prefabs/food.tscn")

export var max_food_count = 4

var _is_spawning := true

export var t := 5.0
var _t = 0

onready var world := $".."

var _foods = []

func on_food_eaten(food_node):
    _foods.erase(food_node)

func _process(delta):
    if not world.is_game_in_progress():
        return
    _t -= delta
    
    if _is_spawning && _t <= 0:
        _t = t
        spawn_food()

func random_wall_position():
    var aa = world.bounds_aa
    var bb = world.bounds_bb
    
    var max_v = bb - aa
    var rand_x = (randi() % int(max_v.x / 2)) * 2
    var rand_y = (randi() % int(max_v.y / 2)) * 2
    var rand_z = (randi() % int(max_v.z / 2)) * 2
    
    var which_to_zero = randi() % 3
    if which_to_zero == 0:
        rand_x = 0
    elif which_to_zero == 1:
        rand_y = 0
    else:
        rand_z = 0
    
    return aa + Vector3(rand_x, rand_y, rand_z)
    
func only_largest(v: Vector3) -> Vector3:
    if abs(v.x) >= abs(v.y) && abs(v.x) >= abs(v.z):
        return Vector3(v.x, 0, 0)
    elif abs(v.y) >= abs(v.x) && abs(v.y) >= abs(v.z):
        return Vector3(0, v.y, 0)
    else:
        return Vector3(0, 0, v.z)

func spawn_food():
    if len(_foods) >= max_food_count:
        return
        
    var new_food = food_prefab.instance()
    var pos = random_wall_position()
    
    while $"../snake".intersects(pos):
        pos = random_wall_position()

    var v = world.origin() - pos

    var normal = only_largest(world.origin() - pos)

    normal = normal.normalized()
    var nearest_corner = world.nearest_corner(pos)
    var to_corner = nearest_corner - pos

    get_parent().add_child(new_food)
    new_food.translation = pos
    new_food.transform = new_food.transform.looking_at(pos + to_corner, normal)
    _foods.append(new_food)
#    

func disable():
    _is_spawning = false
    for f in _foods:
        f.queue_free()
    _foods.clear()
