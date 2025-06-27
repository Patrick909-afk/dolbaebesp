local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- GUI в углу экрана с анимацией
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PatrickTopLabel"
screenGui.Parent = game.CoreGui

local textLabel = Instance.new("TextLabel")
textLabel.Parent = screenGui
textLabel.Size = UDim2.new(0, 300, 0, 40)
textLabel.Position = UDim2.new(0.5, -150, 0, 10) -- центр сверху
textLabel.AnchorPoint = Vector2.new(0.5, 0)
textLabel.Text = "@gde_patrick"
textLabel.BackgroundTransparency = 1
textLabel.TextSize = 28
textLabel.Font = Enum.Font.GothamBold -- жирный
textLabel.TextStrokeTransparency = 0.3 -- контур чуть прозрачный

-- Анимация: текст двигается влево-вправо + радуга
local RunService = game:GetService("RunService")
local tickStart = tick()

RunService.RenderStepped:Connect(function()
    -- Движение
    local offset = math.sin((tick() - tickStart) * 2) * 100
    textLabel.Position = UDim2.new(0.5, offset, 0, 10)
    
    -- Радуга
    local hue = (tick() % 5) / 5
    local color = Color3.fromHSV(hue, 1, 1)
    textLabel.TextColor3 = color
    textLabel.TextStrokeColor3 = color
end)

-- Функция для переименования игроков в "ДОЛБАЁБ"
local function renamePlayer(plr)
    if plr ~= localPlayer then
        pcall(function()
            plr.DisplayName = "ДОЛБАЁБ"
            plr.Name = "ДОЛБАЁБ"
        end)
    end
end

-- Переименовать всех текущих игроков
for _, plr in pairs(Players:GetPlayers()) do
    renamePlayer(plr)
end

-- Когда заходит новый игрок
Players.PlayerAdded:Connect(renamePlayer)

-- Если Roblox возвращает старое имя, повторять каждый кадр
RunService.RenderStepped:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        renamePlayer(plr)
    end
end)
