extends Spatial

export var speed = 1

var _current_speed = 0
var _target_speed = 0

func _process(delta):
    var left = Input.get_action_strength("camera_left")
    var right = Input.get_action_strength("camera_right")
    _target_speed = right + (-left)
    _current_speed = lerp(_current_speed, _target_speed, 0.1)
    
    transform = transform.rotated(Vector3.UP, _current_speed * delta * speed)
