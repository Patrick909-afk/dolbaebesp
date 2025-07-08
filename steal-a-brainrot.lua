local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local target = nil
local enabled = false
local hitbox = nil
local menuVisible = true

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RaidMenu"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 300)
Frame.Position = UDim2.new(0.4, -110, 0.4, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,8)

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(1, -30, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "⚔ Raid Base"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextColor3 = Color3.new(1,1,1)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0,10,0,0)

local Close = Instance.new("TextButton", Frame)
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1,-30,0,2)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(200,60,60)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 14
Close.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0,6)

local Toggle = Instance.new("TextButton", Frame)
Toggle.Size = UDim2.new(1, -20, 0, 30)
Toggle.Position = UDim2.new(0,10,0,40)
Toggle.Text = "Raid OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(200,80,80)
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 14
Toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,6)

local PlayerList = Instance.new("ScrollingFrame", Frame)
PlayerList.Size = UDim2.new(1, -20, 0, 200)
PlayerList.Position = UDim2.new(0,10,0,80)
PlayerList.CanvasSize = UDim2.new(0,0,0,0)
PlayerList.BackgroundColor3 = Color3.fromRGB(45,45,45)
PlayerList.ScrollBarThickness = 4
Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0,6)

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

-- Функция для создания огромного хитбокса
local function createHitbox()
    if hitbox then hitbox:Destroy() end
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        hitbox = Instance.new("Part")
        hitbox.Size = Vector3.new(500,500,500) -- огромный
        hitbox.Transparency = 1
        hitbox.Anchored = true
        hitbox.CanCollide = false
        hitbox.Parent = workspace
        hitbox.Position = target.Character.HumanoidRootPart.Position
    end
end

-- Автокликер с максимальной скоростью
RunService.RenderStepped:Connect(function()
    if enabled and target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        if not hitbox or not hitbox.Parent then
            createHitbox()
        end
        hitbox.Position = target.Character.HumanoidRootPart.Position

        local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end
end)

-- Переключатель
Toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    Toggle.Text = enabled and "Raid ON" or "Raid OFF"
    Toggle.BackgroundColor3 = enabled and Color3.fromRGB(80,200,80) or Color3.fromRGB(200,80,80)
    if not enabled and hitbox then
        hitbox:Destroy()
        hitbox = nil
    end
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
