extends Node

onready var food_prefab := preload("res://prefabs/food.tscn")

export var max_food_count = 4

var t = 2

func _process(delta):
    t -= delta
    
    if t <= 0:
        t = 2
        spawn_food()

func random_wall():
    var random_vec = Vector3(randf(), randf(), randf()).normalized()
    

func spawn_food():
    var new_food = food_prefab.instance()
    var new_food_pos = randi() % 6
    get_tree().root.add_child(new_food)
#    food_prefab
