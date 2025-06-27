-- // PatrickVisual v1 // @gde_patrick //

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Текст в углу экрана
local Billboard = Instance.new("BillboardGui", LocalPlayer:WaitForChild("PlayerGui"))
Billboard.Name = "PatrickLabel"
Billboard.Size = UDim2.new(0, 300, 0, 50)
Billboard.StudsOffset = Vector3.new(0, 10, 0)
Billboard.AlwaysOnTop = true
Billboard.Adornee = nil

local Label = Instance.new("TextLabel", Billboard)
Label.Text = "@gde_patrick"
Label.Size = UDim2.new(1, 0, 1, 0)
Label.TextScaled = true
Label.BackgroundTransparency = 1
Label.TextColor3 = Color3.new(1, 0, 0) -- Красный
Label.Font = Enum.Font.SourceSansBold

-- ДОЛБАЁБ ESP
function tagPlayer(character)
	pcall(function()
		local head = character:FindFirstChild("Head") or character:FindFirstChildWhichIsA("BasePart")
		if head and not head:FindFirstChild("PatrickESP") then
			local esp = Instance.new("BillboardGui", head)
			esp.Name = "PatrickESP"
			esp.Size = UDim2.new(0, 100, 0, 20)
			esp.Adornee = head
			esp.AlwaysOnTop = true

			local label = Instance.new("TextLabel", esp)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = "ДОЛБАЁБ"
			label.TextColor3 = Color3.new(1, 1, 1)
			label.TextStrokeTransparency = 0
			label.TextScaled = true
			label.Font = Enum.Font.GothamBlack
		end
	end)
end

-- На всех существующих
for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer and player.Character then
		tagPlayer(player.Character)
	end
end

-- Новые игроки
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		wait(1)
		tagPlayer(char)
	end)
end)

-- Обновление каждый кадр (на всякий)
RunService.RenderStepped:Connect(function()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr.Character then
			tagPlayer(plr.Character)
		end
	end
end)

-- NPC / зомби
while true do
	for _, npc in pairs(workspace:GetDescendants()) do
		if npc:IsA("Model") and not Players:GetPlayerFromCharacter(npc) then
			tagPlayer(npc)
		end
	end
	wait(2)
end
