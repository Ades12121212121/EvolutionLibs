-- Window.lua - Core window management for EvolutionLibs GUI
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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
local function getSidebar()
    if not _G.EvoLibsCache.Sidebar then _G.EvoLibsCache.Sidebar = loadstring(game:HttpGet(BASE_URL .. "Sidebar/Sidebar.lua"))() end
    return _G.EvoLibsCache.Sidebar
end
local function getToast()
    if not _G.EvoLibsCache.Toast then _G.EvoLibsCache.Toast = loadstring(game:HttpGet(BASE_URL .. "Toast/Toast.lua"))() end
    return _G.EvoLibsCache.Toast
end
local function getTab()
    if not _G.EvoLibsCache.Tab then _G.EvoLibsCache.Tab = loadstring(game:HttpGet(BASE_URL .. "Tabs/Tab.lua"))() end
    return _G.EvoLibsCache.Tab
end
local function getElements()
    if not _G.EvoLibsCache.Elements then _G.EvoLibsCache.Elements = loadstring(game:HttpGet(BASE_URL .. "Elements/Elements.lua"))() end
    return _G.EvoLibsCache.Elements
end

local Window = {}
Window.__index = Window

-- Constants
local MIN_WINDOW_SIZE = {400, 300}
local MAX_WINDOW_SIZE = {1200, 800}
local ANIMATION_DURATION = 0.5
local SHADOW_OFFSET = 10
local TITLEBAR_HEIGHT = 40
local SIDEBAR_WIDTH = 180

-- Constructor
function Window.new(config)
	local self = setmetatable({}, Window)
	self.Config = config or {}
	self.Theme = getDesigns().Themes[self.Config.Theme or "Dark"] or getDesigns().Themes.Dark
	self.Tabs = {}
	self.CurrentTab = nil
	self.SidebarCollapsed = false
	self.IsDragging = false
	self.IsResizing = false
	self.IsMinimized = false
	self.LastPosition = nil
	self.LastSize = nil
	self.IsFocused = true

	-- Initialize ScreenGui
	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "EvolutionLibs_Window"
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.IgnoreGuiInset = true
	self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	-- Main Frame
	self.Main = Instance.new("Frame")
	self.Main.Name = "Main"
	self.Main.Size = getUtils().getResponsiveScale(Players.LocalPlayer.PlayerGui:GetTopbarInset(), self.Config.Size or {600, 400})
	self.Main.Position = UDim2.new(0.5, -(self.Main.Size.X.Offset/2), 0.5, -(self.Main.Size.Y.Offset/2))
	self.Main.BackgroundColor3 = self.Theme.Background
	self.Main.BackgroundTransparency = 0.05
	self.Main.BorderSizePixel = 0
	self.Main.ClipsDescendants = true
	self.Main.Parent = self.ScreenGui

	-- Corner rounding
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 12)
	mainCorner.Parent = self.Main

	-- Simulated shadow
	local shadow = Instance.new("ImageLabel")
	shadow.Name = "Shadow"
	shadow.Size = UDim2.new(1, SHADOW_OFFSET * 2, 1, SHADOW_OFFSET * 2)
	shadow.Position = UDim2.new(0, -SHADOW_OFFSET, 0, -SHADOW_OFFSET)
	shadow.BackgroundTransparency = 1
	shadow.Image = "rbxassetid://1316045217"
	shadow.ImageTransparency = 0.7
	shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	shadow.ScaleType = Enum.ScaleType.Slice
	shadow.SliceCenter = Rect.new(10, 10, 118, 118)
	shadow.ZIndex = -1
	shadow.Parent = self.Main

	-- Glassmorphism background
	local glassLayer = Instance.new("Frame")
	glassLayer.Name = "GlassLayer"
	glassLayer.Size = UDim2.new(1, 0, 1, 0)
	glassLayer.BackgroundColor3 = self.Theme.Background
	glassLayer.BackgroundTransparency = 0.8
	glassLayer.ZIndex = 0
	glassLayer.Parent = self.Main
	local glassGradient = getUtils().createGradient(self.Theme.Background, self.Theme.Secondary, 45)
	glassGradient.Parent = glassLayer

	-- TitleBar
	self.TitleBar = Instance.new("Frame")
	self.TitleBar.Name = "TitleBar"
	self.TitleBar.Size = UDim2.new(1, 0, 0, TITLEBAR_HEIGHT)
	self.TitleBar.BackgroundColor3 = self.Theme.Surface
	self.TitleBar.BorderSizePixel = 0
	self.TitleBar.ZIndex = 10
	self.TitleBar.Parent = self.Main

	local titleGradient = getUtils().createGradient(self.Theme.Primary, self.Theme.Secondary, 45)
	titleGradient.Parent = self.TitleBar

	-- Title Label
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.Size = UDim2.new(1, -120, 1, 0)
	titleLabel.Position = UDim2.new(0, 15, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = self.Config.Title or "Evolution Window"
	titleLabel.TextColor3 = self.Theme.Text
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.Parent = self.TitleBar

	-- Control Buttons (Close, Minimize, Maximize)
	local buttonContainer = Instance.new("Frame")
	buttonContainer.Name = "ControlButtons"
	buttonContainer.Size = UDim2.new(0, 100, 0, 30)
	buttonContainer.Position = UDim2.new(1, -105, 0.5, -15)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = self.TitleBar

	local function createControlButton(name, text, color, callback)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0, 30, 0, 30)
		btn.Position = UDim2.new(0, (#buttonContainer:GetChildren() - 1) * 35, 0, 0)
		btn.BackgroundColor3 = color
		btn.BorderSizePixel = 0
		btn.Text = text
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 14
		btn.ZIndex = 11
		btn.Parent = buttonContainer
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = btn
		getUtils().addHoverEffect(btn, color, getUtils().lerpColor(color, Color3.fromRGB(255, 255, 255), 0.3))
		btn.MouseButton1Click:Connect(callback)
		return btn
	end

	createControlButton("CloseButton", "✕", self.Theme.Error, function() self:Close() end)
	createControlButton("MinimizeButton", "−", self.Theme.Secondary, function() self:Minimize() end)
	createControlButton("MaximizeButton", "⬜", self.Theme.Secondary, function() self:Maximize() end)

	-- Drag-and-Drop Mechanics
	local function updateDrag(input)
		if self.IsDragging then
			local delta = input.Position - self.DragStart
			local newPos = UDim2.new(0, self.DragOrigin.X + delta.X, 0, self.DragOrigin.Y + delta.Y)
			self.Main.Position = getUtils().clampPosition(newPos, self.ScreenGui.AbsoluteSize)
		end
	end

	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.IsDragging = true
			self.DragStart = input.Position
			self.DragOrigin = self.Main.Position
		end
	end)

	self.TitleBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.IsDragging = false
		end
	end)

	self.TitleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			updateDrag(input)
		end
	end)

	-- Resize Handle
	local resizeHandle = Instance.new("Frame")
	resizeHandle.Name = "ResizeHandle"
	resizeHandle.Size = UDim2.new(0, 10, 0, 10)
	resizeHandle.Position = UDim2.new(1, -10, 1, -10)
	resizeHandle.BackgroundColor3 = self.Theme.Primary
	resizeHandle.ZIndex = 10
	resizeHandle.Parent = self.Main
	local resizeCorner = Instance.new("UICorner")
	resizeCorner.CornerRadius = UDim.new(0, 4)
	resizeCorner.Parent = resizeHandle

	resizeHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.IsResizing = true
			self.ResizeStart = input.Position
			self.ResizeOrigin = self.Main.Size
		end
	end)

	resizeHandle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			self.IsResizing = false
		end
	end)

	resizeHandle.InputChanged:Connect(function(input)
		if self.IsResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - self.ResizeStart
			local newSize = UDim2.new(0, math.clamp(self.ResizeOrigin.X.Offset + delta.X, MIN_WINDOW_SIZE[1], MAX_WINDOW_SIZE[1]), 0, math.clamp(self.ResizeOrigin.Y.Offset + delta.Y, MIN_WINDOW_SIZE[2], MAX_WINDOW_SIZE[2]))
			self.Main.Size = newSize
		end
	end)

	-- Sidebar
	self.Sidebar, self.SidebarTabList = getSidebar().new(self, self.Theme)

	-- Content Area
	self.Content = Instance.new("Frame")
	self.Content.Name = "Content"
	self.Content.Size = UDim2.new(1, -SIDEBAR_WIDTH, 1, -TITLEBAR_HEIGHT)
	self.Content.Position = UDim2.new(0, SIDEBAR_WIDTH, 0, TITLEBAR_HEIGHT)
	self.Content.BackgroundColor3 = self.Theme.Background
	self.Content.BackgroundTransparency = 0.1
	self.Content.BorderSizePixel = 0
	self.Content.ClipsDescendants = true
	self.Content.Parent = self.Main

	-- Accessibility Support
	UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.F6 then
			self:ToggleFocus()
		end
	end)

	-- Opening Animation
	self.Main.Size = UDim2.new(0, 0, 0, 0)
	getUtils().tweenProperty(self.Main, "Size", getUtils().getResponsiveScale(self.ScreenGui.AbsoluteSize, self.Config.Size or {600, 400}), ANIMATION_DURATION, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	getUtils().tweenProperty(self.Main, "BackgroundTransparency", 0, ANIMATION_DURATION, Enum.EasingStyle.Quad)

	-- Focus Highlight
	self.Main:GetPropertyChangedSignal("Active"):Connect(function()
		self.IsFocused = self.Main.Active
		getUtils().tweenProperty(shadow, "ImageTransparency", self.IsFocused and 0.7 or 0.9, 0.3)
	end)

	return self
end

function Window:CreateTab(name, icon)
	local tab = Tab.new(self, name, icon)
	table.insert(self.Tabs, tab)
	if #self.Tabs == 1 then
		self:SelectTab(tab)
	end
	return tab
end

function Window:SelectTab(tab)
	if self.CurrentTab then
		self.CurrentTab:SetActive(false)
	end
	self.CurrentTab = tab
	tab:SetActive(true)
	getUtils().tweenProperty(self.Content, "BackgroundTransparency", 0.1, 0.3)
end

function Window:Show()
	self.ScreenGui.Enabled = true
	getUtils().tweenProperty(self.Main, "BackgroundTransparency", 0, ANIMATION_DURATION, Enum.EasingStyle.Quad)
end

function Window:Hide()
	getUtils().tweenProperty(self.Main, "BackgroundTransparency", 1, ANIMATION_DURATION, Enum.EasingStyle.Quad)
	task.wait(ANIMATION_DURATION)
	self.ScreenGui.Enabled = false
end

function Window:Close()
	getUtils().tweenProperty(self.Main, "Size", UDim2.new(0, 0, 0, 0), ANIMATION_DURATION, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.wait(ANIMATION_DURATION)
	self.ScreenGui:Destroy()
end

function Window:Minimize()
	if not self.IsMinimized then
		self.LastPosition = self.Main.Position
		self.LastSize = self.Main.Size
		getUtils().tweenProperty(self.Main, "Size", UDim2.new(0, 200, 0, TITLEBAR_HEIGHT), 0.3, Enum.EasingStyle.Quad)
		getUtils().tweenProperty(self.Main, "Position", UDim2.new(0, 10, 1, -TITLEBAR_HEIGHT - 10), 0.3, Enum.EasingStyle.Quad)
		self.IsMinimized = true
	end
end

function Window:Maximize()
	if self.IsMinimized then
		getUtils().tweenProperty(self.Main, "Size", self.LastSize or UDim2.new(0, 600, 0, 400), 0.3, Enum.EasingStyle.Quad)
		getUtils().tweenProperty(self.Main, "Position", self.LastPosition or UDim2.new(0.5, -300, 0.5, -200), 0.3, Enum.EasingStyle.Quad)
		self.IsMinimized = false
	end
end

function Window:ToggleFocus()
	self.IsFocused = not self.IsFocused
	self.Main.Active = self.IsFocused
end

return Window
