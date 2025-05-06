local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UIS           = game:GetService("UserInputService")

local LocalPlayer   = Players.LocalPlayer
local Mouse         = LocalPlayer:GetMouse()

local aimbotOn, useFOV, boxESPOn, nameESPOn = true, true, true, true
local smoothness, fovRadius = 0.15, 100
local uiVisible, minimized = true, false

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "AriUI"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 300)
MainFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,8)

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
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,4)
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0,260,0,30)
    else
        MainFrame.Size = UDim2.new(0,260,0,300)
    end
end)

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode==Enum.KeyCode.K then
        MainFrame.Visible = true
        uiVisible = true
    end
end)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1,0,1,-30)
Content.Position = UDim2.new(0,0,0,30)
Content.BackgroundTransparency = 1

local function makeToggle(txt,y,def,cb)
    local btn = Instance.new("TextButton", Content)
    btn.Text = txt..": "..(def and "ON" or "OFF")
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    btn.Size = UDim2.new(1,-10,0,30)
    btn.Position = UDim2.new(0,5,0,y)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
    local state = def
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = txt..": "..(state and "ON" or "OFF")
        cb(state)
    end)
    return btn
end

makeToggle("Aimbot",   10, true,  function(v) aimbotOn=v end)
makeToggle("Use FOV",  50, true,  function(v) useFOV=v end)
makeToggle("Box ESP",  90, true,  function(v) boxESPOn=v  end)
makeToggle("Name ESP", 130, true,  function(v) nameESPOn=v end)

local function makeSlider(label,y,initial,rangeMax,updateCb)
    local lbl = Instance.new("TextLabel", Content)
    lbl.Text = label
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1,-10,0,20)
    lbl.Position = UDim2.new(0,5,0,y)

    local bar = Instance.new("Frame", Content)
    bar.Size = UDim2.new(1,-20,0,8)
    bar.Position = UDim2.new(0,10,0,y+20)
    bar.BackgroundColor3 = Color3.fromRGB(60,60,60)
    Instance.new("UICorner", bar).CornerRadius=UDim.new(0,4)

    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new(initial/rangeMax,0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(0,200,120)
    Instance.new("UICorner", fill).CornerRadius=UDim.new(0,4)

    bar.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            local conn
            conn = RunService.RenderStepped:Connect(function()
                local rel=(Mouse.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X
                rel=math.clamp(rel,0,1)
                fill.Size=UDim2.new(rel,0,1,0)
                updateCb(rel*rangeMax)
            end)
            bar.InputEnded:Wait()
            conn:Disconnect()
        end
    end)
end

makeSlider("Smoothness", 170, smoothness, 1, function(v) smoothness=v end)
makeSlider("FOV",        225, fovRadius, 500, function(v) fovRadius=v end)

local fovCircle = Drawing.new("Circle")
fovCircle.Radius = fovRadius
fovCircle.Thickness = 1
fovCircle.Visible = useFOV
fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
fovCircle.Transparency = 1

local boxes, names = {}, {}

local function makeESP(player)
    local box = Drawing.new("Square")
    box.Visible = false; box.Thickness=1; box.Color=Color3.new(1,0,0); box.Filled=false
    local txt = Drawing.new("Text")
    txt.Visible=false; txt.Center=true; txt.Size=16; txt.Color=Color3.new(1,1,1)
    names[player] = txt
    boxes[player] = box
end

local function removeESP(player)
    if boxes[player] then boxes[player]:Remove() end
    if names[player] then names[player]:Remove() end
    boxes[player], names[player] = nil, nil
end

for _,p in pairs(Players:GetPlayers()) do if p~=LocalPlayer then makeESP(p) end end
Players.PlayerAdded:Connect(function(p) makeESP(p) end)
Players.PlayerRemoving:Connect(function(p) removeESP(p) end)

local function getClosest()
    local best,bd= nil,math.huge
    for p,box in pairs(boxes) do
        if p.Character and p.Character:FindFirstChild("Head") then
            local pos,on=workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
            local m=(Vector2.new(pos.X,pos.Y)-Vector2.new(Mouse.X,Mouse.Y)).Magnitude
            if on and m<bd and (not useFOV or m<fovRadius) then best,bd=p,m end
        end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    fovCircle.Radius = fovRadius
    fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    fovCircle.Visible = useFOV

    if aimbotOn then
        local tgt = getClosest()
        if tgt and tgt.Character and tgt.Character:FindFirstChild("Head") then
            local cam=workspace.CurrentCamera
            cam.CFrame = cam.CFrame:Lerp(
                CFrame.new(cam.CFrame.Position, tgt.Character.Head.Position),
                smoothness
            )
        end
    end

    for p,box in pairs(boxes) do
        local txt = names[p]
        if p.Character and p.Character:FindFirstChild("Head") then
            local root=p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
            if root then
                local top3D = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                local bot3D = workspace.CurrentCamera:WorldToViewportPoint(root.Position - Vector3.new(0,1,0))
                if top3D and bot3D then
                    local ht = math.abs(top3D.Y - bot3D.Y)
                    local wd = ht/2
                    box.Size = Vector2.new(wd, ht)
                    box.Position = Vector2.new(top3D.X - wd/2, top3D.Y)
                    box.Visible = boxESPOn
                    txt.Position = Vector2.new(top3D.X, top3D.Y - 15)
                    txt.Text = p.Name
                    txt.Visible = nameESPOn
                else
                    box.Visible, txt.Visible = false, false
                end
            end
        else
            box.Visible, txt.Visible = false, false
        end
    end
end)

