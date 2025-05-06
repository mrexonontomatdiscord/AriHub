local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local closeButton = Instance.new("TextButton")

screenGui.Parent = player:WaitForChild("PlayerGui")

frame.Size = UDim2.new(0.3, 0, 0.2, 0)
frame.Position = UDim2.new(0.35, 0, 0.4, 0) 
frame.BackgroundColor3 = Color3.fromRGB(255, 182, 193) 
frame.BorderSizePixel = 0
frame.Parent = screenGui

closeButton.Size = UDim2.new(0.15, 0, 0.2, 0)
closeButton.Position = UDim2.new(0.85, 0, 0, 0) 
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0) 
closeButton.Text = "✖"
closeButton.TextScaled = true
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy() 
end)
