extends Camera


var _current_sway := Vector3.ZERO
var _intermediate_sway := Vector3.ZERO
var _target_sway := Vector3.ZERO

export var sway_range := 1.0
export var lerp_speed := 0.1
export var new_sway_threshold := 1.0

func random_vec() -> Vector3:
    return Vector3(randf() - 0.5, randf() - 0.5, randf() - 0.5).normalized()

func _process(_delta):
    if _current_sway.distance_to(_target_sway) < new_sway_threshold:
        _target_sway = random_vec() * sway_range
        
    _intermediate_sway = _intermediate_sway.linear_interpolate(_target_sway, lerp_speed)
    _current_sway = _current_sway.linear_interpolate(_intermediate_sway, lerp_speed)
    
    translation = _current_sway
