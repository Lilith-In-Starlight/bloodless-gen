extends Control

const SIGILDIR := "user://sigildef/"
const PACKDIR := "user://packs/"

var sigils := {
	"" : null
}
var packs :Dictionary = {}

var current_pack = 0
var current_card = 0

func _ready() -> void:
	load_sigils()
	load_packs()
	load_cards()

func _process(delta: float) -> void:
	if Engine.get_frames_drawn() > 3 and current_pack < packs.keys().size():
		var texture := get_viewport().get_texture().get_data()
		texture.flip_y()
		var dir := "user://card_%s.png"
		texture.convert(Image.FORMAT_RGBA8)
		
		texture.save_png(dir % Engine.get_frames_drawn())
		
	if Engine.get_frames_drawn() > 1:
		if current_pack < packs.keys().size():
			var pack = packs[packs.keys()[current_pack]]
			if current_card < pack.size():
				var card = pack[current_card]
				$Card.card = card
				$Card.redraw()
				current_card += 1
			else:
				current_pack += 1
				current_card = 0


func load_cards():
	for i in packs.keys():
		var packdir = Directory.new()
		if packdir.open(PACKDIR + i) == OK:
			packdir.list_dir_begin(true, true)
			var file = packdir.get_next()
			while file:
				if file.ends_with(".png"):
					file = packdir.get_next()
					continue
				var cardfile = File.new()
				cardfile.open(PACKDIR + i + "/" + file, File.READ)
				var linec = 0
				var new_card = Card.new()
				new_card.image = get_external_texture(PACKDIR + i + "/" + file + ".png")
				for l in cardfile.get_as_text().replace("\r\n", "\n").split("\n"):
					match linec:
						0: new_card.cname = l
						1: 
							var a = l.split(" ")
							new_card.att = a[0]
							new_card.def = a[1]
							new_card.hp = a[2]
							new_card.cost = a[3]
						2: new_card.flavor = l
						3: new_card.evol[0] = l
						4: new_card.evol[1] = l
						5: 
							if l.find("!") != -1:
								l = l.replace("!", "")
								new_card.sigil1[1] = true
							new_card.sigil1[0] = sigils[l]
						6: new_card.sigil2[0] = sigils[l]
						7: new_card.sigil3[0] = sigils[l]
					linec += 1
				packs[i].append(new_card)
				file = packdir.get_next()


func load_sigils():
	var sigildir = Directory.new()
	if sigildir.open(SIGILDIR) == OK:
		sigildir.list_dir_begin(true, true)
		var file = sigildir.get_next()
		while file:
			var sigfile = File.new()
			var new_sigil = Sigil.new()
			if file.ends_with(".png"):
				file = sigildir.get_next()
				continue
			new_sigil.icon = get_external_texture(SIGILDIR + file + ".png")
			sigfile.open(SIGILDIR + file, File.READ)
			var linec = 0
			for l in sigfile.get_as_text().replace("\r\n", "\n").split("\n"):
				match linec:
					0: new_sigil.sname = l
					1: new_sigil.remind1 = l
					2: new_sigil.remind2 = l
				linec += 1
			sigils[file] = new_sigil
			file = sigildir.get_next()
	else:
		get_tree().quit()


func load_packs():
	var sigildir = Directory.new()
	if sigildir.open(PACKDIR) == OK:
		sigildir.list_dir_begin(true, true)
		var file = sigildir.get_next()
		while file:
			packs[file] = []
			file = sigildir.get_next()
	else:
		get_tree().quit()


func get_external_texture(path):
	var img = Image.new()
	img.load(path)
	var texture = ImageTexture.new()
	texture.create_from_image(img, 0)
	return texture
