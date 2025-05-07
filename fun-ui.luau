local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Char:WaitForChild("Humanoid")
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AriHubUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 260, 0, 300)
Frame.Position = UDim2.new(0.35, 0, 0.25, 0)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1,0,0,30)
TitleBar.BackgroundColor3 = Color3.fromRGB(15,15,15)
local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1,0,1,0)
Title.Text = "Ari Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.BackgroundTransparency = 1

local Close = Instance.new("TextButton", TitleBar)
Close.Text = "X"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.Size = UDim2.new(0,30,0,30)
Close.Position = UDim2.new(1,-30,0,0)
Close.BackgroundColor3 = Color3.fromRGB(100,0,0)
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,4)
Close.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    uiVisible = false
end)

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Text = "_"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Size = UDim2.new(0,30,0,30)
MinBtn.Position = UDim2.new(1,-60,0,0)
MinBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0,260,0,30)
    else
        MainFrame.Size = UDim2.new(0,260,0,300)
    end
end)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "AriHub"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Center

local ScrollingFrame = Instance.new("ScrollingFrame", Frame)
ScrollingFrame.Position = UDim2.new(0, 0, 0, 35)
ScrollingFrame.Size = UDim2.new(1, 0, 1, -35)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 1.5, 0)
ScrollingFrame.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout", ScrollingFrame)
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Padding = Instance.new("UIPadding", ScrollingFrame)
Padding.PaddingLeft = UDim.new(0, 10)
Padding.PaddingRight = UDim.new(0, 10)

local function createSlider(name, min, max, default, callback)
	local container = Instance.new("Frame", ScrollingFrame)
	container.Size = UDim2.new(1, -10, 0, 60)
	container.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", container)
	label.Text = name .. ": " .. tostring(default)
	label.Size = UDim2.new(1, 0, 0, 20)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left

	local slider = Instance.new("TextBox", container)
	slider.PlaceholderText = tostring(default)
	slider.Text = ""
	slider.Size = UDim2.new(1, 0, 0, 30)
	slider.Position = UDim2.new(0, 0, 0, 25)
	slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	slider.BorderSizePixel = 0
	slider.TextColor3 = Color3.fromRGB(0, 255, 170)
	slider.Font = Enum.Font.Gotham
	slider.TextSize = 14
	slider.ClearTextOnFocus = true

	local corner = Instance.new("UICorner", slider)
	corner.CornerRadius = UDim.new(0, 8)

	slider.FocusLost:Connect(function()
		local num = tonumber(slider.Text)
		if num then
			num = math.clamp(num, min, max)
			label.Text = name .. ": " .. tostring(num)
			callback(num)
		end
	end)
end

createSlider("WalkSpeed", 1, 500, 16, function(val)
	Humanoid.WalkSpeed = val
end)

createSlider("JumpPower", 1, 500, 50, function(val)
	Humanoid.JumpPower = val
end)

createSlider("HipHeight", 0, 100, Humanoid.HipHeight, function(val)
	Humanoid.HipHeight = val
end)

createSlider("Gravity", 0, 500, 196.2, function(val)
	workspace.Gravity = val
end)

createSlider("FOV", 1, 120, Camera.FieldOfView, function(val)
	Camera.FieldOfView = val
end)

local ResetBtn = Instance.new("TextButton", ScrollingFrame)
ResetBtn.Text = "Reset All"
ResetBtn.Size = UDim2.new(1, -10, 0, 30)
ResetBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ResetBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
ResetBtn.Font = Enum.Font.GothamBold
ResetBtn.TextSize = 14

local corner = Instance.new("UICorner", ResetBtn)
corner.CornerRadius = UDim.new(0, 8)

ResetBtn.MouseButton1Click:Connect(function()
	Humanoid.WalkSpeed = 16
	Humanoid.JumpPower = 50
	Humanoid.HipHeight = 2
	workspace.Gravity = 196.2
	Camera.FieldOfView = 70
end)
