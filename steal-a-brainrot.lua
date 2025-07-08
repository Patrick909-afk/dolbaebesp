local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

local savedPosition=nil
local flingOn=false
local flyOn=false
local speedOn=false
local jumpOn=false
local spamOn=false
local autoHitOn=false
local flingPart=nil

-- GUI
local gui=Instance.new("ScreenGui",game.CoreGui)
gui.Name="PatrickHub"

-- Экран входа
local keyFrame=Instance.new("Frame",gui)
keyFrame.Size=UDim2.new(0,280,0,150)
keyFrame.Position=UDim2.new(0.5,-140,0.5,-75)
keyFrame.BackgroundColor3=Color3.fromRGB(20,20,30)
keyFrame.BackgroundTransparency=0.3
Instance.new("UICorner",keyFrame)

local title=Instance.new("TextLabel",keyFrame)
title.Size=UDim2.new(1,0,0,30)
title.Text="PatrickHub v1 @gde_patrick"
title.TextColor3=Color3.new(1,1,1)
title.Font=Enum.Font.GothamBold
title.TextSize=16
title.BackgroundTransparency=1

local keyBox=Instance.new("TextBox",keyFrame)
keyBox.Size=UDim2.new(0.8,0,0,30)
keyBox.Position=UDim2.new(0.1,0,0.4,0)
keyBox.PlaceholderText="Введите ключ"
keyBox.Text=""
keyBox.Font=Enum.Font.Gotham
keyBox.TextSize=14
keyBox.TextColor3=Color3.new(1,1,1)
keyBox.BackgroundColor3=Color3.fromRGB(40,40,50)
Instance.new("UICorner",keyBox)

local msg=Instance.new("TextLabel",keyFrame)
msg.Size=UDim2.new(1,0,0,20)
msg.Position=UDim2.new(0,0,0.7,0)
msg.Text=""
msg.TextColor3=Color3.fromRGB(255,100,100)
msg.Font=Enum.Font.Gotham
msg.TextSize=14
msg.BackgroundTransparency=1

local btn=Instance.new("TextButton",keyFrame)
btn.Size=UDim2.new(0.6,0,0,28)
btn.Position=UDim2.new(0.2,0,0.85,0)
btn.Text="Continue"
btn.TextColor3=Color3.new(1,1,1)
btn.Font=Enum.Font.GothamBold
btn.TextSize=14
btn.BackgroundColor3=Color3.fromRGB(80,160,80)
Instance.new("UICorner",btn)

-- Главное меню
local main=Instance.new("Frame")
main.Size=UDim2.new(0,280,0,300)
main.Position=UDim2.new(0.5,-140,0.5,-150)
main.BackgroundColor3=Color3.fromRGB(20,20,30)
main.BackgroundTransparency=0.3
main.Visible=false
Instance.new("UICorner",main)
main.Parent=gui

local title2=Instance.new("TextLabel",main)
title2.Size=UDim2.new(1,0,0,25)
title2.Text="PatrickHub v1 @gde_patrick"
title2.Font=Enum.Font.GothamBold
title2.TextSize=14
title2.TextColor3=Color3.new(1,1,1)
title2.BackgroundColor3=Color3.fromRGB(10,10,20)
title2.BackgroundTransparency=0.3

local close=Instance.new("TextButton",title2)
close.Size=UDim2.new(0,24,0,24)
close.Position=UDim2.new(1,-28,0,0)
close.Text="X"
close.TextColor3=Color3.new(1,1,1)
close.BackgroundColor3=Color3.fromRGB(255,60,60)
Instance.new("UICorner",close)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local scroll=Instance.new("ScrollingFrame",main)
scroll.Size=UDim2.new(1,0,1,-25)
scroll.Position=UDim2.new(0,0,0,25)
scroll.CanvasSize=UDim2.new(0,0,0,500)
scroll.ScrollBarThickness=4
scroll.BackgroundTransparency=1

local layout=Instance.new("UIListLayout",scroll)
layout.Padding=UDim.new(0,5)

local function createBtn(text,callback)
local b=Instance.new("TextButton",scroll)
b.Size=UDim2.new(0.9,0,0,28)
b.Text=text
b.Font=Enum.Font.Gotham
b.TextSize=13
b.TextColor3=Color3.new(1,1,1)
b.BackgroundColor3=Color3.fromRGB(50,50,60)
Instance.new("UICorner",b)
b.MouseButton1Click:Connect(callback)
end

-- Функции
createBtn("Fling ВКЛ/ВЫКЛ",function()
flingOn=not flingOn
if flingOn then
    flingPart=Instance.new("BodyAngularVelocity")
    flingPart.AngularVelocity=Vector3.new(0,500000,0)
    flingPart.MaxTorque=Vector3.new(0,math.huge,0)
    flingPart.P=math.huge
    flingPart.Parent=hrp
else
    if flingPart then flingPart:Destroy() end
end
end)

createBtn("Fly ВКЛ/ВЫКЛ",function() flyOn=not flyOn end)

createBtn("SpeedHack ВКЛ/ВЫКЛ",function()
speedOn=not speedOn
if speedOn then char:FindFirstChildOfClass("Humanoid").WalkSpeed=50 else char:FindFirstChildOfClass("Humanoid").WalkSpeed=16 end
end)

createBtn("JumpHack ВКЛ/ВЫКЛ",function()
jumpOn=not jumpOn
if jumpOn then char:FindFirstChildOfClass("Humanoid").JumpPower=100 else char:FindFirstChildOfClass("Humanoid").JumpPower=50 end
end)

createBtn("Невидимость",function()
for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.Transparency=1 end end
end)

createBtn("Случайный цвет",function()
for _,v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.Color=Color3.new(math.random(),math.random(),math.random()) end end
end)

createBtn("Спам в чат ВКЛ/ВЫКЛ",function() spamOn=not spamOn end)

createBtn("Автоудар ВКЛ/ВЫКЛ",function() autoHitOn=not autoHitOn end)

createBtn("Сохранить позицию базы",function() savedPosition=hrp.Position end)

createBtn("Телепорт к базе",function()
if savedPosition then TweenService:Create(hrp,TweenInfo.new(2),{CFrame=CFrame.new(savedPosition)}):Play() end
end)

-- Перетаскивание
local dragging=false;local dragStart;local startPos
title2.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;dragStart=input.Position;startPos=main.Position end end)
UserInputService.InputChanged:Connect(function(input)
if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
local delta=input.Position-dragStart
main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)

-- Логика fly/spam/удар
spawn(function() while wait(0.1) do
if flyOn then hrp.Velocity=Vector3.new(0,50,0) end
if spamOn then game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("PatrickHub op","All") end
if autoHitOn then local tool=player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool") if tool then tool:Activate() end end
end end)

-- Проверка ключа
btn.MouseButton1Click:Connect(function() if keyBox.Text=="FREE" then keyFrame.Visible=false;main.Visible=true else msg.Text="Неверный ключ!" end end)
