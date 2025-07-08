local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local target = nil
local raidEnabled = false
local antiRagdoll = false
local hitbox = nil
local menuVisible = true

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RaidMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 340)
Frame.Position = UDim2.new(0.4, -110, 0.4, -170)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,8)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "⚔ Raid Menu"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)
Title.TextXAlignment = Enum.TextXAlignment.Left

local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1,-30,0,2)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(200,60,60)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,6)

local ToggleRaid = Instance.new("TextButton", Frame)
ToggleRaid.Size = UDim2.new(1, -20, 0, 30)
ToggleRaid.Position = UDim2.new(0,10,0,40)
ToggleRaid.Text = "Raid OFF"
ToggleRaid.BackgroundColor3 = Color3.fromRGB(200,80,80)
ToggleRaid.Font = Enum.Font.GothamBold
ToggleRaid.TextSize = 14
ToggleRaid.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ToggleRaid).CornerRadius = UDim.new(0,6)

local ToggleAnti = Instance.new("TextButton", Frame)
ToggleAnti.Size = UDim2.new(1, -20, 0, 30)
ToggleAnti.Position = UDim2.new(0,10,0,80)
ToggleAnti.Text = "Anti-Ragdoll OFF"
ToggleAnti.BackgroundColor3 = Color3.fromRGB(200,80,80)
ToggleAnti.Font = Enum.Font.GothamBold
ToggleAnti.TextSize = 14
ToggleAnti.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", ToggleAnti).CornerRadius = UDim.new(0,6)

local PlayerList = Instance.new("ScrollingFrame", Frame)
PlayerList.Size = UDim2.new(1, -20, 0, 200)
PlayerList.Position = UDim2.new(0,10,0,120)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.BackgroundColor3 = Color3.fromRGB(45,45,45)
PlayerList.ScrollBarThickness = 6
Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0,6)

-- Функция для создания большого хитбокса
local function createHitbox()
    if hitbox then hitbox:Destroy() end
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        hitbox = Instance.new("Part")
        hitbox.Size = Vector3.new(100,100,100) -- реально большой (можно изменить)
        hitbox.Transparency = 1
        hitbox.Anchored = true
        hitbox.CanCollide = false
        hitbox.Parent = workspace
        hitbox.Position = target.Character.HumanoidRootPart.Position
    end
end

-- Автокликер и обновление хитбокса
RunService.RenderStepped:Connect(function()
    if raidEnabled and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        if not hitbox or not hitbox.Parent then
            createHitbox()
        end
        hitbox.Position = target.Character.HumanoidRootPart.Position

        -- автокликер
        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end

    -- анти рагдолл
    if antiRagdoll and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") then
                v:Destroy()
            end
        end
    end
end)

-- Обновление списка игроков каждые 2 секунды
local function updateList()
    PlayerList:ClearAllChildren()
    local y = 0
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton", PlayerList)
            btn.Size = UDim2.new(1, -4, 0, 30)
            btn.Position = UDim2.new(0,2,0,y)
            btn.Text = plr.Name
            btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 14
            btn.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)

            btn.MouseButton1Click:Connect(function()
                target = plr
            end)

            y = y + 32
        end
    end
    PlayerList.CanvasSize = UDim2.new(0,0,0,y)
end

task.spawn(function()
    while true do
        updateList()
        task.wait(2)
    end
end)

-- Переключатели
ToggleRaid.MouseButton1Click:Connect(function()
    raidEnabled = not raidEnabled
    ToggleRaid.Text = raidEnabled and "Raid ON" or "Raid OFF"
    ToggleRaid.BackgroundColor3 = raidEnabled and Color3.fromRGB(80,200,80) or Color3.fromRGB(200,80,80)
    if not raidEnabled and hitbox then
        hitbox:Destroy()
        hitbox = nil
    end
end)

ToggleAnti.MouseButton1Click:Connect(function()
    antiRagdoll = not antiRagdoll
    ToggleAnti.Text = antiRagdoll and "Anti-Ragdoll ON" or "Anti-Ragdoll OFF"
    ToggleAnti.BackgroundColor3 = antiRagdoll and Color3.fromRGB(80,200,80) or Color3.fromRGB(200,80,80)
end)

-- Закрыть
Close.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
    menuVisible = false
end)

-- Hotkey (RightShift)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        ScreenGui.Enabled = menuVisible
    end
end)
