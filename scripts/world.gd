extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var native_lib := preload("res://core_lib.tres")

export var bounds_aa := Vector3(-10, 0, -10)
export var bounds_bb := Vector3(10, 20, 10)

onready var _snake := $snake
onready var _out_box := $out_box

var wall_elements: Array

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

static func is_touching_wall(aa: Vector3, bb: Vector3, point: Vector3) -> bool:
    return touching_how_many_walls(aa, bb, point) >= 1

static func is_at_inflection(aa: Vector3, bb: Vector3, point: Vector3) -> bool:
    return touching_how_many_walls(aa, bb, point) >= 2

static func inflection_turn_dir(aa: Vector3, bb: Vector3, point: Vector3, dir: Vector3) -> Vector3:
    return Vector3.ZERO

func _ready():
    wall_elements = get_tree().get_nodes_in_group('wall')

func _process(delta):
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

