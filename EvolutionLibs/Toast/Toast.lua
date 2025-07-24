local Toast = {}

function Toast.show(text, type, duration, parent)
	duration = duration or 2
	local gui = Instance.new("ScreenGui")
	gui.Name = "EvolutionToast"
	gui.Parent = parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")
	local toast = Instance.new("TextLabel")
	toast.Size = UDim2.new(0, 320, 0, 40)
	toast.Position = UDim2.new(0.5, -160, 0.1, 0)
	toast.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
	if type == "success" then toast.BackgroundColor3 = Color3.fromRGB(76, 175, 80) end
	if type == "error" then toast.BackgroundColor3 = Color3.fromRGB(244, 67, 54) end
	toast.TextColor3 = Color3.fromRGB(255,255,255)
	toast.Text = text
	toast.Font = Enum.Font.GothamBold
	toast.TextSize = 16
	toast.BackgroundTransparency = 0.1
	toast.Parent = gui
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toast
	game:GetService("TweenService"):Create(toast, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
	delay(duration, function()
		game:GetService("TweenService"):Create(toast, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		wait(0.3)
		gui:Destroy()
	end)
end

return Toast 