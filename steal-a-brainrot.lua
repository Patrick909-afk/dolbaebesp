-- 🌈 GDE PATRICK HUB X | Key: FREE | by @gde_patrick
local plr = game.Players.LocalPlayer
local flingPower = 300
local flingEnabled = false
local savedBase = nil

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PatrickHub"

-- Вход
local keyFrame = Instance.new("Frame", sg)
keyFrame.Size = UDim2.new(0,200,0,90)
keyFrame.Position = UDim2.new(0.5,-100,0.5,-45)
keyFrame.BackgroundColor3 = Color3.fromRGB(30,30,40)
keyFrame.BackgroundTransparency = 0.2
keyFrame.Active = true
keyFrame.Draggable = true
Instance.new("UICorner", keyFrame)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.PlaceholderText = "Enter Key (FREE)"
keyBox.Size = UDim2.new(1,-20,0,25)
keyBox.Position = UDim2.new(0,10,0,10)
keyBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
Instance.new("UICorner", keyBox)

local contBtn = Instance.new("TextButton", keyFrame)
contBtn.Text = "Continue"
contBtn.Size = UDim2.new(1,-20,0,25)
contBtn.Position = UDim2.new(0,10,0,50)
contBtn.BackgroundColor3 = Color3.fromRGB(80,160,255)
contBtn.TextColor3 = Color3.fromRGB(255,255,255)
contBtn.Font = Enum.Font.GothamBold
contBtn.TextSize = 14
Instance.new("UICorner", contBtn)

-- Главное меню
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0,200,0,200)
frame.Position = UDim2.new(0.5,-100,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.BackgroundTransparency = 0.2
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Text = "GDE PATRICK HUB"
title.Size = UDim2.new(1,-30,0,25)
title.Position = UDim2.new(0,5,0,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,25,0,25)
closeBtn.Position = UDim2.new(1,-25,0,0)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,60,60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn)

local flingBtn = Instance.new("TextButton", frame)
flingBtn.Text = "Fling: OFF"
flingBtn.Size = UDim2.new(1,-20,0,25)
flingBtn.Position = UDim2.new(0,10,0,35)
flingBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
flingBtn.TextColor3 = Color3.fromRGB(255,255,255)
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 13
Instance.new("UICorner", flingBtn)

local powerBox = Instance.new("TextBox", frame)
powerBox.Text = tostring(flingPower)
powerBox.Size = UDim2.new(1,-20,0,25)
powerBox.Position = UDim2.new(0,10,0,70)
powerBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
powerBox.TextColor3 = Color3.fromRGB(255,255,255)
powerBox.Font = Enum.Font.Gotham
powerBox.TextSize = 13
powerBox.PlaceholderText = "Fling Power"
Instance.new("UICorner", powerBox)

local saveBtn = Instance.new("TextButton", frame)
saveBtn.Text = "Save Base"
saveBtn.Size = UDim2.new(1,-20,0,25)
saveBtn.Position = UDim2.new(0,10,0,105)
saveBtn.BackgroundColor3 = Color3.fromRGB(100,255,100)
saveBtn.TextColor3 = Color3.fromRGB(0,0,0)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 13
Instance.new("UICorner", saveBtn)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Text = "TP to Base"
tpBtn.Size = UDim2.new(1,-20,0,25)
tpBtn.Position = UDim2.new(0,10,0,140)
tpBtn.BackgroundColor3 = Color3.fromRGB(255,200,100)
tpBtn.TextColor3 = Color3.fromRGB(0,0,0)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 13
Instance.new("UICorner", tpBtn)

-- Логика
contBtn.MouseButton1Click:Connect(function()
 if keyBox.Text == "FREE" then
   frame.Visible = true
   keyFrame.Visible = false
 end
end)

closeBtn.MouseButton1Click:Connect(function()
 frame.Visible = not frame.Visible
end)

flingBtn.MouseButton1Click:Connect(function()
 flingEnabled = not flingEnabled
 flingBtn.Text = "Fling: "..(flingEnabled and "ON" or "OFF")
end)

powerBox.FocusLost:Connect(function()
 local n = tonumber(powerBox.Text)
 if n then flingPower = n end
 powerBox.Text = tostring(flingPower)
end)

saveBtn.MouseButton1Click:Connect(function()
 local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
 if hrp then savedBase = hrp.Position end
end)

tpBtn.MouseButton1Click:Connect(function()
 local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
 if hrp and savedBase then
   local dist = (savedBase - hrp.Position).Magnitude
   local steps = math.clamp(dist/10,10,100)
   for i=1,steps do
     hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(savedBase), i/steps)
     wait(0.02)
   end
 end
end)

-- Корректный fling: только другие улетают
game:GetService("RunService").Heartbeat:Connect(function()
 if flingEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
  local myHRP = plr.Character.HumanoidRootPart
  for _,v in ipairs(game.Players:GetPlayers()) do
   if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
     local enemyHRP = v.Character.HumanoidRootPart
     local dist = (enemyHRP.Position - myHRP.Position).Magnitude
     if dist<25 then
       enemyHRP.Velocity = (enemyHRP.Position - myHRP.Position).Unit * flingPower
     end
   end
  end
  myHRP.Velocity = Vector3.new(0,0,0) -- фиксируем себя
 end
end)
