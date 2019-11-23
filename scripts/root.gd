extends Node

var _current_game = null

func enter_game():
    if _current_game != null:
        _current_game.queue_free()
        _current_game = null
    _current_game = load("res://scenes/root.tscn").instance()
    add_child(_current_game)
    _current_game.connect("on_quit", self, "enter_menu")
    $Panel.visible = false

func enter_menu():
    if _current_game != null:
        _current_game.queue_free()
        _current_game = null
    $Panel.visible = true
