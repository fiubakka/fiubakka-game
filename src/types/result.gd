class_name Result

var _error: Error
var _value: Object


static func ok(value: Object) -> Result:
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


func get_value() -> Object:
	return _value


func get_err() -> Error:
	return _error
