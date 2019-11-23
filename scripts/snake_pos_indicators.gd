extends Spatial

export var snake_path: NodePath
var _snake

func _ready():
    _snake = get_node(snake_path)

func _process(_delta):
    var pos = _snake.head.translation
    
    $x.translation.y = pos.y
    $x.translation.z = pos.z
    
    $y.translation.x = pos.x
    $y.translation.z = pos.z
    
    $z.translation.x = pos.x
    $z.translation.y = pos.y
    
