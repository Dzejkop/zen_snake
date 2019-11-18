extends Node

onready var food_prefab := preload("res://prefabs/food.tscn")

export var max_food_count = 4

var t = 2

onready var world := $".."


func _process(delta):
    t -= delta
    
    if t <= 0:
        t = 2
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

func spawn_food():
    var new_food = food_prefab.instance()
    new_food.translation = random_wall_position()
    get_tree().root.add_child(new_food)
#    food_prefab
