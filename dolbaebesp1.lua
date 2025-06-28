-- SirenHead Mode v1 by @gde_patrick
-- Твоя голова — настоящий Siren Head из Roblox Catalog

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

-- Очищаем аксессуары и MeshParts
for _,v in pairs(char:GetChildren()) do
    if v:IsA("Accessory") or v:IsA("Hat") or v:IsA("MeshPart") then
        v:Destroy()
    end
end

-- Ждём Head
local head = char:WaitForChild("Head")

-- Добавляем SirenHead Mesh
local mesh = Instance.new("SpecialMesh", head)
mesh.MeshType = Enum.MeshType.FileMesh
mesh.MeshId = "rbxassetid://10215890386"  -- Siren Head модель 4
mesh.TextureId = ""
mesh.Scale = Vector3.new(4, 4, 4)
mesh.Offset = Vector3.new(0, 0, 0)

-- Анимация вращения головы (легкий эффект)
spawn(function()
    while head and head.Parent do
        head.Orientation = head.Orientation + Vector3.new(0, 1, 0)
        wait(0.05)
    end
end)

-- Радужный Billboard с Авторством
local bill = Instance.new("BillboardGui", head)
bill.Size = UDim2.new(0,200,0,50)
bill.StudsOffset = Vector3.new(0,2.5,0)
bill.AlwaysOnTop = true

local label = Instance.new("TextLabel", bill)
label.Size = UDim2.new(1,0,1,0)
label.BackgroundTransparency = 1
label.TextScaled = true
label.Font = Enum.Font.GothamBold
label.Text = "@gde_patrick"

-- Анимация цвета текста
spawn(function()
    while label.Parent do
        for i = 0,1,0.01 do
            label.TextColor3 = Color3.fromHSV(i,1,1)
            wait(0.02)
        end
    end
end)

print("✅ SirenHead Mode enabled for you! — @gde_patrick")
