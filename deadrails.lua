local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()
local hum = chr:WaitForChild("Humanoid")
local hrp = chr:WaitForChild("HumanoidRootPart")
local rs = game:GetService("RunService")

-- настройки
local speed = hum.WalkSpeed * 1.1
local spin = 40
local hitDelay = 0.01
local attacking, spinning, stealing, minimized = true, true, false, false
local target = nil
local lastHit = 0

-- 🪄 gui
local s = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", s)
frame.Size = UDim2.new(0,250,0,400)
frame.Position = UDim2.new(0.5,-125,0.5,-200)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel=0

local title = Instance.new("TextLabel", frame)
title.Size=UDim2.new(1,0,0,30)
title.Text="🔥 Fat Script by YOU"
title.TextColor3=Color3.new(1,1,1)
title.BackgroundTransparency=1
title.Font=Enum.Font.SourceSansBold
title.TextSize=18

local star = Instance.new("TextButton", frame)
star.Size=UDim2.new(0,30,0,30)
star.Position=UDim2.new(1,-60,0,0)
star.Text="🌟"
star.TextSize=18
star.BackgroundTransparency=0.5

local close = Instance.new("TextButton", frame)
close.Size=UDim2.new(0,30,0,30)
close.Position=UDim2.new(1,-30,0,0)
close.Text="❌"
close.TextSize=18
close.BackgroundTransparency=0.5

local attackBtn = Instance.new("TextButton", frame)
attackBtn.Size=UDim2.new(1,0,0,30)
attackBtn.Position=UDim2.new(0,0,0,30)
attackBtn.Text="Атака ON"
attackBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
attackBtn.TextColor3=Color3.new(1,1,1)

local spinBtn = Instance.new("TextButton", frame)
spinBtn.Size=UDim2.new(1,0,0,30)
spinBtn.Position=UDim2.new(0,0,0,60)
spinBtn.Text="Крутилка ON"
spinBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
spinBtn.TextColor3=Color3.new(1,1,1)

local stealBtn = Instance.new("TextButton", frame)
stealBtn.Size=UDim2.new(1,0,0,30)
stealBtn.Position=UDim2.new(0,0,0,90)
stealBtn.Text="Спиздить OFF"
stealBtn.BackgroundColor3=Color3.fromRGB(50,50,50)
stealBtn.TextColor3=Color3.new(1,1,1)

local list = Instance.new("ScrollingFrame", frame)
list.Size=UDim2.new(1,0,1,-130)
list.Position=UDim2.new(0,0,0,130)
list.CanvasSize=UDim2.new(0,0,0,0)
list.BackgroundTransparency=0.3

local UIListLayout=Instance.new("UIListLayout",list)

-- функции
local function refreshPlayers()
    list:ClearAllChildren()
    UIListLayout.Parent=nil
    for _,p in pairs(plrs:GetPlayers()) do
        if p~=lp then
            local b=Instance.new("TextButton",list)
            b.Size=UDim2.new(1,0,0,25)
            b.Text=p.Name.." ["..(target==p and "ON" or "OFF").."]"
            b.BackgroundColor3=Color3.fromRGB(70,70,70)
            b.TextColor3=Color3.new(1,1,1)
            b.MouseButton1Click:Connect(function()
                if target==p then target=nil else target=p end
                refreshPlayers()
            end)
        end
    end
    UIListLayout.Parent=list
    list.CanvasSize=UDim2.new(0,0,0,#plrs:GetPlayers()*25)
end

-- обработчики
attackBtn.MouseButton1Click:Connect(function()
    attacking=not attacking
    attackBtn.Text="Атака "..(attacking and "ON" or "OFF")
end)

spinBtn.MouseButton1Click:Connect(function()
    spinning=not spinning
    spinBtn.Text="Крутилка "..(spinning and "ON" or "OFF")
end)

stealBtn.MouseButton1Click:Connect(function()
    stealing=not stealing
    stealBtn.Text="Спиздить "..(stealing and "ON" or "OFF")
end)

star.MouseButton1Click:Connect(function()
    minimized=not minimized
    for _,v in pairs(frame:GetChildren()) do
        if v~=star and v~=close and v~=title then v.Visible=not minimized end
    end
end)

close.MouseButton1Click:Connect(function()
    s:Destroy()
end)

-- апдейты
plrs.PlayerAdded:Connect(refreshPlayers)
plrs.PlayerRemoving:Connect(refreshPlayers)
refreshPlayers()

-- логика
rs.RenderStepped:Connect(function()
    if attacking and tick()-lastHit>hitDelay and lp.Backpack:FindFirstChildOfClass("Tool") then
        lastHit=tick()
        lp.Backpack:FindFirstChildOfClass("Tool"):Activate()
    end
    if spinning then hrp.CFrame=hrp.CFrame*CFrame.Angles(0,math.rad(spin),0) end
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local pos=target.Character.HumanoidRootPart.Position
        local dir=(pos-hrp.Position).Unit
        hrp.Velocity=dir*speed
        -- 💥 удар с отталкиванием
        local tHum=target.Character:FindFirstChild("Humanoid")
        if tHum and tHum.Health>0 then
            tHum:TakeDamage(100)
            target.Character.HumanoidRootPart.Velocity=Vector3.new(0,50,0)
        end
    else
        hum.WalkSpeed=speed
    end
    if stealing then
        hrp.Velocity=Vector3.new(0,50,0)
        hrp.CFrame=hrp.CFrame*CFrame.Angles(math.rad(90),0,0)
    end
end)
