extends Spatial

onready var prefab = preload("res://cube.tscn")
export var t = 1.0

var _t = t

func _process(delta):
    _t -= delta
    if _t <= 0.0:
        print('spawning')
        var node = prefab.instance()
        get_parent().add_child(node)
        node.transform = self.transform
        _t = t

