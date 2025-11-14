extends Marker2D

func changeText(textstr):
	$Label.text = str(textstr);

func play():
	$gainerAn.play("cling")

func spawnGainer(amount,pos):
	self.position = pos
	self.changeText(str(amount) + "+")
	self.play()
