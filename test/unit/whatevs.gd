extends "res://addons/gut/test.gd"

var World = load("res://scripts/world.gd")

func test_touch_direction():
    var aa = Vector3(0, 0, 0)
    var bb = Vector3(5, 5, 5)
    assert_true(World.touching_how_many_walls(aa, bb, Vector3(3, 0, 0)) == 2)
    assert_true(World.touching_how_many_walls(aa, bb, Vector3(5, 0, 0)) == 3)
