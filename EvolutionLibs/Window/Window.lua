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
local MIN_SIDEBAR_WIDTH = 80
local MAX_SIDEBAR_WIDTH = 400

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
	self.Connections = {} -- Para almacenar conexiones

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
	-- Mejora la detección de resolución de pantalla
	local screenSize
	local success, result = pcall(function()
		return workspace.CurrentCamera.ViewportSize
	end)
	if success and result then
		screenSize = result
	else
		screenSize = Vector2.new(1366, 768) -- Resolución por defecto más común
	end
	self.Main.Size = getUtils().getResponsiveScale(screenSize, self.Config.Size or {600, 400})
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

	-- Función local para crear botones de control con manejo de errores
	local function createControlButton(name, text, color, callback)
		local utils = getUtils()
		if not utils then
			warn("[EvolutionLibs] No se pudo acceder a Utils para crear botón:", name)
			return nil
		end

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

		-- Manejo de errores para efectos visuales
		local success, _ = pcall(function()
			local hoverColor = utils.lerpColor(color, Color3.fromRGB(255, 255, 255), 0.3)
			utils.addHoverEffect(btn, color, hoverColor)
		end)

		if not success then
			warn("[EvolutionLibs] Error al aplicar efectos al botón:", name)
			-- Fallback simple para hover
			btn.MouseEnter:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(
					math.min(color.R * 255 + 30, 255),
					math.min(color.G * 255 + 30, 255),
					math.min(color.B * 255 + 30, 255)
				)
			end)
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = color
			end)
		end

		btn.MouseButton1Click:Connect(callback)
		return btn
	end

	-- Crear botones de control con verificación
	local closeBtn = createControlButton("CloseButton", "X", self.Theme.Error, function() self:Close() end)
	local minBtn = createControlButton("MinimizeButton", "−", self.Theme.Secondary, function() self:Minimize() end)
	local maxBtn = createControlButton("MaximizeButton", "⬜", self.Theme.Secondary, function() self:Maximize() end)

	if not (closeBtn and minBtn and maxBtn) then
		warn("[EvolutionLibs] Algunos botones de control no se pudieron crear")
	end

	-- Drag-and-Drop Mechanics
	local function updateDrag(input)
		if self.IsDragging then
			local delta = input.Position - self.DragStart
			local newPos = UDim2.new(
				0, self.DragOrigin.X.Offset + delta.X,
				0, self.DragOrigin.Y.Offset + delta.Y
			)
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
	local sidebarEnabled = (self.Config.sidebar ~= nil) and self.Config.sidebar or (not self.Config.NoSidebar)
	local sidebarWidth = self.Config.SidebarWidth or SIDEBAR_WIDTH
	self.SidebarWidth = sidebarWidth
	if sidebarEnabled then
		local success, sidebarResult = pcall(function()
			-- Crear contenedor del Sidebar
			local sidebarContainer = Instance.new("Frame")
			sidebarContainer.Name = "SidebarContainer"
			sidebarContainer.Size = UDim2.new(0, self.SidebarWidth, 1, -TITLEBAR_HEIGHT)
			sidebarContainer.Position = UDim2.new(0, 0, 0, TITLEBAR_HEIGHT)
			sidebarContainer.BackgroundColor3 = self.Theme.Surface
			sidebarContainer.BorderSizePixel = 0
			sidebarContainer.Parent = self.Main
			-- Lista de tabs
			self.SidebarTabList = Instance.new("ScrollingFrame")
			self.SidebarTabList.Name = "TabList"
			self.SidebarTabList.Size = UDim2.new(1, -10, 1, -20)
			self.SidebarTabList.Position = UDim2.new(0, 5, 0, 10)
			self.SidebarTabList.BackgroundTransparency = 1
			self.SidebarTabList.BorderSizePixel = 0
			self.SidebarTabList.ScrollBarThickness = 2
			self.SidebarTabList.ScrollBarImageColor3 = self.Theme.Secondary
			self.SidebarTabList.Parent = sidebarContainer
			-- Layout para los tabs
			local listLayout = Instance.new("UIListLayout")
			listLayout.Padding = UDim.new(0, 5)
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.Parent = self.SidebarTabList
			-- Padding para la lista
			local listPadding = Instance.new("UIPadding")
			listPadding.PaddingTop = UDim.new(0, 5)
			listPadding.PaddingBottom = UDim.new(0, 5)
			listPadding.Parent = self.SidebarTabList
			-- Ajustar tamaño del canvas automáticamente
			listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				self.SidebarTabList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
			end)
			return {
				Main = sidebarContainer,
				TabList = self.SidebarTabList,
				Destroy = function()
					sidebarContainer:Destroy()
				end
			}
		end)
		if success and sidebarResult then
			self.Sidebar = sidebarResult
		else
			warn("[EvolutionLibs] Error al crear Sidebar:", sidebarResult)
			-- Crea un Sidebar básico como fallback
			self.Sidebar = {
				Main = Instance.new("Frame"),
				TabList = Instance.new("ScrollingFrame"),
				Destroy = function() end
			}
			self.Sidebar.Main.Name = "SidebarFallback"
			self.Sidebar.Main.Size = UDim2.new(0, self.SidebarWidth, 1, -TITLEBAR_HEIGHT)
			self.Sidebar.Main.Position = UDim2.new(0, 0, 0, TITLEBAR_HEIGHT)
			self.Sidebar.Main.BackgroundColor3 = self.Theme.Surface
			self.Sidebar.Main.BorderSizePixel = 0
			self.Sidebar.Main.Parent = self.Main
			self.Sidebar.TabList.Name = "TabListFallback"
			self.Sidebar.TabList.Size = UDim2.new(1, -10, 1, -20)
			self.Sidebar.TabList.Position = UDim2.new(0, 5, 0, 10)
			self.Sidebar.TabList.BackgroundTransparency = 1
			self.Sidebar.TabList.BorderSizePixel = 0
			self.Sidebar.TabList.ScrollBarThickness = 2
			self.Sidebar.TabList.ScrollBarImageColor3 = self.Theme.Secondary
			self.Sidebar.TabList.Parent = self.Sidebar.Main
			local listLayout = Instance.new("UIListLayout")
			listLayout.Padding = UDim.new(0, 5)
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.Parent = self.Sidebar.TabList
		end
	else
		self.Sidebar = nil
	end

	-- Content Area
	self.Content = Instance.new("Frame")
	self.Content.Name = "Content"
	if not sidebarEnabled then
		self.Content.Size = UDim2.new(1, 0, 1, -TITLEBAR_HEIGHT)
		self.Content.Position = UDim2.new(0, 0, 0, TITLEBAR_HEIGHT)
	else
		self.Content.Size = UDim2.new(1, -self.SidebarWidth, 1, -TITLEBAR_HEIGHT)
		self.Content.Position = UDim2.new(0, self.SidebarWidth, 0, TITLEBAR_HEIGHT)
	end
	self.Content.BackgroundColor3 = self.Theme.Background
	self.Content.BackgroundTransparency = 0.1
	self.Content.BorderSizePixel = 0
	self.Content.ClipsDescendants = true
	self.Content.Parent = self.Main

	-- Agregar ScrollingFrame para el contenido
	local contentScroll = Instance.new("ScrollingFrame")
	contentScroll.Name = "ContentScroll"
	contentScroll.Size = UDim2.new(1, -20, 1, -20)
	contentScroll.Position = UDim2.new(0, 10, 0, 10)
	contentScroll.BackgroundTransparency = 1
	contentScroll.BorderSizePixel = 0
	contentScroll.ScrollBarThickness = 2
	contentScroll.ScrollBarImageColor3 = self.Theme.Secondary
	contentScroll.Parent = self.Content

	-- Layout para el contenido
	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Padding = UDim.new(0, 10)
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.Parent = contentScroll

	-- Padding para el contenido
	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingTop = UDim.new(0, 10)
	contentPadding.PaddingBottom = UDim.new(0, 10)
	contentPadding.Parent = contentScroll

	-- Ajustar tamaño del canvas automáticamente
	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		contentScroll.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
	end)

	-- Reemplazar self.Content con el ScrollingFrame
	self.Content = contentScroll

	-- Almacena las conexiones para limpiarlas después
	table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.F6 then
			self:ToggleFocus()
		end
	end))

	table.insert(self.Connections, self.Main:GetPropertyChangedSignal("Active"):Connect(function()
		self.IsFocused = self.Main.Active
		getUtils().tweenProperty(shadow, "ImageTransparency", self.IsFocused and 0.7 or 0.9, 0.3)
	end))

	-- Opening Animation
	self.Main.Size = UDim2.new(0, 0, 0, 0)
	getUtils().tweenProperty(self.Main, "Size", getUtils().getResponsiveScale(self.ScreenGui.AbsoluteSize, self.Config.Size or {600, 400}), ANIMATION_DURATION, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	getUtils().tweenProperty(self.Main, "BackgroundTransparency", 0, ANIMATION_DURATION, Enum.EasingStyle.Quad)

	return self
end

function Window:CreateTab(name, icon)
	local tab = getTab().new(self, name, icon)
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
	-- Desconecta todos los eventos antes de destruir
	for _, connection in ipairs(self.Connections) do
		if connection.Connected then
			connection:Disconnect()
		end
	end
	self.Connections = {}

	getUtils().tweenProperty(self.Main, "Size", UDim2.new(0, 0, 0, 0), ANIMATION_DURATION, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.wait(ANIMATION_DURATION)
	
	-- Limpia las referencias antes de destruir
	for _, tab in ipairs(self.Tabs) do
		if type(tab.Destroy) == "function" then
			tab:Destroy()
		end
	end
	self.Tabs = {}
	self.CurrentTab = nil
	
	if self.Sidebar and type(self.Sidebar.Destroy) == "function" then
		self.Sidebar:Destroy()
	end
	
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

function Window:UpdateTheme(themeName)
	local newTheme = getDesigns().Themes[themeName]
	if not newTheme then
		warn("[EvolutionLibs] Tema no encontrado:", themeName)
		return
	end

	self.Theme = newTheme
	
	-- Actualiza colores principales
	self.Main.BackgroundColor3 = self.Theme.Background
	self.TitleBar.BackgroundColor3 = self.Theme.Surface
	self.Content.BackgroundColor3 = self.Theme.Background
	
	-- Actualiza gradientes
	for _, child in ipairs(self.Main:GetDescendants()) do
		if child:IsA("UIGradient") then
			if child.Parent.Name == "TitleBar" then
				child.Color = getUtils().createGradient(self.Theme.Primary, self.Theme.Secondary, 45).Color
			elseif child.Parent.Name == "GlassLayer" then
				child.Color = getUtils().createGradient(self.Theme.Background, self.Theme.Secondary, 45).Color
			end
		end
	end
	
	-- Actualiza botones de control
	local controlButtons = self.TitleBar:FindFirstChild("ControlButtons")
	if controlButtons then
		for _, btn in ipairs(controlButtons:GetChildren()) do
			if btn:IsA("TextButton") then
				local color = btn.Name == "CloseButton" and self.Theme.Error or self.Theme.Secondary
				btn.BackgroundColor3 = color
				getUtils().addHoverEffect(btn, color, getUtils().lerpColor(color, Color3.fromRGB(255, 255, 255), 0.3))
			end
		end
	end
	
	-- Actualiza Sidebar si existe
	if self.Sidebar and type(self.Sidebar.UpdateTheme) == "function" then
		self.Sidebar:UpdateTheme(self.Theme)
	end
	
	-- Actualiza tabs activos
	for _, tab in ipairs(self.Tabs) do
		if type(tab.UpdateTheme) == "function" then
			tab:UpdateTheme(self.Theme)
		end
	end
end

return Window