local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0, 200, 0, 40)
btn.Position = UDim2.new(0.5, -100, 0.9, -20)
btn.Text = "Patrick Stealth NoClip: OFF"
btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
btn.TextColor3 = Color3.new(0, 0, 0)
btn.BackgroundTransparency = 0.1

local stroke = Instance.new("UIStroke", btn)
stroke.Color = Color3.fromRGB(0, 255, 0)
stroke.Thickness = 2

local noclipEnabled = false

btn.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    btn.Text = "Patrick Stealth NoClip: " .. (noclipEnabled and "ON" or "OFF")
end)

runService.RenderStepped:Connect(function()
    if noclipEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        -- Лёгкое плавное "просачивание" через стены:
        local direction = player.Character.Humanoid.MoveDirection
        if direction.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + direction * 0.2  -- не резко, а очень плавно
        end
    end
end)
