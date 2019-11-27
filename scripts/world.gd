extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var bounds_aa := Vector3(-10, 0, -10)
export var bounds_bb := Vector3(10, 20, 10)

onready var _snake := $snake
onready var _out_box := $out_box

signal on_quit()

var wall_elements: Array

var _game_in_progress := false

func has_game_started() -> bool:
    return _game_in_progress
    
func is_game_in_progress() -> bool:
    return _game_in_progress

func vec_x(v: Vector3) -> Vector3:
    return Vector3(v.x, 0, 0)

func vec_y(v: Vector3) -> Vector3:
    return Vector3(0, v.y, 0)

func vec_z(v: Vector3) -> Vector3:
    return Vector3(0, 0, v.z)

func nearest_corner(v: Vector3) -> Vector3:
    var corners = [
        bounds_aa,
        
        bounds_aa + vec_x(bounds_bb),
        bounds_aa + vec_y(bounds_bb),
        bounds_aa + vec_z(bounds_bb),
        
        bounds_aa + vec_x(bounds_bb) + vec_y(bounds_bb),
        bounds_aa + vec_x(bounds_bb) + vec_z(bounds_bb),
        bounds_aa + vec_y(bounds_bb) + vec_z(bounds_bb),
        
        bounds_bb
    ]
    
    var current_nearest = bounds_aa
    
    for corner in corners:
        if v.distance_to(corner) < v.distance_to(current_nearest):
            current_nearest = corner
    
    return current_nearest

static func count_zeros(v: Vector3) -> int:
    var count = 0
    if v.x == 0:
        count += 1
    if v.y == 0:
        count += 1
    if v.z == 0:
        count += 1
    return count

static func touching_how_many_walls(aa: Vector3, bb: Vector3, point: Vector3) -> int:
    var to_aa = aa - point
    var to_bb = bb - point

    return count_zeros(to_aa) + count_zeros(to_bb)

func is_out_of_bounds(point: Vector3) -> bool:
    var behind_aa = point.x < bounds_aa.x or point.y < bounds_aa.y or point.z < bounds_aa.z
    var above_bb = point.x >= bounds_bb.x or point.y >= bounds_bb.y or point.z >= bounds_bb.z
    
    return behind_aa or above_bb
    
func origin() -> Vector3:
    var to_bb = bounds_bb - bounds_aa
    return bounds_aa + (to_bb / 2)
    
func clamp(v: Vector3) -> Vector3:
    var new_v: Vector3 = Vector3(v.x, v.y, v.z)
    
    if new_v.x < bounds_aa.x:
        new_v.x = bounds_aa.x
    if new_v.y < bounds_aa.y:
        new_v.y = bounds_aa.y
    if new_v.z < bounds_aa.z:
        new_v.z = bounds_aa.z
    
    if new_v.x > bounds_bb.x:
        new_v.x = bounds_bb.x
    if new_v.y > bounds_bb.y:
        new_v.y = bounds_bb.y
    if new_v.z > bounds_bb.z:
        new_v.z = bounds_bb.z
    
    return new_v
    
func flip(v: Vector3, normal: Vector3) -> Vector3:
    var to_bb = bounds_bb - bounds_aa
    return v + (normal.normalized() * to_bb.length() * 0.5)

static func is_touching_wall(aa: Vector3, bb: Vector3, point: Vector3) -> bool:
    return touching_how_many_walls(aa, bb, point) >= 1

static func is_at_inflection(aa: Vector3, bb: Vector3, point: Vector3) -> bool:
    return touching_how_many_walls(aa, bb, point) >= 2

func _ready():
    wall_elements = get_tree().get_nodes_in_group('wall')

func _process(_delta):
    if not has_game_started() && (Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right")):
        _game_in_progress = true
        $text_control.set_to_update_score()
        $env.glow_kick(10.0)
        
    if Input.is_action_just_pressed("ui_cancel"):
        $food_spawner.disable()
        emit_signal("on_quit")

    _out_box.get_surface_material(0).set_shader_param("snake_head_pos", _snake.head.translation)
    var max_dist = null
    for wall_elem in wall_elements:
        var dist = _snake.head.translation.distance_to(wall_elem.translation)
        if max_dist == null or (max_dist < dist):
            max_dist = dist

    for wall_elem in wall_elements:
        var dist = _snake.head.translation.distance_to(wall_elem.translation)
        var transparency = dist / max_dist
        wall_elem.update_transparency(transparency)



func _on_game_over():
    if $snake_pos_indicators:
        $snake_pos_indicators.visible = false
    $particles.speed_scale = 0
    $out_box.get_surface_material(0).set_shader_param("range", 0)
    $food_spawner.disable()
    $text_control.set_shift_text(["Press", "Escape", "To", "Restart"])
    $env.glow_kick(100)
