local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart")
local checkpointKeyword = "Check" -- Название чекпоинтов (можешь поменять, если другое)

local flightTime = 3 -- Время перелёта между чекпоинтами

-- Собираем все чекпоинты
local checkpoints = {}
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and string.find(obj.Name:lower(), checkpointKeyword:lower()) then
        table.insert(checkpoints, obj)
    end
end

-- Сортируем по Z (или другой логике, если нужно)
table.sort(checkpoints, function(a,b)
    return a.Position.Z < b.Position.Z
end)

print("✅ Найдено чекпоинтов: "..#checkpoints)

-- Определим, с какого начать (следующий за самым близким)
local function getStartIndex()
    local closest, closestDist = nil, math.huge
    for i, cp in ipairs(checkpoints) do
        local dist = (hrp.Position - cp.Position).Magnitude
        if dist < closestDist then
            closestDist = dist
            closest = i
        end
    end
    return math.min(closest+1, #checkpoints)
end

local startIndex = getStartIndex()
print("🚀 Начинаем с чекпоинта №"..startIndex)

-- Перелёт по очереди
for i = startIndex, #checkpoints do
    local cp = checkpoints[i]
    print("➡️ Летим к чекпоинту №"..i.." ("..cp.Name..")")

    local goal = {CFrame = cp.CFrame + Vector3.new(0, 3, 0)} -- чуть выше, чтобы не застрять
    local tweenInfo = TweenInfo.new(flightTime, Enum.EasingStyle.Linear)

    local tween = TweenService:Create(hrp, tweenInfo, goal)
    tween:Play()
    tween.Completed:Wait()

    task.wait(0.1) -- небольшая пауза между перелётами
end

print("✅ Долетели до последнего чекпоинта!")
