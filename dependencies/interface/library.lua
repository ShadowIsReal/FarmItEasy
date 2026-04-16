local interface = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local coreGui = game:GetService("CoreGui")

-- ─────────────────────────────────────────────
-- PRIVATE
-- ─────────────────────────────────────────────

local FishingUI = {}
local labelFrames = {}
local labelCount = 0;

interface.CONFIG = {
	TitleColor = Color3.fromRGB(255, 85, 0),
	CardColor     = Color3.fromRGB(22, 22, 22),
	BorderColor   = Color3.fromRGB(255, 85, 0),
	TextColor     = Color3.fromRGB(255, 255, 255),
	DimTextColor  = Color3.fromRGB(180, 210, 255),
	FontTitle     = Enum.Font.GothamBold,
	LabelPadding  = 6,   -- px between labels
	CardPadding   = 18,  -- px inner padding
}

-- ─────────────────────────────────────────────
-- PUBLIC
-- ─────────────────────────────────────────────

function interface:createInterface(title : string)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "FarmItEasy_UI"
	ScreenGui.DisplayOrder = -1
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.Parent = coreGui

	local Card = Instance.new("Frame")
	Card.Name = "Card"
	Card.AnchorPoint = Vector2.new(0, 0)
	Card.Position = UDim2.fromScale(0, 0)
	Card.Size = UDim2.fromScale(1, 1)
	Card.BackgroundColor3 = self.CONFIG.CardColor
	Card.BorderSizePixel = 0
	Card.ZIndex = 3
	Card.ClipsDescendants = true
	Card.Parent = ScreenGui

	-- Inner padding
	local CardPadding = Instance.new("UIPadding")
	CardPadding.PaddingTop    = UDim.new(0, self.CONFIG.CardPadding)
	CardPadding.PaddingBottom = UDim.new(0, self.CONFIG.CardPadding)
	CardPadding.PaddingLeft   = UDim.new(0, self.CONFIG.CardPadding)
	CardPadding.PaddingRight  = UDim.new(0, self.CONFIG.CardPadding)
	CardPadding.Parent = Card

	local CardLayout = Instance.new("UIListLayout")
	CardLayout.FillDirection = Enum.FillDirection.Vertical
	CardLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	CardLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	CardLayout.SortOrder = Enum.SortOrder.LayoutOrder
	CardLayout.Padding = UDim.new(0, 0) -- labels control their own spacing
	CardLayout.Parent = Card
	
	local HeaderFrame = Instance.new("Frame")
	HeaderFrame.Name = "Header"
	HeaderFrame.Size = UDim2.new(1, 0, 0, 48)
	HeaderFrame.BackgroundTransparency = 1
	HeaderFrame.LayoutOrder = 0
	HeaderFrame.Parent = Card

	
	local flex = Instance.new("UIFlexItem")
	flex.FlexMode = Enum.UIFlexMode.None -- header stays fixed height
	flex.Parent = HeaderFrame

	local TopRow = Instance.new("Frame")
	TopRow.Size = UDim2.new(1, 0, 0.5, 0)
	TopRow.BackgroundTransparency = 1
	TopRow.Parent = HeaderFrame

	local TopLayout = Instance.new("UIListLayout")
	TopLayout.FillDirection = Enum.FillDirection.Horizontal
	TopLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	TopLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	TopLayout.Padding = UDim.new(0, 6)
	TopLayout.Parent = TopRow

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Font = self.CONFIG.FontTitle
	TitleLabel.TextColor3 = self.CONFIG.TitleColor
	TitleLabel.TextScaled = true
	TitleLabel.LayoutOrder = 1
	TitleLabel.Parent = TopRow
	TitleLabel.Text = title

	local LabelContainer = Instance.new("Frame")
	LabelContainer.Name = "LabelContainer"
	LabelContainer.Size = UDim2.new(1, 0, 0, 0)  -- height driven by flex
	LabelContainer.BackgroundTransparency = 1
	LabelContainer.LayoutOrder = 2
	LabelContainer.Parent = Card

	-- This UIFlexItem makes LabelContainer grow to fill leftover card space
	local ContainerFlex = Instance.new("UIFlexItem")
	ContainerFlex.FlexMode = Enum.UIFlexMode.Grow
	ContainerFlex.Parent = LabelContainer

	-- Inner layout for the individual labels
	local LabelLayout = Instance.new("UIListLayout")
	LabelLayout.FillDirection = Enum.FillDirection.Vertical
	LabelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	LabelLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	LabelLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LabelLayout.Padding = UDim.new(0, self.CONFIG.LabelPadding)
	LabelLayout.Parent = LabelContainer
	
	self.LabelContainer = LabelContainer
end


function interface:addLabel(id, text)
	local label = Instance.new("Frame")
	label.Name = "Label_" .. id
	label.Size = UDim2.new(1, 0, 0, 0) -- height auto via flex
	label.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	label.BorderSizePixel = 0
	label.LayoutOrder = labelCount
	label.ClipsDescendants = false
	label.Parent = self.LabelContainer

	local RowCorner = Instance.new("UICorner")
	RowCorner.CornerRadius = UDim.new(0, 10)
	RowCorner.Parent = label

	local RowStroke = Instance.new("UIStroke")
	RowStroke.Color = self.CONFIG.BorderColor
	RowStroke.Thickness = 1
	RowStroke.Transparency = 0.6
	RowStroke.Parent = label

	-- UIFlexItem: each label shares vertical space equally, shrinks/grows automatically
	local flex = Instance.new("UIFlexItem")
	flex.FlexMode = Enum.UIFlexMode.Fill    -- grow AND shrink to fill container
	flex.Parent = label

	local RowLayout = Instance.new("UIListLayout")
	RowLayout.FillDirection = Enum.FillDirection.Horizontal
	RowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	RowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	RowLayout.Padding = UDim.new(0, 8)
	RowLayout.Parent = label

	local RowPad = Instance.new("UIPadding")
	RowPad.PaddingLeft  = UDim.new(0, 10)
	RowPad.PaddingRight = UDim.new(0, 10)
	RowPad.Parent = label

	-- Text
	local TextLabel = Instance.new("TextLabel")
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = text
	TextLabel.Font = self.CONFIG.FontTitle
	TextLabel.TextColor3 = self.CONFIG.TextColor
	TextLabel.TextScaled = true
	TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel.LayoutOrder = 1
	TextLabel.Parent = label

	labelFrames[id] = TextLabel
end

--- Remove a specific label frame returned from AddLabel.
function interface:removeLabel(labelId: string)
	local label = labelFrames[labelId]

	if label then
		labelFrames[labelId] = nil;
		label:Destroy();
	end
end

-- Set the text for a specific label
function interface:setLabel(labelId : string, text : string)
	local label = labelFrames[labelId]

	if label then
		label.Text = text
	else
		warn(string.format("[FARMITEASY-INTERFACE]: Label %s does not exist!", labelId))
	end	
end

-- return library
return interface