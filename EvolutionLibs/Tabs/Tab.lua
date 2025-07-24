-- Tab.lua - Tab management for EvolutionLibs GUI
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local BASE_URL = "https://raw.githubusercontent.com/Ades12121212121/EvolutionLibs/main/EvolutionLibs/"
_G.EvoLibsCache = _G.EvoLibsCache or {}
local function getUtils()
    if not _G.EvoLibsCache.Utils then _G.EvoLibsCache.Utils = loadstring(game:HttpGet(BASE_URL .. "Utils/Utils.lua"))() end
    return _G.EvoLibsCache.Utils
end
local function getDesigns()
    if not _G.EvoLibsCache.Designs then _G.EvoLibsCache.Designs = loadstring(game:HttpGet(BASE_URL .. "Designs/Designs.lua"))() end
    return _G.EvoLibsCache.Designs
end
local function getElements()
    if not _G.EvoLibsCache.Elements then _G.EvoLibsCache.Elements = loadstring(game:HttpGet(BASE_URL .. "Elements/Elements.lua"))() end
    return _G.EvoLibsCache.Elements
end

local Tab = {}
Tab.__index = Tab

-- Constants
local TAB_HEIGHT = 40
local ANIMATION_DURATION = 0.3
local RIPPLE_DURATION = 0.4
local ICON_SIZE = 20

-- Constructor
function Tab.new(window, name, icon)
	local self = setmetatable({}, Tab)
	self.Window = window
	self.Name = name
	self.Icon = icon
	self.Elements = {}
	self.Order = #window.Tabs + 1
	self.IsDragging = false

	-- Tab Button
	self.Button = Instance.new("TextButton")
	self.Button.Name = "TabButton_" .. name
	self.Button.Size = UDim2.new(1, -10, 0, TAB_HEIGHT)
	self.Button.BackgroundColor3 = Designs.Themes.Dark.Secondary
	self.Button.BorderSizePixel = 0
	self.Button.Text = icon and (icon .. " " .. name) or name
	self.Button.TextColor3 = Designs.Themes.Dark.TextSecondary
	self.Button.Font = Enum.Font.Gotham
	self.Button.TextSize = 14
	self.Button.TextXAlignment = Enum.TextXAlignment.Left
	self.Button.TextScaled = true
	self.Button.ZIndex = 5
	self.Button.Parent = window.SidebarTabList

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 6)
	buttonCorner.Parent = self.Button

	-- Icon (if provided)
	if icon then
		local iconLabel = Instance.new("ImageLabel")
		iconLabel.Name = "Icon"
		iconLabel.Size = UDim2.new(0, ICON_SIZE, 0, ICON_SIZE)
		iconLabel.Position = UDim2.new(0, 10, 0.5, -ICON_SIZE/2)
		iconLabel.BackgroundTransparency = 1
		iconLabel.Image = icon
		iconLabel.ImageColor3 = Designs.Themes.Dark.TextSecondary
		iconLabel.ZIndex = 6
		iconLabel.Parent = self.Button
		self.Button.TextXAlignment = Enum.TextXAlignment.Left
		self.Button.TextPadding = UDim.new(0, ICON_SIZE + 15)
	end

	-- Ripple Effect
	local function createRipple(input)
		local ripple = Instance.new("Frame")
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.Position = UDim2.new(0, input.Position.X - self.Button.AbsolutePosition.X, 0, input.Position.Y - self.Button.AbsolutePosition.Y)
		ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ripple.BackgroundTransparency = 0.7
		ripple.ZIndex = 6
		ripple.Parent = self.Button
		local rippleCorner = Instance.new("UICorner")
		rippleCorner.CornerRadius = UDim.new(1, 0)
		rippleCorner.Parent = ripple
		Utils.tweenMultiple(ripple, {Size = UDim2.new(0, 100, 0, 100), BackgroundTransparency = 1}, RIPPLE_DURATION, Enum.EasingStyle.Quad)
		task.spawn(function()
			task.wait(RIPPLE_DURATION)
			ripple:Destroy()
		end)
	end

	-- Hover and Click Animations
	Utils.addHoverEffect(self.Button, Designs.Themes.Dark.Secondary, Designs.Themes.Dark.Primary)
	self.Button.MouseButton1Click:Connect(function()
		createRipple({Position = UserInputService:GetMouseLocation()})
		window:SelectTab(self)
	end)

	-- Drag-and-Drop Tab Reordering
	local function updateTabOrder()
		local tabs = window.Tabs
		table.sort(tabs, function(a, b) return a.Order < b.Order end)
		for i, tab in ipairs(tabs) do
			tab.Button.LayoutOrder = i
		end
	end

	self.Button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.IsDragging = true
			self.DragStart = input.Position.Y
			self.OriginalOrder = self.Order
		end
	end)

	self.Button.InputChanged:Connect(function(input)
		if self.IsDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position.Y - self.DragStart
			local newOrder = math.clamp(math.floor(self.OriginalOrder + delta / TAB_HEIGHT), 1, #window.Tabs)
			if newOrder ~= self.Order then
				self.Order = newOrder
				updateTabOrder()
			end
		end
	end)

	self.Button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.IsDragging = false
		end
	end)

	-- Context Menu
	local contextMenu = Instance.new("Frame")
	contextMenu.Name = "ContextMenu"
	contextMenu.Size = UDim2.new(0, 150, 0, 80)
	contextMenu.BackgroundColor3 = Designs.Themes.Dark.Surface
	contextMenu.BackgroundTransparency = 0.1
	contextMenu.Visible = false
	contextMenu.ZIndex = 10
	contextMenu.Parent = self.Button

	local contextCorner = Instance.new("UICorner")
	contextCorner.CornerRadius = UDim.new(0, 6)
	contextCorner.Parent = contextMenu

	local function createContextOption(text, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -10, 0, 30)
		btn.Position = UDim2.new(0, 5, 0, (#contextMenu:GetChildren() - 1) * 35)
		btn.BackgroundColor3 = Designs.Themes.Dark.Secondary
		btn.Text = text
		btn.TextColor3 = Designs.Themes.Dark.Text
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.ZIndex = 11
		btn.Parent = contextMenu
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = btn
		Utils.addHoverEffect(btn, Designs.Themes.Dark.Secondary, Designs.Themes.Dark.Primary)
		btn.MouseButton1Click:Connect(function()
			callback()
			contextMenu.Visible = false
		end)
	end

	createContextOption("Close Tab", function()
		self:Destroy()
	end)
	createContextOption("Rename Tab", function()
		-- Placeholder for rename functionality
	end)

	self.Button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			contextMenu.Visible = true
			contextMenu.Position = UDim2.new(0, input.Position.X - self.Button.AbsolutePosition.X, 0, input.Position.Y - self.Button.AbsolutePosition.Y)
		end
	end)

	-- Content Container
	self.Container = Instance.new("ScrollingFrame")
	self.Container.Name = "TabContent_" .. name
	self.Container.Size = UDim2.new(1, 0, 1, 0)
	self.Container.Position = UDim2.new(0, 0, 0, 0)
	self.Container.BackgroundTransparency = 1
	self.Container.BorderSizePixel = 0
	self.Container.Visible = false
	self.Container.CanvasSize = UDim2.new(0, 0, 0, 0)
	self.Container.ScrollBarThickness = 4
	self.Container.ScrollBarImageColor3 = Designs.Themes.Dark.Secondary
	self.Container.Parent = window.Content

	local layout = Instance.new("UIGridLayout")
	layout.CellSize = UDim2.new(1, -10, 0, 40)
	layout.CellPadding = UDim2.new(0, 5, 0, 5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = self.Container

	-- Accessibility
	self.Button:GetPropertyChangedSignal("Active"):Connect(function()
		if self.Button.Active then
			Utils.tweenProperty(self.Button, "BackgroundTransparency", 0.3, 0.2)
		end
	end)

	return self
end

function Tab:SetActive(active)
	self.Container.Visible = active
	local targetColor = active and Designs.Themes.Dark.Primary or Designs.Themes.Dark.Secondary
	local targetTextColor = active and Color3.fromRGB(255, 255, 255) or Designs.Themes.Dark.TextSecondary
	Utils.tweenMultiple(self.Button, {BackgroundColor3 = targetColor, TextColor3 = targetTextColor}, ANIMATION_DURATION)
	if self.Icon then
		local icon = self.Button:FindFirstChild("Icon")
		if icon then
			Utils.tweenProperty(icon, "ImageColor3", targetTextColor, ANIMATION_DURATION)
		end
	end
end

function Tab:CreateLabel(text, config)
	local label = Elements.Label(self.Container, text, config)
	self.Container.CanvasSize = UDim2.new(0, 0, 0, self.Container.UIGridLayout.AbsoluteContentSize.Y)
	return label
end

function Tab:CreateButton(text, callback, config)
	local button = Elements.Button(self.Container, text, callback, config)
	self.Container.CanvasSize = UDim2.new(0, 0, 0, self.Container.UIGridLayout.AbsoluteContentSize.Y)
	return button
end

function Tab:CreateToggle(text, default, callback, config)
	local toggle = Elements.Toggle(self.Container, text, default, callback, config)
	self.Container.CanvasSize = UDim2.new(0, 0, 0, self.Container.UIGridLayout.AbsoluteContentSize.Y)
	return toggle
end

function Tab:Destroy()
	for i, tab in ipairs(self.Window.Tabs) do
		if tab == self then
			table.remove(self.Window.Tabs, i)
			break
		end
	end
	self.Button:Destroy()
	self.Container:Destroy()
	if self.Window.CurrentTab == self then
		self.Window.CurrentTab = nil
		if #self.Window.Tabs > 0 then
			self.Window:SelectTab(self.Window.Tabs[1])
		end
	end
end

return Tab
