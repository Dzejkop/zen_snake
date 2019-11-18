extends Spatial

export var width := 10
export var height := 10

export var prefab := "res://prefabs/wall_cube.tscn"
var _prefab
var _cubes = []

export var spacing := 2

func _ready():
    _prefab = load(prefab)
    for x in range(width):
        var row = []
        for y in range(height):
            var new_obj = _prefab.instance()
            add_child(new_obj)
            new_obj.translation = Vector3(x * spacing, 0, y * spacing)
            row.append(new_obj)
        
        _cubes.append(row)
    print(_cubes)
    
var t = 2

func _process(delta):
    t -= delta

    if t <= 0:
        var x = randi() % width
        var y = randi() % height
        
        var node = _cubes[x][y]
        print(node)
        node.set_active()
        t = 2
