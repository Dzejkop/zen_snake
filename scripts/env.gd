extends WorldEnvironment

export var max_glow_intensity := 50.0
export var min_glow_intensity := 1.0

var _current_glow_t := 0.0
var target_glow_t := 0.0

func glow_intensity(t: float):
    return ((1 - t) * min_glow_intensity) + (t * max_glow_intensity)

func glow_kick(mag):
    if typeof(mag) == TYPE_REAL:
        target_glow_t = mag
    else:
        target_glow_t = 1.0

func _process(_delta):
    _current_glow_t = lerp(_current_glow_t, target_glow_t, 0.1)
    target_glow_t = lerp(target_glow_t, 0.0, 0.2)

    environment.glow_intensity = glow_intensity(_current_glow_t)

