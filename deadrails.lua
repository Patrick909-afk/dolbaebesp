-- Настройки
local speed = 25
local jumpPower = 45
local spinSpeed = 50 -- быстрее спин
local hitRate = 0.01 -- быстрее удары
local attackDistance = 3
local targetPart = "HumanoidRootPart"

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local rs = game:GetService("RunService")

local active = true
local minimized = false
local targetPlayer = nil
local lastHit = 0

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,300)
frame.Position = UDim2.new(0,100,0,100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local onoff = Instance.new("TextButton", frame)
onoff.Size = UDim2.new(0,200,0,40)
onoff.Position = UDim2.new(0,10,0,10)
onoff.Text = "✅ ВКЛ"
onoff.BackgroundColor3 = Color3.fromRGB(60,180,60)

local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,20,0,20)
close.Position = UDim2.new(1,-25,0,5)
close.Text = "✖"
close.BackgroundColor3 = Color3.fromRGB(180,60,60)

local mini = Instance.new("TextButton", frame)
mini.Size = UDim2.new(0,20,0,20)
mini.Position = UDim2.new(1,-50,0,5)
mini.Text = "🌟"
mini.BackgroundColor3 = Color3.fromRGB(60,60,180)

local plist = Instance.new("ScrollingFrame", frame)
plist.Size = UDim2.new(0,200,0,220)
plist.Position = UDim2.new(0,10,0,60)
plist.BackgroundColor3 = Color3.fromRGB(50,50,50)
plist.CanvasSize = UDim2.new(0,0,0,0)

-- Функция создания кнопки игрока
local function makeBtn(name)
    local b = Instance.new("TextButton", plist)
    b.Size = UDim2.new(1,0,0,25)
    b.Text = name
    b.BackgroundColor3 = Color3.fromRGB(80,80,80)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        if targetPlayer and targetPlayer.Name==name then
            targetPlayer=nil
            b.BackgroundColor3 = Color3.fromRGB(80,80,80)
        else
            for _,x in pairs(plist:GetChildren()) do
                if x:IsA("TextButton") then x.BackgroundColor3=Color3.fromRGB(80,80,80) end
            end
            targetPlayer=plrs:FindFirstChild(name)
            if targetPlayer then b.BackgroundColor3=Color3.fromRGB(60,180,60) end
        end
    end)
end

-- Обновление списка игроков часто
spawn(function()
    while true do
        plist:ClearAllChildren()
        for _,p in pairs(plrs:GetPlayers()) do
            if p~=lp then makeBtn(p.Name) end
        end
        plist.CanvasSize=UDim2.new(0,0,0,#plist:GetChildren()*25)
        wait(1)
    end
end)

-- Кнопки
onoff.MouseButton1Click:Connect(function()
    active=not active
    onoff.Text=active and "✅ ВКЛ" or "❌ ВЫКЛ"
    onoff.BackgroundColor3=active and Color3.fromRGB(60,180,60) or Color3.fromRGB(180,60,60)
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)
mini.MouseButton1Click:Connect(function()
    minimized=not minimized
    plist.Visible=not minimized
    onoff.Visible=not minimized
end)

-- Перезапуск персонажа
lp.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").JumpPower=jumpPower
end)

-- Быстрый удар
local function attack()
    if tick()-lastHit>=hitRate then
        mouse1click()
        lastHit=tick()
    end
end

-- Быстрый спин
local function spin()
    local c=lp.Character
    if c and c:FindFirstChild(targetPart) then
        c[targetPart].CFrame=c[targetPart].CFrame*CFrame.Angles(0,math.rad(spinSpeed),0)
    end
end

-- Главный цикл
rs.RenderStepped:Connect(function()
    if not active or not lp.Character or not lp.Character:FindFirstChild("Humanoid") then return end
    local hum=lp.Character:FindFirstChildOfClass("Humanoid")
    local myHRP=lp.Character:FindFirstChild(targetPart)
    if hum and hum.Health>0 and myHRP then
        local t=nil
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(targetPart) then
            t=targetPlayer.Character[targetPart]
        else
            local closest,dist
            for _,p in pairs(plrs:GetPlayers()) do
                if p~=lp and p.Character and p.Character:FindFirstChild(targetPart) then
                    local d=(myHRP.Position-p.Character[targetPart].Position).Magnitude
                    if not dist or d<dist then closest=p.Character[targetPart]; dist=d end
                end
            end
            t=closest
        end
        if t then
            local d=(myHRP.Position-t.Position).Magnitude
            if d>attackDistance then
                local dir=(t.Position-myHRP.Position).Unit
                myHRP.Velocity=dir*speed
            else attack() end
        end
        spin()
    end
end)
