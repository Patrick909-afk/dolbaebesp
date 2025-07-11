-- [[ 🔥 Visual Skin Changer by @gde_patrick ]]
local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()

local myAccessories = {}  -- Сохраним твои старые аксессуары
local currentAdded = nil

-- 🖼 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0.5, -150, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true frame.Draggable = true

local input = Instance.new("TextBox", frame)
input.PlaceholderText = "ID скина или аксессуара"
input.Size = UDim2.new(0.6, -10, 0, 30)
input.Position = UDim2.new(0,5,0,5)
input.BackgroundColor3 = Color3.fromRGB(50,50,50)
input.TextColor3 = Color3.fromRGB(255,255,255)

local okBtn = Instance.new("TextButton", frame)
okBtn.Text = "✅ OK"
okBtn.Size = UDim2.new(0.4, -10, 0, 30)
okBtn.Position = UDim2.new(0.6,5,0,5)
okBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
okBtn.TextColor3 = Color3.fromRGB(255,255,255)

local revertBtn = Instance.new("TextButton", frame)
revertBtn.Text = "🔄 Вернуть"
revertBtn.Size = UDim2.new(0.5,-10,0,30)
revertBtn.Position = UDim2.new(0,5,0,40)
revertBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
revertBtn.TextColor3 = Color3.fromRGB(255,255,255)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "❌"
closeBtn.Size = UDim2.new(0.5,-10,0,30)
closeBtn.Position = UDim2.new(0.5,5,0,40)
closeBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)

-- ✅ Функции
local function saveMyAccessories()
	myAccessories = {}
	for _,v in ipairs((lp.Character or {}).:GetChildren()) do
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

local function addAccessory(assetId)
	removeCurrent()
	local new = game:GetService("InsertService"):LoadAsset(assetId)
	if new then
		for _,obj in ipairs(new:GetChildren()) do
			if obj:IsA("Accessory") then
				obj.Parent = lp.Character
				currentAdded = obj.Name
			end
		end
		new:Destroy()
	end
end

local function revertSkin()
	removeCurrent()
	-- Вернём старые аксессуары
	for _,name in ipairs(myAccessories) do
		local asset = game:GetService("InsertService"):LoadAsset(name)
		if asset then
			for _,obj in ipairs(asset:GetChildren()) do
				if obj:IsA("Accessory") then
					obj.Parent = lp.Character
				end
			end
			asset:Destroy()
		end
	end
end

-- 🛠 Кнопки
okBtn.MouseButton1Click:Connect(function()
	local id = tonumber(input.Text)
	if id then addAccessory(id) end
end)

revertBtn.MouseButton1Click:Connect(revertSkin)

closeBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- ✨ После смерти вернуть
lp.CharacterAdded:Connect(function(newChar)
	char = newChar
	wait(1)
	if currentAdded then
		addAccessory(currentAdded)
	end
end)

-- 🔥 В начале
saveMyAccessories()
