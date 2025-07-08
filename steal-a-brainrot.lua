local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local hrp = nil

local flingEnabled = true   -- сразу включено
local flingPower = 500      -- сила fling

-- ждем пока появится HumanoidRootPart
repeat task.wait() until lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
hrp = lp.Character:FindFirstChild("HumanoidRootPart")

while task.wait(0.2) do
    if flingEnabled and hrp and hrp.Parent then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= lp and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetHrp = player.Character.HumanoidRootPart
                local distance = (targetHrp.Position - hrp.Position).Magnitude
                if distance < 25 then  -- радиус
                    local bv = Instance.new("BodyVelocity")
                    bv.Velocity = Vector3.new(math.random(-1,1)*flingPower, flingPower, math.random(-1,1)*flingPower)
                    bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                    bv.Parent = targetHrp
                    game:GetService("Debris"):AddItem(bv, 0.2)
                end
            end
        end
    end
end
