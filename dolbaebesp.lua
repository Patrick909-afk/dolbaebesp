local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- === Авторство сверху экрана ===
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local textLabel = Instance.new("TextLabel", screenGui)
textLabel.Size = UDim2.new(0, 300, 0, 50)
textLabel.Position = UDim2.new(0.35, 0, 0, 10)
textLabel.Text = "@gde_patrick"
textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
textLabel.TextScaled = true
textLabel.BackgroundTransparency = 1
textLabel.Font = Enum.Font.SourceSansBold

-- Радужная анимация текста
spawn(function()
    while true do
        for hue = 0, 1, 0.01 do
            textLabel.TextColor3 = Color3.fromHSV(hue, 1, 1)
            wait(0.05)
        end
    end
end)

-- === Замена ников игроков на "ДОЛБАЁБ" ===
local function changeNames()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            player.DisplayName = "ДОЛБАЁБ"
        end
    end
end

changeNames()

-- Обновлять, если кто-то заходит
Players.PlayerAdded:Connect(function(player)
    wait(0.5)
    player.DisplayName = "ДОЛБАЁБ"
end)

-- Если кто-то изменит ник
Players.PlayerRemoving:Connect(changeNames)
