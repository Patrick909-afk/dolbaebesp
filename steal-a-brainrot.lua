local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local hrp = lp.Character:WaitForChild("HumanoidRootPart")

local flingEnabled = false

-- Кнопка для вкл/выкл
button.MouseButton1Click:Connect(function()
    flingEnabled = not flingEnabled
end)

while task.wait(0.2) do
    if flingEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (player.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < 20 then  -- радиус в 20 студий
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(0, 500, 0)  -- сильно вверх
                    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
                    bv.Parent = player.Character.HumanoidRootPart
                    game:GetService("Debris"):AddItem(bv, 0.2) -- удалим через 0.2 сек
                end
            end
        end
    end
end
