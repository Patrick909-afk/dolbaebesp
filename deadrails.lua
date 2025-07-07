local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

-- GUI
local gui = Instance.new("ScreenGui", plr.PlayerGui)
gui.Name = "PatrickMenu"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.05, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.Active = true
frame.Draggable = true

local killAuraBtn = Instance.new("TextButton", frame)
killAuraBtn.Size = UDim2.new(1, 0, 0, 30)
killAuraBtn.Text = "Kill Aura (Mobs only)"

local noClipBtn = Instance.new("TextButton", frame)
noClipBtn.Position = UDim2.new(0,0,0,35)
noClipBtn.Size = UDim2.new(1,0,0,30)
noClipBtn.Text = "Toggle NoClip"

-- ✅ Kill Aura
killAuraBtn.MouseButton1Click:Connect(function()
    local mobsKilled = 0
    for _, model in pairs(workspace:GetDescendants()) do
        local hum = model:FindFirstChildWhichIsA("Humanoid")
        if hum and hum.Health > 0 then
            local isPlayer = game.Players:GetPlayerFromCharacter(model)
            if not isPlayer then
                hum.Health = 0
                mobsKilled = mobsKilled + 1
            end
        end
    end
    print("Killed "..mobsKilled.." mobs")
end)

-- ✅ NoClip
local noclip = false
noClipBtn.MouseButton1Click:Connect(function()
    noclip = not noclip
end)

game:GetService("RunService").Stepped:Connect(function()
    if noclip and plr.Character then
        for _, part in pairs(plr.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ✅ ESP поездов
local function createESP(part)
    local billboard = Instance.new("BillboardGui", part)
    billboard.Size = UDim2.new(0,50,0,20)
    billboard.Adornee = part
    billboard.AlwaysOnTop = true
    local label = Instance.new("TextLabel", billboard)
    label.Text = "🚂"
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0,255,0)
    label.TextScaled = true
end

for _, obj in pairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and (string.find(obj.Name:lower(), "train") or string.find(obj.Parent.Name:lower(), "train")) then
        createESP(obj)
    end
end

workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart") and (string.find(obj.Name:lower(), "train") or string.find(obj.Parent.Name:lower(), "train")) then
        createESP(obj)
    end
end)
