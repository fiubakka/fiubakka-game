extends Control

signal go_to_main_menu

const button_scene = preload("res://src/scenes/truco/Interface/button.tscn")

func _ready() -> void:
	var lang_container := $NinePatchRect/VBoxContainer/Languages
	
	var locales := TranslationServer.get_loaded_locales()
	for locale in locales:
		var button := _create_lang_button(locale)
		lang_container.add_child(button)

func _create_lang_button(locale: String) -> Button:
	var button := button_scene.instantiate()
	button.text = locale.to_upper()
	button.pressed.connect(self._on_button_pressed.bind(button))
	return button

func _on_button_pressed(button: Button) -> void:
	var locale: String = button.text.to_lower()
	TranslationServer.set_locale(locale)
	go_to_main_menu.emit()
	queue_free()
