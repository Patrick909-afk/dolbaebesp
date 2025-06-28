local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Проверяем, есть ли уже радио
if character:FindFirstChild("GoldenRadio") then
    character.GoldenRadio:Destroy()
end

-- Загружаем модель радио из Roblox Catalog (золотой бумбокс)
local boombox = Instance.new("Tool")
boombox.Name = "GoldenRadio"
boombox.RequiresHandle = true

local handle = Instance.new("Part")
handle.Name = "Handle"
handle.Size = Vector3.new(1, 1, 1)
handle.CanCollide = false
handle.Parent = boombox

-- Вставляем Mesh, чтобы выглядело как золотое радио
local mesh = Instance.new("SpecialMesh", handle)
mesh.MeshId = "rbxassetid://13212230"  -- это Mesh золотого бумбокса
mesh.TextureId = "rbxassetid://13212227" -- текстура

-- Выдаем себе инструмент (радио)
boombox.Parent = player.Backpack

-- Если хочешь сразу взять его в руки:
boombox.Parent = character

-- Добавляем звук (можешь указать ID своей любимой музыки)
local sound = Instance.new("Sound", handle)
sound.SoundId = "rbxassetid://1843529277"  -- замени на любой трек
sound.Volume = 3
sound.Looped = true
sound:Play()
