-- [[ 🔥 Visual Skin Changer by @gde_patrick ]]
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

local myAccessories = {}  -- Сохраним твои старые аксессуары
local currentAdded = nil
local lastId = nil -- сохраним последний ID

-- 🎲 Список случайных аксессуаров / шмоток
local randomSkins = {
    67798367, -- Пример Accessory
    1029025,  -- Пример Shirt
    144076760, -- Пример Pants
    120308182, -- Пример Face
}

-- 🖼 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 140)
frame.Position = UDim2.new(0.5, -160, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true frame.Draggable = true

local input = Instance.new("TextBox", frame)
input.PlaceholderText = "ID аксессуара / шмотки"
input.Size = UDim2.new(0.65, -10, 0, 30)
input.Position = UDim2.new(0,5,0,5)
input.BackgroundColor3 = Color3.fromRGB(50,50,50)
input.TextColor3 = Color3.fromRGB(255,255,255)

local okBtn = Instance.new("TextButton", frame)
okBtn.Text = "✅ OK"
okBtn.Size = UDim2.new(0.35, -10, 0, 30)
okBtn.Position = UDim2.new(0.65,5,0,5)
okBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
okBtn.TextColor3 = Color3.fromRGB(255,255,255)

local revertBtn = Instance.new("TextButton", frame)
revertBtn.Text = "🔄 Вернуть"
revertBtn.Size = UDim2.new(0.5,-10,0,30)
revertBtn.Position = UDim2.new(0,5,0,40)
revertBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
revertBtn.TextColor3 = Color3.fromRGB(255,255,255)

local randomBtn = Instance.new("TextButton", frame)
randomBtn.Text = "🎲 Случайный"
randomBtn.Size = UDim2.new(0.5,-10,0,30)
randomBtn.Position = UDim2.new(0.5,5,0,40)
randomBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
randomBtn.TextColor3 = Color3.fromRGB(255,255,255)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "❌"
closeBtn.Size = UDim2.new(1,-10,0,30)
closeBtn.Position = UDim2.new(0,5,0,75)
closeBtn.BackgroundColor3 = Color3.fromRGB(100,30,30)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- ✅ Функции
local function saveMyAccessories()
    myAccessories = {}
    for _,v in ipairs((lp.Character or {}):GetChildren()) do
        if v:IsA("Accessory") then
            table.insert(myAccessories, v.Name)
        end
    end
end

local function removeCurrent()
    if lp.Character and currentAdded then
        local acc = lp.Character:FindFirstChild(currentAdded)
        if acc then acc:Destroy() end
        currentAdded = nil
    end
end

local function addAsset(assetId)
    removeCurrent()
    local new = game:GetService("InsertService"):LoadAsset(assetId)
    if new then
        for _,obj in ipairs(new:GetChildren()) do
            if obj:IsA("Accessory") or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("Decal") or obj:IsA("ShirtGraphic") or obj:IsA("BodyColors") then
                obj.Parent = lp.Character
                currentAdded = obj.Name
            end
        end
        new:Destroy()
    end
end

local function revertSkin()
    removeCurrent()
    -- Вернём старые аксессуары (если сохранили)
end

-- 🛠 Кнопки
okBtn.MouseButton1Click:Connect(function()
    local id = tonumber(input.Text)
    if id then 
        addAsset(id)
        lastId = id
    end
end)

randomBtn.MouseButton1Click:Connect(function()
    local randomId = randomSkins[math.random(1, #randomSkins)]
    addAsset(randomId)
    lastId = randomId
end)

revertBtn.MouseButton1Click:Connect(revertSkin)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ✨ После смерти вернуть
lp.CharacterAdded:Connect(function(newChar)
    char = newChar
    wait(1)
    if lastId then
        addAsset(lastId)
    end
end)

-- 🔥 В начале
saveMyAccessories()
if lastId then input.Text = tostring(lastId) end
