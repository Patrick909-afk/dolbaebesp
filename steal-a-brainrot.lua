-- 🌈 GDE PATRICK HUB X | Key: FREE | by @gde_patrick
local plr = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local flingPower = 100
local flingEnabled = false
local savedBase = nil

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PatrickHub"

-- ВХОД ПО КЛЮЧУ
local keyFrame = Instance.new("Frame", sg)
keyFrame.Size = UDim2.new(0,250,0,100)
keyFrame.Position = UDim2.new(0.5,-125,0.5,-50)
keyFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
keyFrame.BackgroundTransparency = 0.2
keyFrame.Active = true
keyFrame.Draggable = true
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0,8)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.PlaceholderText = "Enter Key (hint: FREE)"
keyBox.Size = UDim2.new(1,-20,0,30)
keyBox.Position = UDim2.new(0,10,0,10)
keyBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0,6)

local contBtn = Instance.new("TextButton", keyFrame)
contBtn.Text = "Continue"
contBtn.Size = UDim2.new(1,-20,0,30)
contBtn.Position = UDim2.new(0,10,0,50)
contBtn.BackgroundColor3 = Color3.fromRGB(80,160,255)
contBtn.TextColor3 = Color3.fromRGB(255,255,255)
contBtn.Font = Enum.Font.GothamBold
contBtn.TextSize = 14
Instance.new("UICorner", contBtn).CornerRadius = UDim.new(0,6)

-- ГЛАВНОЕ МЕНЮ (скрыто до ввода ключа)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0,250,0,300)
frame.Position = UDim2.new(0.5,-125,0.5,-150)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.BackgroundTransparency = 0.2
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,8)

local title = Instance.new("TextLabel", frame)
title.Text = "🌈 GDE PATRICK HUB"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local flingBtn = Instance.new("TextButton", frame)
flingBtn.Text = "Fling: OFF"
flingBtn.Size = UDim2.new(1,-20,0,30)
flingBtn.Position = UDim2.new(0,10,0,40)
flingBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
Instance.new("UICorner", flingBtn).CornerRadius = UDim.new(0,6)

local powerBox = Instance.new("TextBox", frame)
powerBox.Text = tostring(flingPower)
powerBox.Size = UDim2.new(1,-20,0,30)
powerBox.Position = UDim2.new(0,10,0,80)
powerBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
powerBox.TextColor3 = Color3.fromRGB(255,255,255)
powerBox.Font = Enum.Font.Gotham
powerBox.TextSize = 14
powerBox.PlaceholderText = "Fling Power"

local saveBtn = Instance.new("TextButton", frame)
saveBtn.Text = "Save Base"
saveBtn.Size = UDim2.new(1,-20,0,30)
saveBtn.Position = UDim2.new(0,10,0,120)
saveBtn.BackgroundColor3 = Color3.fromRGB(100,255,100)
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0,6)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Text = "TP to Base"
tpBtn.Size = UDim2.new(1,-20,0,30)
tpBtn.Position = UDim2.new(0,10,0,160)
tpBtn.BackgroundColor3 = Color3.fromRGB(255,200,100)
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0,6)

local info = Instance.new("TextLabel", frame)
info.Text = "by @gde_patrick"
info.Size = UDim2.new(1,0,0,20)
info.Position = UDim2.new(0,0,1,-20)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.fromRGB(200,200,200)
info.Font = Enum.Font.Gotham
info.TextSize = 12

-- проверка ключа
contBtn.MouseButton1Click:Connect(function()
 if keyBox.Text == "FREE" then
   frame.Visible = true
   keyFrame.Visible = false
 end
end)

-- fling
flingBtn.MouseButton1Click:Connect(function()
 flingEnabled = not flingEnabled
 flingBtn.Text = "Fling: "..(flingEnabled and "ON" or "OFF")
end)

-- power
powerBox.FocusLost:Connect(function()
 local n = tonumber(powerBox.Text)
 if n then flingPower = n end
 powerBox.Text = tostring(flingPower)
end)

-- save
saveBtn.MouseButton1Click:Connect(function()
 if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
   savedBase = plr.Character.HumanoidRootPart.Position
 end
end)

-- tp
tpBtn.MouseButton1Click:Connect(function()
 if savedBase and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
  local hrp = plr.Character.HumanoidRootPart
  local dist = (savedBase - hrp.Position).Magnitude
  local steps = 50
  for i=1,steps do
   hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(savedBase), i/steps)
   wait(0.02)
  end
 end
end)

-- fling loop + anti ragdoll
spawn(function()
 while wait(0.1) do
   pcall(function()
    -- анти-флинг
    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
     plr.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
    end
    if flingEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
      for _,v in pairs(game.Players:GetPlayers()) do
       if v~=plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
        local dir = (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Unit
        v.Character.HumanoidRootPart.Velocity = dir * flingPower
       end
      end
    end
   end)
 end
end)
