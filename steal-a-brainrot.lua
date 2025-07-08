-- 🌈 GDE PATRICK HUB X | by @gde_patrick
local plr = game.Players.LocalPlayer
local flingPower = 300
local flingEnabled = false
local savedBase = nil

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "PatrickHub"

-- Главное меню
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 160)
frame.Position = UDim2.new(0.5, -100, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
frame.BackgroundTransparency = 0.2
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Text = "GDE PATRICK HUB"
title.Size = UDim2.new(1,-25,0,25)
title.Position = UDim2.new(0,5,0,0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0,20,0,20)
closeBtn.Position = UDim2.new(1,-22,0,2)
closeBtn.BackgroundColor3 = Color3.fromRGB(255,60,60)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
Instance.new("UICorner", closeBtn)

local flingBtn = Instance.new("TextButton", frame)
flingBtn.Text = "Fling: OFF"
flingBtn.Size = UDim2.new(1,-20,0,25)
flingBtn.Position = UDim2.new(0,10,0,30)
flingBtn.BackgroundColor3 = Color3.fromRGB(100,100,255)
flingBtn.TextColor3 = Color3.fromRGB(255,255,255)
flingBtn.Font = Enum.Font.GothamBold
flingBtn.TextSize = 13
Instance.new("UICorner", flingBtn)

local powerBox = Instance.new("TextBox", frame)
powerBox.Text = tostring(flingPower)
powerBox.Size = UDim2.new(1,-20,0,25)
powerBox.Position = UDim2.new(0,10,0,60)
powerBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
powerBox.TextColor3 = Color3.fromRGB(255,255,255)
powerBox.Font = Enum.Font.Gotham
powerBox.TextSize = 13
powerBox.PlaceholderText = "Fling Power"
Instance.new("UICorner", powerBox)

local saveBtn = Instance.new("TextButton", frame)
saveBtn.Text = "Save Base"
saveBtn.Size = UDim2.new(1,-20,0,25)
saveBtn.Position = UDim2.new(0,10,0,90)
saveBtn.BackgroundColor3 = Color3.fromRGB(100,255,100)
saveBtn.TextColor3 = Color3.fromRGB(0,0,0)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 13
Instance.new("UICorner", saveBtn)

local tpBtn = Instance.new("TextButton", frame)
tpBtn.Text = "TP to Base"
tpBtn.Size = UDim2.new(1,-20,0,25)
tpBtn.Position = UDim2.new(0,10,0,120)
tpBtn.BackgroundColor3 = Color3.fromRGB(255,200,100)
tpBtn.TextColor3 = Color3.fromRGB(0,0,0)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 13
Instance.new("UICorner", tpBtn)

-- Логика
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

-- Рабочий fling: мы НЕ двигаем себя, а другим ставим Velocity
game:GetService("RunService").Heartbeat:Connect(function()
 if flingEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
  local myHRP = plr.Character.HumanoidRootPart
  for _,v in ipairs(game.Players:GetPlayers()) do
   if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
     local enemyHRP = v.Character.HumanoidRootPart
     local dist = (enemyHRP.Position - myHRP.Position).Magnitude
     if dist<20 then
       enemyHRP.Velocity = (enemyHRP.Position - myHRP.Position).Unit * flingPower
     end
   end
  end
  myHRP.Velocity = Vector3.zero
 end
end)
