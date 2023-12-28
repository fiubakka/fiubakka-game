class_name Result

var _error: Error
# Godot does not have an Any type, so ignore the warning
@warning_ignore("untyped_declaration")
var _value

@warning_ignore("untyped_declaration")


static func ok(value) -> Result:
	var result := Result.new()
	result._error = OK
	result._value = value
	return result


static func err(error: Error) -> Result:
	var result := Result.new()
	result._error = error
	result._value = null
	return result


func is_ok() -> bool:
	return _error == OK


func is_err() -> bool:
	return _error != OK


@warning_ignore("untyped_declaration")


func get_value():
	return _value


func get_err() -> Error:
	return _error
