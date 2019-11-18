extends Spatial

var _target_pos: Vector3

func _ready():
    _target_pos = translation

func update_pos(translation: Vector3):
    _target_pos = translation
    
func translate_pos(v: Vector3):
    _target_pos += v

func _process(delta):
    translation = translation.linear_interpolate(_target_pos, 0.5)
