local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Чуть увеличим скорость и прыжок
Humanoid.WalkSpeed = 24  -- стандарт ~16
Humanoid.JumpPower = 80  -- стандарт ~50

-- Анти-фалл (каждый кадр ставим Velocity вверх)
RunService.RenderStepped:Connect(function()
    if Humanoid.FloorMaterial == Enum.Material.Air then
        Character.HumanoidRootPart.Velocity = Vector3.new(0,2,0)
    end
end)

-- Анти-стоп (отключаем платформстенд и т.д.)
Humanoid.PlatformStand = false
Humanoid.Seated:Connect(function(active)
    if active then Humanoid.Sit = false end
end)

-- Equip первого оружия
local function EquipTool()
    local backpack = LocalPlayer.Backpack
    local tool = backpack:FindFirstChildOfClass("Tool")
    if tool then
        tool.Parent = Character
    end
end

-- Спиннер (вращение)
spawn(function()
    while true do
        Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
        wait()
    end
end)

-- Bang бот: каждые 0.01 сек активируем tool
spawn(function()
    while true do
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
        wait(0.01)
    end
end)

-- Идти к ближайшему врагу
spawn(function()
    while true do
        EquipTool()
        local closest, dist = nil, 999
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Team ~= LocalPlayer.Team then
                local mag = (player.Character.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    closest = player
                    dist = mag
                end
            end
        end

        if closest and closest.Character then
            if dist > 10 then
                Humanoid.Jump = true -- прыжок, если далеко
            end
            -- Двигаемся к врагу (твиним)
            local targetPos = closest.Character.HumanoidRootPart.Position
            local tween = TweenService:Create(
                Character.HumanoidRootPart,
                TweenInfo.new(0.2),
                {CFrame = CFrame.new(targetPos)}
            )
            tween:Play()
        end
        wait(0.2)
    end
end)
