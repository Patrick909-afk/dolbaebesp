-- 🌟 Skin Changer by @gde_patrick

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()
local originalShirt, originalPants

-- 🖼 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
local fr = Instance.new("Frame", gui)
fr.Size = UDim2.new(0, 250, 0, 120)
fr.Position = UDim2.new(0.5, -125, 0.5, -60)
fr.BackgroundColor3 = Color3.fromRGB(30,30,30)
fr.Active = true
fr.Draggable = true

local txt = Instance.new("TextBox", fr)
txt.PlaceholderText = "Введи ID скина"
txt.Size = UDim2.new(1,-10,0,30)
txt.Position = UDim2.new(0,5,0,5)
txt.BackgroundColor3 = Color3.fromRGB(50,50,50)
txt.TextColor3 = Color3.fromRGB(255,255,255)

local ok = Instance.new("TextButton", fr)
ok.Text = "✅ OK"
ok.Size = UDim2.new(0.5,-7,0,30)
ok.Position = UDim2.new(0,5,0,40)
ok.BackgroundColor3 = Color3.fromRGB(50,50,50)
ok.TextColor3 = Color3.fromRGB(255,255,255)

local revert = Instance.new("TextButton", fr)
revert.Text = "🔙 Вернуть"
revert.Size = UDim2.new(0.5,-7,0,30)
revert.Position = UDim2.new(0.5+0.02,0,0,40)
revert.BackgroundColor3 = Color3.fromRGB(50,50,50)
revert.TextColor3 = Color3.fromRGB(255,255,255)

local close = Instance.new("TextButton", fr)
close.Text = "❌"
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.BackgroundColor3 = Color3.fromRGB(80,30,30)
close.TextColor3 = Color3.fromRGB(255,255,255)

-- 💡 Логика
ok.MouseButton1Click:Connect(function()
    local id = txt.Text
    if id and id ~= "" then
        chr = lp.Character or lp.CharacterAdded:Wait()
        if not originalShirt or not originalPants then
            originalShirt = chr:FindFirstChildOfClass("Shirt") and chr:FindFirstChildOfClass("Shirt").ShirtTemplate
            originalPants = chr:FindFirstChildOfClass("Pants") and chr:FindFirstChildOfClass("Pants").PantsTemplate
        end

        if chr:FindFirstChildOfClass("Shirt") then
            chr:FindFirstChildOfClass("Shirt").ShirtTemplate = "rbxassetid://"..id
        end
        if chr:FindFirstChildOfClass("Pants") then
            chr:FindFirstChildOfClass("Pants").PantsTemplate = "rbxassetid://"..id
        end
    end
end)

revert.MouseButton1Click:Connect(function()
    chr = lp.Character or lp.CharacterAdded:Wait()
    if originalShirt and chr:FindFirstChildOfClass("Shirt") then
        chr:FindFirstChildOfClass("Shirt").ShirtTemplate = originalShirt
    end
    if originalPants and chr:FindFirstChildOfClass("Pants") then
        chr:FindFirstChildOfClass("Pants").PantsTemplate = originalPants
    end
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- 🪄 Готово!
