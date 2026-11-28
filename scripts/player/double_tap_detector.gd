class_name DoubleTapDetector
extends RefCounted
## H05 · Detects a double tap of the SAME direction key inside a configurable window (D-025).
## Pure logic with an explicit clock so tests are deterministic. It never reads Input itself.
##
## Rules (docs/CONTROLS.md, CT-01..CT-03):
## - Only fresh presses count: releases and OS auto-repeat (echo) are ignored.
## - Two presses of the same key within `window_s` produce exactly one dash request.
## - The pair is consumed: a third press starts a new pair, it never reuses the second press.
## - A press of a different key replaces the pending one (WA, WD... never dash).
## - A press after the window expired becomes the new first tap.

var window_s := 0.25

var _pending_key: StringName = &""
var _pending_time := 0.0


func _init(window_seconds: float = 0.25) -> void:
    window_s = window_seconds


## Feeds one key event. Returns the key that completed a double tap, or &"" if none.
func feed(key: StringName, pressed: bool, echo: bool, time_s: float) -> StringName:
    if not pressed or echo or key == &"" or not is_finite(time_s):
        return &""
    if key == _pending_key and time_s - _pending_time <= window_s and time_s >= _pending_time:
        reset()
        return key
    _pending_key = key
    _pending_time = time_s
    return &""


func reset() -> void:
    _pending_key = &""
    _pending_time = 0.0


func has_pending() -> bool:
    return _pending_key != &""
