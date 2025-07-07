local plr = game.Players.LocalPlayer
local speeds = 1
local flying = false

-- 🌟 UI
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "DeadRailsCheat"

local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 170)
frame.Position = UDim2.new(0.1, 0, 0.4, 0)
frame.Size = UDim2.new(0, 190, 0, 57)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Size = UDim2.new(1, 0, 0, 28)
title.Text = "🌌 DeadRails Cheat 🌌"
title.TextColor3 = Color3.fromRGB(0, 255, 170)
title.TextScaled = true
title.Font = Enum.Font.SourceSansBold

local up = Instance.new("TextButton", frame)
up.Text = "UP"
up.Size = UDim2.new(0, 44, 0, 28)
up.Position = UDim2.new(0, 0, 0, 28)
up.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local down = Instance.new("TextButton", frame)
down.Text = "DOWN"
down.Size = UDim2.new(0, 44, 0, 28)
down.Position = UDim2.new(0, 0, 0, 56)
down.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local plus = Instance.new("TextButton", frame)
plus.Text = "+"
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Position = UDim2.new(0.25, 0, 0, 28)
plus.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local minus = Instance.new("TextButton", frame)
minus.Text = "-"
minus.Size = UDim2.new(0, 45, 0, 28)
minus.Position = UDim2.new(0.25, 0, 0, 56)
minus.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local speedLabel = Instance.new("TextLabel", frame)
speedLabel.Text = tostring(speeds)
speedLabel.Size = UDim2.new(0, 44, 0, 28)
speedLabel.Position = UDim2.new(0.5, 0, 0, 28)
speedLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
speedLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
speedLabel.TextScaled = true

local toggle = Instance.new("TextButton", frame)
toggle.Text = "Fly"
toggle.Size = UDim2.new(0, 56, 0, 28)
toggle.Position = UDim2.new(0.65, 0, 0, 28)
toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(0.85, 0, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)

-- ✈️ Полёт
local cam = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

toggle.MouseButton1Click:Connect(function()
    flying = not flying
    toggle.Text = flying and "Stop" or "Fly"
end)

plus.MouseButton1Click:Connect(function()
    speeds += 1
    speedLabel.Text = tostring(speeds)
end)

minus.MouseButton1Click:Connect(function()
    speeds = math.max(1, speeds-1)
    speedLabel.Text = tostring(speeds)
end)

up.MouseButton1Click:Connect(function()
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame += Vector3.new(0,1,0) end
end)

down.MouseButton1Click:Connect(function()
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame -= Vector3.new(0,1,0) end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Плавный полёт
rs.RenderStepped:Connect(function()
    if flying then
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local move = Vector3.zero
            if uis:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if uis:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if uis:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            char.HumanoidRootPart.Velocity = move * speeds
        end
    end
end)

-- 🚂 Красивый ESP (маленький, неон)
local function addESP(part)
    local esp = Instance.new("BillboardGui", part)
    esp.Size = UDim2.new(0, 60, 0, 20)
    esp.AlwaysOnTop = true
    local label = Instance.new("TextLabel", esp)
    label.Size = UDim2.new(1,0,1,0)
    label.Text = "🚂"
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 170)
    label.TextScaled = true
end

for _,v in pairs(workspace:GetDescendants()) do
    if v:IsA("Model") and v.Name:lower():find("train") then
        local p = v:FindFirstChildWhichIsA("BasePart")
        if p then addESP(p) end
    end
end

workspace.DescendantAdded:Connect(function(v)
    if v:IsA("Model") and v.Name:lower():find("train") then
        local p = v:FindFirstChildWhichIsA("BasePart")
        if p then addESP(p) end
    end
end)
