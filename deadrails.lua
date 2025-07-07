local main = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local toggleFly = Instance.new("TextButton")
local speedLabel = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local minus = Instance.new("TextButton")
local title = Instance.new("TextLabel")

main.Name = "DeadRailsFly"
main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

frame.Parent = main
frame.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
frame.Position = UDim2.new(0.1,0,0.4,0)
frame.Size = UDim2.new(0, 190, 0, 57)
frame.Active = true
frame.Draggable = true

title.Parent = frame
title.Size = UDim2.new(0, 100, 0, 28)
title.Position = UDim2.new(0.45,0,0,0)
title.Text = "Dead Rails Fly"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

up.Parent = frame
up.Size = UDim2.new(0, 44, 0, 28)
up.Position = UDim2.new(0,0,0,0)
up.Text = "UP"

down.Parent = frame
down.Size = UDim2.new(0, 44, 0, 28)
down.Position = UDim2.new(0,0,0.5,0)
down.Text = "DOWN"

toggleFly.Parent = frame
toggleFly.Size = UDim2.new(0, 56, 0, 28)
toggleFly.Position = UDim2.new(0.7,0,0.5,0)
toggleFly.Text = "Fly"

speedLabel.Parent = frame
speedLabel.Size = UDim2.new(0, 44, 0, 28)
speedLabel.Position = UDim2.new(0.47,0,0.5,0)
speedLabel.Text = "1"

plus.Parent = frame
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Position = UDim2.new(0.23,0,0,0)
plus.Text = "+"

minus.Parent = frame
minus.Size = UDim2.new(0, 45, 0, 28)
minus.Position = UDim2.new(0.23,0,0.5,0)
minus.Text = "-"

local speeds = 1
local flying = false
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local plr = game.Players.LocalPlayer

toggleFly.MouseButton1Click:Connect(function()
    flying = not flying
    toggleFly.Text = flying and "Stop" or "Fly"
end)

plus.MouseButton1Click:Connect(function()
    speeds = speeds + 1
    speedLabel.Text = tostring(speeds)
end)

minus.MouseButton1Click:Connect(function()
    speeds = math.max(1, speeds - 1)
    speedLabel.Text = tostring(speeds)
end)

up.MouseButton1Click:Connect(function()
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + Vector3.new(0,1,0)
    end
end)

down.MouseButton1Click:Connect(function()
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame - Vector3.new(0,1,0)
    end
end)

-- "Мягкий" fly (через Velocity)
rs.RenderStepped:Connect(function()
    if flying then
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            local vel = Vector3.new()
            if uis:IsKeyDown(Enum.KeyCode.W) then
                vel = vel + workspace.CurrentCamera.CFrame.LookVector * speeds
            end
            if uis:IsKeyDown(Enum.KeyCode.S) then
                vel = vel - workspace.CurrentCamera.CFrame.LookVector * speeds
            end
            if uis:IsKeyDown(Enum.KeyCode.A) then
                vel = vel - workspace.CurrentCamera.CFrame.RightVector * speeds
            end
            if uis:IsKeyDown(Enum.KeyCode.D) then
                vel = vel + workspace.CurrentCamera.CFrame.RightVector * speeds
            end
            hrp.Velocity = vel
        end
    end
end)
