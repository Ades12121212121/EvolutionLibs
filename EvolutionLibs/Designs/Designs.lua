local Designs = {}

Designs.Themes = {
	Dark = {
		Background = Color3.fromRGB(25, 25, 35),
		Surface = Color3.fromRGB(35, 35, 45),
		Primary = Color3.fromRGB(70, 130, 255),
		Secondary = Color3.fromRGB(45, 45, 55),
		Accent = Color3.fromRGB(100, 200, 100),
		Text = Color3.fromRGB(245, 245, 245),
		TextSecondary = Color3.fromRGB(180, 180, 180),
		Border = Color3.fromRGB(60, 60, 70),
		Success = Color3.fromRGB(76, 175, 80),
		Warning = Color3.fromRGB(255, 193, 7),
		Error = Color3.fromRGB(244, 67, 54),
		Hover = Color3.fromRGB(255, 255, 255),
		Disabled = Color3.fromRGB(120, 120, 120)
	},
	Light = {
		Background = Color3.fromRGB(250, 250, 250),
		Surface = Color3.fromRGB(255, 255, 255),
		Primary = Color3.fromRGB(33, 150, 243),
		Secondary = Color3.fromRGB(240, 240, 240),
		Accent = Color3.fromRGB(255, 87, 34),
		Text = Color3.fromRGB(33, 33, 33),
		TextSecondary = Color3.fromRGB(117, 117, 117),
		Border = Color3.fromRGB(224, 224, 224),
		Success = Color3.fromRGB(76, 175, 80),
		Warning = Color3.fromRGB(255, 193, 7),
		Error = Color3.fromRGB(244, 67, 54),
		Hover = Color3.fromRGB(0, 0, 0),
		Disabled = Color3.fromRGB(189, 189, 189)
	},
	Futuristic = {
		Background = Color3.fromRGB(15, 15, 25),
		Surface = Color3.fromRGB(25, 25, 40),
		Primary = Color3.fromRGB(0, 255, 255),
		Secondary = Color3.fromRGB(35, 35, 50),
		Accent = Color3.fromRGB(255, 0, 128),
		Text = Color3.fromRGB(255, 255, 255),
		TextSecondary = Color3.fromRGB(180, 180, 200),
		Border = Color3.fromRGB(0, 255, 255),
		Success = Color3.fromRGB(0, 255, 127),
		Warning = Color3.fromRGB(255, 215, 0),
		Error = Color3.fromRGB(255, 20, 147),
		Hover = Color3.fromRGB(0, 255, 255),
		Disabled = Color3.fromRGB(100, 100, 120),
		Gradient = {
			ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(128, 0, 255))
			})
		}
	}
}

return Designs 