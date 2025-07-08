local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local Players=game:GetService("Players")
local player=Players.LocalPlayer
local char=player.Character or player.CharacterAdded:Wait()
local hrp=char:WaitForChild("HumanoidRootPart")

local savedPos=nil
local flingOn,flyOn,autoHitOn,spamOn,speedOn,jumpOn=false,false,false,false,false,false
local flingPower,speedPower,jumpPower,flyPower=50000,16,50,50
local flingPart,flyGyro,flyBV

-- GUI
local gui=Instance.new("ScreenGui",game.CoreGui)
gui.Name="PatrickHub"

-- Авторизация
local auth=Instance.new("Frame",gui)
auth.Size=UDim2.new(0,260,0,140)
auth.Position=UDim2.new(0.5,-130,0.5,-70)
auth.BackgroundColor3=Color3.fromRGB(20,20,30)
auth.BackgroundTransparency=0.3
Instance.new("UICorner",auth)

local keyBox=Instance.new("TextBox",auth)
keyBox.PlaceholderText="Введите ключ"
keyBox.Size=UDim2.new(0.8,0,0,28)
keyBox.Position=UDim2.new(0.1,0,0.3,0)
keyBox.Font=Enum.Font.Gotham
keyBox.TextColor3=Color3.new(1,1,1)
keyBox.BackgroundColor3=Color3.fromRGB(40,40,50)
Instance.new("UICorner",keyBox)

local msg=Instance.new("TextLabel",auth)
msg.Size=UDim2.new(1,0,0,20)
msg.Position=UDim2.new(0,0,0.55,0)
msg.Text=""
msg.TextColor3=Color3.fromRGB(255,80,80)
msg.Font=Enum.Font.Gotham
msg.TextSize=14
msg.BackgroundTransparency=1

local btn=Instance.new("TextButton",auth)
btn.Size=UDim2.new(0.6,0,0,26)
btn.Position=UDim2.new(0.2,0,0.75,0)
btn.Text="Continue"
btn.Font=Enum.Font.GothamBold
btn.TextColor3=Color3.new(1,1,1)
btn.BackgroundColor3=Color3.fromRGB(80,160,80)
Instance.new("UICorner",btn)

-- Главное меню
local main=Instance.new("Frame",gui)
main.Size=UDim2.new(0,300,0,350)
main.Position=UDim2.new(0.5,-150,0.5,-175)
main.BackgroundColor3=Color3.fromRGB(20,20,30)
main.BackgroundTransparency=0.3
main.Visible=false
Instance.new("UICorner",main)

local title=Instance.new("TextLabel",main)
title.Size=UDim2.new(1,0,0,24)
title.Text="@gde_patrick | PatrickHub"
title.Font=Enum.Font.GothamBold
title.TextSize=13
title.TextColor3=Color3.new(1,1,1)
title.BackgroundColor3=Color3.fromRGB(10,10,20)
title.BackgroundTransparency=0.3

local close=Instance.new("TextButton",title)
close.Size=UDim2.new(0,24,0,24)
close.Position=UDim2.new(1,-28,0,0)
close.Text="X"
close.Font=Enum.Font.GothamBold
close.TextColor3=Color3.new(1,1,1)
close.BackgroundColor3=Color3.fromRGB(255,60,60)
Instance.new("UICorner",close)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local scroll=Instance.new("ScrollingFrame",main)
scroll.Size=UDim2.new(1,0,1,-24)
scroll.Position=UDim2.new(0,0,0,24)
scroll.ScrollBarThickness=4
scroll.BackgroundTransparency=1

local layout=Instance.new("UIListLayout",scroll)
layout.Padding=UDim.new(0,4)

-- Перетаскивание
local dragging,dragStart,startPos
title.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true;dragStart=input.Position;startPos=main.Position end end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta=input.Position-dragStart
        main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
    end end)
UIS.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end)

-- Утилы
local function newBtn(txt,callback)
    local b=Instance.new("TextButton",scroll)
    b.Size=UDim2.new(0.92,0,0,26)
    b.Text=txt
    b.Font=Enum.Font.Gotham
    b.TextColor3=Color3.new(1,1,1)
    b.BackgroundColor3=Color3.fromRGB(50,50,60)
    Instance.new("UICorner",b)
    b.MouseButton1Click:Connect(callback)
end

local function newSlider(label,default,callback)
    local f=Instance.new("Frame",scroll)
    f.Size=UDim2.new(0.92,0,0,26)
    f.BackgroundTransparency=1
    local l=Instance.new("TextLabel",f)
    l.Size=UDim2.new(0.5,0,1,0)
    l.Text=label..": "..default
    l.Font=Enum.Font.Gotham
    l.TextColor3=Color3.new(1,1,1)
    l.BackgroundTransparency=1
    l.TextXAlignment="Left"
    local s=Instance.new("TextButton",f)
    s.Size=UDim2.new(0.5,0,1,0)
    s.Position=UDim2.new(0.5,0,0,0)
    s.Text="➕"
    s.BackgroundColor3=Color3.fromRGB(40,40,50)
    Instance.new("UICorner",s)
    s.MouseButton1Click:Connect(function()
        callback(default+10)
        default=default+10
        l.Text=label..": "..default
    end)
end

-- Слайдеры
newSlider("Fling",flingPower,function(v) flingPower=v end)
newSlider("Speed",speedPower,function(v) speedPower=v;if speedOn then char:FindFirstChildOfClass("Humanoid").WalkSpeed=v end end)
newSlider("Jump",jumpPower,function(v) jumpPower=v;if jumpOn then char:FindFirstChildOfClass("Humanoid").JumpPower=v end end)
newSlider("Fly",flyPower,function(v) flyPower=v end)

-- Кнопки
newBtn("Fling ON/OFF",function()
flingOn=not flingOn
if flingOn and not flingPart then
    flingPart=Instance.new("BodyAngularVelocity",hrp)
    flingPart.AngularVelocity=Vector3.new(0,flingPower,0)
    flingPart.MaxTorque=Vector3.new(0,math.huge,0)
    flingPart.P=math.huge
elseif not flingOn and flingPart then flingPart:Destroy();flingPart=nil end end)

newBtn("Fly ON/OFF",function()
flyOn=not flyOn
if flyOn then
flyGyro=Instance.new("BodyGyro",hrp)
flyGyro.P=9e4;flyGyro.MaxTorque=Vector3.new(9e4,9e4,9e4)
flyBV=Instance.new("BodyVelocity",hrp)
flyBV.Velocity=Vector3.new(0,flyPower,0);flyBV.MaxForce=Vector3.new(9e4,9e4,9e4)
else if flyGyro then flyGyro:Destroy() end;if flyBV then flyBV:Destroy() end end end)

newBtn("Speed ON/OFF",function() speedOn=not speedOn;local h=char:FindFirstChildOfClass("Humanoid")
if speedOn then h.WalkSpeed=speedPower else h.WalkSpeed=16 end end)

newBtn("Jump ON/OFF",function() jumpOn=not jumpOn;local h=char:FindFirstChildOfClass("Humanoid")
if jumpOn then h.JumpPower=jumpPower else h.JumpPower=50 end end)

newBtn("AutoHit ON/OFF",function() autoHitOn=not autoHitOn end)
newBtn("Spam ON/OFF",function() spamOn=not spamOn end)
newBtn("Save base pos",function() savedPos=hrp.Position end)
newBtn("TP to base",function() if savedPos then TS:Create(hrp,TweenInfo.new(3),{CFrame=CFrame.new(savedPos)}):Play() end end)

-- Лупы
spawn(function() while wait(0.1) do
if autoHitOn then local t=player.Backpack:FindFirstChildOfClass("Tool") or char:FindFirstChildOfClass("Tool") if t then t:Activate() end end
if spamOn then pcall(function() game.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer("PatrickHub op","All") end) end
if flyOn and flyBV then flyBV.Velocity=Vector3.new(0,flyPower,0);flyGyro.CFrame=workspace.CurrentCamera.CFrame end
if flingPart then flingPart.AngularVelocity=Vector3.new(0,flingPower,0) end end end)

player.CharacterAdded:Connect(function(c)
char=c;wait(1);hrp=char:WaitForChild("HumanoidRootPart")
if speedOn then char:FindFirstChildOfClass("Humanoid").WalkSpeed=speedPower end
if jumpOn then char:FindFirstChildOfClass("Humanoid").JumpPower=jumpPower end
if flyOn then
flyGyro=Instance.new("BodyGyro",hrp)
flyGyro.P=9e4;flyGyro.MaxTorque=Vector3.new(9e4,9e4,9e4)
flyBV=Instance.new("BodyVelocity",hrp)
flyBV.Velocity=Vector3.new(0,flyPower,0);flyBV.MaxForce=Vector3.new(9e4,9e4,9e4)
end
if flingOn then
flingPart=Instance.new("BodyAngularVelocity",hrp)
flingPart.AngularVelocity=Vector3.new(0,flingPower,0)
flingPart.MaxTorque=Vector3.new(0,math.huge,0)
flingPart.P=math.huge
end end)

btn.MouseButton1Click:Connect(function() if keyBox.Text=="FREE" then auth.Visible=false;main.Visible=true else msg.Text="Неверный ключ!" end end)
