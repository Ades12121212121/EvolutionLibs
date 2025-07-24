local Sidebar = {}

function Sidebar.new(window, theme)
	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, 180, 1, -40)
	sidebar.Position = UDim2.new(0, 0, 0, 40)
	sidebar.BackgroundColor3 = theme.Surface
	sidebar.BorderSizePixel = 0
	sidebar.ZIndex = 3
	sidebar.Parent = window.Main

	local tabList = Instance.new("ScrollingFrame")
	tabList.Name = "TabList"
	tabList.Size = UDim2.new(1, 0, 1, 0)
	tabList.Position = UDim2.new(0, 0, 0, 0)
	tabList.BackgroundTransparency = 1
	tabList.BorderSizePixel = 0
	tabList.ScrollBarThickness = 4
	tabList.ScrollBarImageColor3 = theme.Primary
	tabList.ZIndex = 4
	tabList.Parent = sidebar

	local listLayout = Instance.new("UIListLayout")
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = tabList

	local listPadding = Instance.new("UIPadding")
	listPadding.PaddingTop = UDim.new(0, 10)
	listPadding.PaddingBottom = UDim.new(0, 10)
	listPadding.PaddingLeft = UDim.new(0, 5)
	listPadding.PaddingRight = UDim.new(0, 5)
	listPadding.Parent = tabList

	return sidebar, tabList
end

return Sidebar 