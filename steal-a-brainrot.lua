local player = game.Players.LocalPlayer
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local checkpoints = {}

-- Найти все чекпоинты по названию (содержат слово "Check")
for _, obj in ipairs(workspace:GetDescendants()) do
    if obj:IsA("BasePart") and string.find(obj.Name:lower(), "check") then
        table.insert(checkpoints, obj)
    end
end

-- Отсортировать их по координатам (по оси Z например), чтобы идти по порядку
table.sort(checkpoints, function(a,b)
    return a.Position.Z < b.Position.Z
end)

local visited = {}

for _, cp in ipairs(checkpoints) do
    if not visited[cp] then
        if hrp and player.Character and player.Character.Parent then
            hrp.CFrame = cp.CFrame + Vector3.new(0, 5, 0) -- чуть выше, чтобы не застрять
            visited[cp] = true
            print("Телепорт к чекпоинту: "..cp.Name)
            task.wait(0.2) -- задержка между телепортами
        end
    end
end

print("✅ Все чекпоинты пройдены!")
