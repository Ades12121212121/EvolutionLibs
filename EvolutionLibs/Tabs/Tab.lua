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

	local designs = getDesigns()
	local utils = getUtils()
	if not designs or not utils then
		error("[EvolutionLibs] No se pudieron cargar los módulos necesarios para Tab")
		return nil
	end

	-- Tab Button
	self.Button = Instance.new("TextButton")
	self.Button.Name = "TabButton_" .. name
	self.Button.Size = UDim2.new(1, -10, 0, TAB_HEIGHT)
	self.Button.BackgroundColor3 = designs.Themes.Dark.Secondary
	self.Button.BorderSizePixel = 0
	self.Button.Text = icon and (icon .. " " .. name) or name
	self.Button.TextColor3 = designs.Themes.Dark.TextSecondary
	self.Button.Font = Enum.Font.Gotham
	self.Button.TextSize = 14
	self.Button.TextXAlignment = Enum.TextXAlignment.Left
	self.Button.Parent = window.SidebarTabList

	-- Padding para el texto
	local textPadding = Instance.new("UIPadding")
	textPadding.PaddingLeft = icon and UDim.new(0, ICON_SIZE + 15) or UDim.new(0, 10)
	textPadding.Parent = self.Button

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
		iconLabel.ImageColor3 = designs.Themes.Dark.TextSecondary
		iconLabel.ZIndex = 6
		iconLabel.Parent = self.Button
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
		utils.tweenProperty(ripple, "Size", UDim2.new(0, 100, 0, 100), RIPPLE_DURATION)
		utils.tweenProperty(ripple, "BackgroundTransparency", 1, RIPPLE_DURATION)
		task.spawn(function()
			task.wait(RIPPLE_DURATION)
			ripple:Destroy()
		end)
	end

	-- Hover and Click Animations
	utils.addHoverEffect(self.Button, designs.Themes.Dark.Secondary, designs.Themes.Dark.Primary)
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
	contextMenu.BackgroundColor3 = designs.Themes.Dark.Surface
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
		btn.BackgroundColor3 = designs.Themes.Dark.Secondary
		btn.Text = text
		btn.TextColor3 = designs.Themes.Dark.Text
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 12
		btn.ZIndex = 11
		btn.Parent = contextMenu
		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 4)
		btnCorner.Parent = btn
		utils.addHoverEffect(btn, designs.Themes.Dark.Secondary, designs.Themes.Dark.Primary)
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
	self.Container.ScrollBarImageColor3 = designs.Themes.Dark.Secondary
	self.Container.Parent = window.Content

	local layout = Instance.new("UIGridLayout")
	layout.CellSize = UDim2.new(1, -10, 0, 40)
	layout.CellPadding = UDim2.new(0, 5, 0, 5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = self.Container

	-- Accessibility
	self.Button:GetPropertyChangedSignal("Active"):Connect(function()
		if self.Button.Active then
			utils.tweenProperty(self.Button, "BackgroundTransparency", 0.3, 0.2)
		end
	end)

	return self
end

function Tab:SetActive(active)
	local designs = getDesigns()
	local utils = getUtils()
	if not designs or not utils then
		warn("[EvolutionLibs] No se pudieron cargar los módulos necesarios para SetActive")
		return
	end

	self.Container.Visible = active
	local targetColor = active and designs.Themes.Dark.Primary or designs.Themes.Dark.Secondary
	local targetTextColor = active and Color3.fromRGB(255, 255, 255) or designs.Themes.Dark.TextSecondary

	utils.tweenProperty(self.Button, "BackgroundColor3", targetColor, ANIMATION_DURATION)
	utils.tweenProperty(self.Button, "TextColor3", targetTextColor, ANIMATION_DURATION)

	if self.Icon then
		local icon = self.Button:FindFirstChild("Icon")
		if icon then
			utils.tweenProperty(icon, "ImageColor3", targetTextColor, ANIMATION_DURATION)
		end
	end
end

function Tab:CreateLabel(text, config)
	local elements = getElements()
	if not elements then
		warn("[EvolutionLibs] No se pudo cargar el módulo Elements para CreateLabel")
		return nil
	end

	local label = elements.Label(self.Container, text, config)
	if label then
		self.Container.CanvasSize = UDim2.new(0, 0, 0, self.Container.UIGridLayout.AbsoluteContentSize.Y)
	end
	return label
end

function Tab:CreateButton(text, callback, config)
	local elements = getElements()
	if not elements then
		warn("[EvolutionLibs] No se pudo cargar el módulo Elements para CreateButton")
		return nil
	end

	local button = elements.Button(self.Container, text, callback, config)
	if button then
		self.Container.CanvasSize = UDim2.new(0, 0, 0, self.Container.UIGridLayout.AbsoluteContentSize.Y)
	end
	return button
end

function Tab:CreateToggle(text, default, callback, config)
	local elements = getElements()
	if not elements then
		warn("[EvolutionLibs] No se pudo cargar el módulo Elements para CreateToggle")
		return nil
	end

	local toggle = elements.Toggle(self.Container, text, default, callback, config)
	if toggle then
		self.Container.CanvasSize = UDim2.new(0, 0, 0, self.Container.UIGridLayout.AbsoluteContentSize.Y)
	end
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
