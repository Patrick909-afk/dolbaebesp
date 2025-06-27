local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

-- Функция для создания радужного цвета
local function rainbowColor(tick)
    local frequency = 2
    return Color3.fromHSV((tick * frequency) % 1, 1, 1)
end

-- Авторство в углу экрана
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DolbaebESP_UI"
screenGui.Parent = game.CoreGui

local authorText = Instance.new("TextLabel")
authorText.Size = UDim2.new(0, 300, 0, 30)
authorText.Position = UDim2.new(0, 10, 0, 10)
authorText.BackgroundTransparency = 1
authorText.Font = Enum.Font.GothamBold
authorText.TextSize = 20
authorText.Text = "@gde_patrick"
authorText.TextColor3 = Color3.fromRGB(255, 0, 0)
authorText.Parent = screenGui

-- FPS-счётчик
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(0, 100, 0, 20)
fpsLabel.Position = UDim2.new(0, 10, 0, 40)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.Gotham
fpsLabel.TextSize = 16
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.Text = "FPS: 0"
fpsLabel.Parent = screenGui

-- Функция для обновления DisplayName визуально
local function replaceNames()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local character = player.Character
            if character and character:FindFirstChild("Head") then
                local head = character.Head
                local existingBillboard = head:FindFirstChild("DolbaebName")
                if not existingBillboard then
                    local billboard = Instance.new("BillboardGui")
                    billboard.Name = "DolbaebName"
                    billboard.Adornee = head
                    billboard.Size = UDim2.new(0, 100, 0, 20)
                    billboard.StudsOffset = Vector3.new(0, 2, 0)
                    billboard.AlwaysOnTop = true

                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "Обезьяна"
                    label.Font = Enum.Font.GothamBold
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    label.TextStrokeTransparency = 0
                    label.TextScaled = true
                    label.Parent = billboard

                    billboard.Parent = head
                end
            end
        end
    end
end

-- Основной цикл
local lastUpdate = tick()
local fpsCounter = 0

RunService.RenderStepped:Connect(function()
    -- Радужный цвет авторства
    authorText.TextColor3 = rainbowColor(tick())

    -- Обновление FPS
    fpsCounter = fpsCounter + 1
    if tick() - lastUpdate >= 1 then
        fpsLabel.Text = "FPS: " .. tostring(fpsCounter)
        fpsCounter = 0
        lastUpdate = tick()
    end

    -- Обновление ников
    replaceNames()
end)
