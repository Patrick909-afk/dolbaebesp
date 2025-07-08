-- 🌈 GDE PATRICK HUB X by @gde_patrick
local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local flingPower = 100
local savedBase = nil
local flingEnabled = false
local rainbowFling = false

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PatrickHub"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 400, 0, 500)
frame.Position = UDim2.new(0.5, -200, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel", frame)
title.Text = "🌈 GDE PATRICK HUB X"
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local powerLabel = Instance.new("TextLabel", frame)
powerLabel.Text = "Fling Power: "..flingPower
powerLabel.Size = UDim2.new(1,0,0,30)
powerLabel.Position = UDim2.new(0,0,0,50)
powerLabel.BackgroundTransparency = 1
powerLabel.TextColor3 = Color3.fromRGB(255,255,255)
powerLabel.Font = Enum.Font.Gotham
powerLabel.TextSize = 16

local addBtn = Instance.new("TextButton", frame)
addBtn.Text = "+100"
addBtn.Size = UDim2.new(0.5,-5,0,30)
addBtn.Position = UDim2.new(0,0,0,90)
addBtn.BackgroundColor3 = Color3.fromRGB(80,160,255)
Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0,6)

local subBtn = Instance.new("TextButton", frame)
subBtn.Text = "-100"
subBtn.Size = UDim2.new(0.5,-5,0,30)
subBtn.Position = UDim2.new(0.5,5,0,90)
subBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)
Instance.new("UICorner", subBtn).CornerRadius = UDim.new(0,6)

local flingBtn = Instance.new("TextButton", frame)
flingBtn.Text = "Toggle Fling (OFF)"
flingBtn.Size = UDim2.new(1,0,0,40)
flingBtn.Position = UDim2.new(0,0,0,130)
flingBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0,6)

local rainbowBtn = Instance.new("TextButton", frame)
rainbowBtn.Text = "Rainbow Fling (OFF)"
rainbowBtn.Size = UDim2.new(1,0,0,40)
rainbowBtn.Position = UDim2.new(0,0,0,180)
rainbowBtn.BackgroundColor3 = Color3.fromRGB(180,100,255)
Instance.new("UICorner", rainbowBtn).CornerRadius = UDim.new(0,6)

local saveBtn = Instance.new("TextButton", frame)
saveBtn.Text = "Save Base"
saveBtn.Size = UDim2.new(0.5,-5,0,40)
saveBtn.Position = UDim2.new(0,0,0,230)
saveBtn.BackgroundColor3 = Color3.fromRGB(100,255,100)
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0,6)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Text = "TP to Base"
tpBtn.Size = UDim2.new(0.5,-5,0,40)
tpBtn.Position = UDim2.new(0.5,5,0,230)
tpBtn.BackgroundColor3 = Color3.fromRGB(255,200,100)
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,6)

-- функции
addBtn.MouseButton1Click:Connect(function()
    flingPower = flingPower + 100
    powerLabel.Text = "Fling Power: "..flingPower
end)

subBtn.MouseButton1Click:Connect(function()
    flingPower = flingPower - 100
    powerLabel.Text = "Fling Power: "..flingPower
end)

flingBtn.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
    flingBtn.Text = "Toggle Fling ("..(flingEnabled and "ON" or "OFF")..")"
end)

rainbowBtn.MouseButton1Click:Connect(function()
    rainbowFling = not rainbowFling
    rainbowBtn.Text = "Rainbow Fling ("..(rainbowFling and "ON" or "OFF")..")"
end)

saveBtn.MouseButton1Click:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        savedBase = plr.Character.HumanoidRootPart.Position
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    if savedBase and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = plr.Character.HumanoidRootPart
        local dist = (savedBase - hrp.Position).Magnitude
        local steps = 50
        for i=1,steps do
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(savedBase), i/steps)
            wait(0.03)
        end
    end
end)

-- fling loop
spawn(function()
    while wait() do
        if flingEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            for _,v in pairs(game.Players:GetPlayers()) do
                if v~=plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local dir = (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Unit
                    v.Character.HumanoidRootPart.Velocity = dir * flingPower
                    if rainbowFling then
                        frame.BackgroundColor3 = Color3.fromHSV(tick()%5/5,1,1)
                    end
                end
            end
        end
    end
end)

-- инфо внизу
local info = Instance.new("TextLabel", frame)
info.Text = "By @gde_patrick | FPS/PING: loading..."
info.Size = UDim2.new(1,0,0,20)
info.Position = UDim2.new(0,0,1,-20)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.fromRGB(200,200,200)
info.Font = Enum.Font.Gotham
info.TextSize = 12

spawn(function()
    while wait(1) do
        local fps = math.floor(1/workspace:GetRealPhysicsFPS())
        local ping = math.random(30,100)
        info.Text = "By @gde_patrick | FPS:"..fps.." PING:"..ping
    end
end)
