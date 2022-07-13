tool
extends Control


export var text := "" setget set_text
export var centered := false setget set_centered
export var big_numbers := false setget set_bignum

const repl = {
	"?" : "qm"
}


func _ready() -> void:
	set_text(text)


func set_text(value:String):
	var w := 0
	for i in get_children():
		i.queue_free()
	for i in value:
		if i != " ":
			var new_texture := TextureRect.new()
			if not i in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
				var j = i
				if j in repl:
					j = repl[j]
				new_texture.texture = load("res://Font/" + j.to_upper() + ".png")
			elif big_numbers:
				new_texture.texture = load("res://NumbersBig/" + i + ".png")
			else:
				new_texture.texture = load("res://NumberSmol/" + i + ".png")
				new_texture.rect_position.y = -1
			new_texture.rect_position.x = w
			add_child(new_texture)
			w += new_texture.texture.get_width() + 1
		else:
			w += 3
	rect_size = Vector2(w, 8)
	
	if centered:
		for i in get_children():
			i.rect_position.x -= w/2
	text = value


func set_centered(value):
	centered = value
	set_text(text)


func set_bignum(value):
	big_numbers = value
	set_text(text)
