local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- === GUI для авторства и FPS ===
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "PatrickESP_GUI"

-- Радужный текст @gde_patrick
local authorLabel = Instance.new("TextLabel", screenGui)
authorLabel.Size = UDim2.new(0, 300, 0, 40)
authorLabel.Position = UDim2.new(0, 10, 0, 10)
authorLabel.Text = "@gde_patrick"
authorLabel.TextScaled = true
authorLabel.BackgroundTransparency = 1
authorLabel.Font = Enum.Font.SourceSansBold
authorLabel.TextColor3 = Color3.fromRGB(255,0,0)

-- FPS-счётчик
local fpsLabel = Instance.new("TextLabel", screenGui)
fpsLabel.Size = UDim2.new(0, 100, 0, 20)
fpsLabel.Position = UDim2.new(0, 10, 0, 60)
fpsLabel.Text = "FPS: ..."
fpsLabel.TextScaled = true
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextColor3 = Color3.fromRGB(0,255,0)

-- === Радужная анимация текста ===
spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            authorLabel.TextColor3 = Color3.fromHSV(hue,1,1)
            wait(0.05)
        end
    end
end)

-- === FPS обновление ===
spawn(function()
    local lastUpdate = tick()
    local frames = 0
    while true do
        frames = frames + 1
        local now = tick()
        if now - lastUpdate >= 1 then
            fpsLabel.Text = "FPS: "..frames
            frames = 0
            lastUpdate = now
        end
        RunService.RenderStepped:Wait()
    end
end)

-- === Замена ников игроков на "ДОЛБАЁБ" ===
local function changeName(player)
    pcall(function()
        player.DisplayName = "ДОЛБАЁБ"
        -- Некоторые режимы используют HeadBillboard или надписи, поэтому пробуем и Name
        player.Name = "ДОЛБАЁБ"
    end)
end

local function updateAllNames()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            changeName(player)
        end
    end
end

updateAllNames()

-- Обновление при новом игроке
Players.PlayerAdded:Connect(function(player)
    wait(0.2)
    changeName(player)
end)

-- Периодическая проверка (на случай, если сервер сбросит DisplayName)
spawn(function()
    while true do
        updateAllNames()
        wait(5)
    end
end)
