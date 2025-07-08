local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart")
local checkpointKeyword = "Check" -- слово в названии чекпоинта (измени, если нужно)
local flightTime = 3 -- время полёта к следующему чекпоинту
local skipDistance = 20 -- если ближе этого расстояния, чекпоинт пропускается

-- собираем все чекпоинты
local checkpoints = {}
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and string.find(obj.Name:lower(), checkpointKeyword:lower()) then
        table.insert(checkpoints, obj)
    end
end

-- сортируем, например, по Z (можно поменять под карту)
table.sort(checkpoints, function(a,b)
    return a.Position.Z < b.Position.Z
end)

print("✅ Найдено чекпоинтов: "..#checkpoints)

-- идём по всем чекпоинтам и летим только к тем, которые не пройдены
for i, cp in ipairs(checkpoints) do
    if (hrp.Position - cp.Position).Magnitude > skipDistance then
        print("➡️ Летим к чекпоинту №"..i.." ("..cp.Name..")")
        local goal = {CFrame = cp.CFrame + Vector3.new(0, 3, 0)} -- чуть выше, чтобы не застрять
        local tweenInfo = TweenInfo.new(flightTime, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, goal)
        tween:Play()
        tween.Completed:Wait()
        task.wait(0.1)
    else
        print("⏭ Пропущен чекпоинт №"..i.." ("..cp.Name..")")
    end
end

print("✅ Готово! Долетели до конца!")
