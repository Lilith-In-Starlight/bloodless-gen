extends Control


var card: Card = null

func redraw():
	if card != null:
		$Name.text = card.cname
		$Hp.text = str(card.hp)
		$Def.text = str(card.def)
		$Att.text = str(card.att)
		$Flavor.text = card.flavor
		$From.visible = card.evol[0] != ""
		$To.visible = card.evol[1] != ""
		$From/Text.text = card.evol[0]
		$To/Text.text = card.evol[1]
		$ArtFrame/TextureRect.texture = card.image
		if card.evol == ["", ""]:
			$Sigs.rect_position.y = -16
		else:
			$Sigs.rect_position.y = 0
		if card.image != null:
			$ArtFrame/TextureRect.rect_position.x = $ArtFrame.texture.get_width() / 2.0 - card.image.get_width() / 2.0
			$ArtFrame/TextureRect.rect_position.y = $ArtFrame.texture.get_height() / 2.0 - card.image.get_height() / 2.0
		
		if $From.visible:
			$To.rect_position.x = 136
		else:
			$To.rect_position.x = $From.rect_position.x
		
		if card.sigil1[0] != null:
			$Sigs/Sig1/Text.text = card.sigil1[0].sname
			$Sigs/Sig1.texture = card.sigil1[0].icon
			if card.sigil1[1]:
				$Sigs/Sig1/Description.text = card.sigil1[0].remind1
				$Sigs/Sig1/Description.visible = true
				$Sigs/Sigs.rect_position.y = 6
			else:
				$Sigs/Sigs.rect_position.y = 0
				$Sigs/Sig1/Description.visible = false
		if card.sigil2[0] != null:
			$Sigs/Sigs/Sig2/Text.text = card.sigil2[0].sname
			$Sigs/Sigs/Sig2.texture = card.sigil2[0].icon
		if card.sigil3[0] != null:
			$Sigs/Sigs/Sig3/Text.text = card.sigil3[0].sname
			$Sigs/Sigs/Sig3.texture = card.sigil3[0].icon
		$Cost.text = str(card.cost)
		if card.cost == 0:
			$Cost.visible = false
			$CostIcon.visible = false
		elif card.cost == 1:
			$Cost.visible = false
			$CostIcon.visible = true
			$CostIcon.rect_position.x = 208
		else:
			$Cost.visible = true
			$CostIcon.visible = true
			$CostIcon.rect_position.x = 195
		$Sigs/Sig1.visible = card.sigil1[0] != null
		$Sigs/Sigs/Sig2.visible = card.sigil2[0] != null and card.sigil1[0] != null
		$Sigs/Sigs/Sig3.visible = card.sigil3[0] != null and card.sigil2[0] != null and card.sigil1[0] != null
