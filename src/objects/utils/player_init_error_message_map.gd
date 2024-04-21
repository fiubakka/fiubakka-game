extends Node

const ERROR_CODES_TO_MSG_MAP := {
	"UNKNOWN": "Error desconocido",
	"INVALID_PLAYER_CREDENTIALS": "Credenciales invalidas",
	"PLAYER_ALREADY_EXISTS": "Usuario no disponible",
	"EMPTY_USERNAME": "Ingrese un nombre",
	"EMPTY_PASSWORD": "Ingrese una contraseña",
}


func error_code_to_msg(error_code: String) -> String:
	return ERROR_CODES_TO_MSG_MAP[error_code]
