local player = game.Players.LocalPlayer
local hrp = player.Character and player.Character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")

local checkpoints = {}

-- Сюда запиши слово из названия чекпоинтов, например "Checkpoint", "Stage" или "CP"
local checkpointKeyword = "Check"

-- Ищем все подходящие объекты
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and string.find(obj.Name:lower(), checkpointKeyword:lower()) then
        table.insert(checkpoints, obj)
    end
end

-- Сортируем по Z (или по номеру в названии, если они есть)
table.sort(checkpoints, function(a,b)
    return a.Position.Z < b.Position.Z
end)

print("✅ Найдено чекпоинтов: "..#checkpoints)

-- Найти, на каком мы сейчас чекпоинте (ближайший)
local startIndex = 1
local closestDist = math.huge
for i, cp in ipairs(checkpoints) do
    local dist = (hrp.Position - cp.Position).Magnitude
    if dist < closestDist then
        closestDist = dist
        startIndex = i
    end
end

-- Начать с следующего
local currentIndex = math.min(startIndex + 1, #checkpoints)

-- Функция плавного перемещения
local function moveTo(target)
    local goal = {}
    goal.CFrame = target.CFrame + Vector3.new(0, 5, 0) -- чуть выше

    local tween = TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Linear), goal)
    tween:Play()
    tween.Completed:Wait()
end

-- Идём дальше по чекпоинтам
for i = currentIndex, #checkpoints do
    local cp = checkpoints[i]
    if cp and hrp and player.Character and player.Character.Parent then
        print("➡ Перемещаюсь к "..cp.Name)
        moveTo(cp)
        task.wait(0.2) -- задержка между
    end
end

print("🎉 Все чекпоинты пройдены!")
