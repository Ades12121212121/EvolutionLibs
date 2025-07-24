local Utils = {}

function Utils:Lerp(a, b, t)
	return a + (b - a) * t
end

function Utils:LerpColor(color1, color2, t)
	return Color3.new(
		self:Lerp(color1.R, color2.R, t),
		self:Lerp(color1.G, color2.G, t),
		self:Lerp(color1.B, color2.B, t)
	)
end

function Utils:CreateRipple(button, color)
	color = color or Color3.fromRGB(255, 255, 255)
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local ripple = Instance.new("Frame")
			ripple.Name = "Ripple"
			ripple.Size = UDim2.new(0, 0, 0, 0)
			ripple.BackgroundColor3 = color
			ripple.BackgroundTransparency = 0.7
			ripple.BorderSizePixel = 0
			ripple.ZIndex = 100
			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = ripple
			ripple.Parent = button
			local mouse = game:GetService("UserInputService"):GetMouseLocation()
			local buttonPos = button.AbsolutePosition
			local buttonSize = button.AbsoluteSize
			local relativeX = mouse.X - buttonPos.X
			local relativeY = mouse.Y - buttonPos.Y
			ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
			local maxSize = math.max(buttonSize.X, buttonSize.Y) * 2
			local tween = game:GetService("TweenService"):Create(ripple, 
				TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{
					Size = UDim2.new(0, maxSize, 0, maxSize),
					Position = UDim2.new(0, relativeX - maxSize/2, 0, relativeY - maxSize/2),
					BackgroundTransparency = 1
				}
			)
			tween:Play()
			tween.Completed:Connect(function()
				ripple:Destroy()
			end)
		end
	end)
end

function Utils:Animate(object, properties, duration, easingStyle, easingDirection)
	duration = duration or 0.3
	easingStyle = easingStyle or Enum.EasingStyle.Quad
	easingDirection = easingDirection or Enum.EasingDirection.Out
	local tween = game:GetService("TweenService"):Create(
		object,
		TweenInfo.new(duration, easingStyle, easingDirection),
		properties
	)
	tween:Play()
	return tween
end

return Utils 