local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UIS = game:GetService("UserInputService")

local flingPart = nil
local spinning = false

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "MiniFlingGUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0,8)

local Close = Instance.new("TextButton", Frame)
Close.Text = "X"
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(200,60,60)
Close.TextColor3 = Color3.new(1,1,1)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14

local flingBtn = Instance.new("TextButton", Frame)
flingBtn.Text = "FLING NEARBY"
flingBtn.Size = UDim2.new(0.9, 0, 0, 40)
flingBtn.Position = UDim2.new(0.05, 0, 0, 35)
flingBtn.BackgroundColor3 = Color3.fromRGB(60,120,60)
flingBtn.TextColor3 = Color3.new(1,1,1)
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 16

local stopBtn = Instance.new("TextButton", Frame)
stopBtn.Text = "STOP"
stopBtn.Size = UDim2.new(0.9, 0, 0, 30)
stopBtn.Position = UDim2.new(0.05, 0, 0, 80)
stopBtn.BackgroundColor3 = Color3.fromRGB(120,60,60)
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = 16

-- Close
Close.MouseButton1Click:Connect(function()
    spinning = false
    if flingPart then flingPart:Destroy() end
    ScreenGui:Destroy()
end)

-- Find nearest
local function getNearestPlayer()
    local nearest = nil
    local shortest = math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).magnitude
            if dist < shortest then
                shortest = dist
                nearest = plr
            end
        end
    end
    return nearest
end

-- Fling logic
local function startFling()
    local target = getNearestPlayer()
    if not target then warn("Нет игроков рядом!") return end

    if flingPart then flingPart:Destroy() end

    flingPart = Instance.new("Part")
    flingPart.Anchored = false
    flingPart.CanCollide = true
    flingPart.Size = Vector3.new(5,5,5)
    flingPart.Position = LocalPlayer.Character.HumanoidRootPart.Position
    flingPart.Parent = workspace

    local att0 = Instance.new("Attachment", LocalPlayer.Character.HumanoidRootPart)
    local att1 = Instance.new("Attachment", flingPart)

    local alignPos = Instance.new("AlignPosition", flingPart)
    alignPos.Attachment0 = att1
    alignPos.Attachment1 = att0
    alignPos.RigidityEnabled = false
    alignPos.MaxForce = 999999999
    alignPos.Responsiveness = 200

    local vel = Instance.new("BodyAngularVelocity", flingPart)
    vel.AngularVelocity = Vector3.new(0,50000,0)
    vel.MaxTorque = Vector3.new(0,math.huge,0)
    vel.P = math.huge

    spinning = true
end

flingBtn.MouseButton1Click:Connect(startFling)

stopBtn.MouseButton1Click:Connect(function()
    spinning = false
    if flingPart then flingPart:Destroy() end
end)
