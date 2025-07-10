-- ПАРАМЕТРЫ
local speed = 40         -- скорость
local spinSpeed = 60     -- скорость кручения
local hitRate = 0.05     -- удары каждые 0.05 сек
local attackDistance = 4 -- расстояние до удара
local jumpPower = 60

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local rs = game:GetService("RunService")

local targetPlayer = nil
local active = true
local minimized = false
local lastHit = 0

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn=false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,230,0,300)
frame.Position = UDim2.new(0,100,0,100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active=true
frame.Draggable=true

local onoff = Instance.new("TextButton", frame)
onoff.Size=UDim2.new(0,200,0,40)
onoff.Position=UDim2.new(0,10,0,10)
onoff.Text="✅ ВКЛ"
onoff.BackgroundColor3=Color3.fromRGB(60,180,60)

local close = Instance.new("TextButton", frame)
close.Size=UDim2.new(0,20,0,20)
close.Position=UDim2.new(1,-25,0,5)
close.Text="✖"
close.BackgroundColor3=Color3.fromRGB(180,60,60)

local mini = Instance.new("TextButton", frame)
mini.Size=UDim2.new(0,20,0,20)
mini.Position=UDim2.new(1,-50,0,5)
mini.Text="🌟"
mini.BackgroundColor3=Color3.fromRGB(60,60,180)

local plist = Instance.new("ScrollingFrame", frame)
plist.Size=UDim2.new(0,200,0,220)
plist.Position=UDim2.new(0,10,0,60)
plist.BackgroundColor3=Color3.fromRGB(50,50,50)
plist.CanvasSize=UDim2.new(0,0,0,0)
plist.ScrollBarThickness=6

-- Список игроков
local function makeBtn(name)
    local b=Instance.new("TextButton", plist)
    b.Size=UDim2.new(1,0,0,25)
    b.Text=name
    b.BackgroundColor3=Color3.fromRGB(80,80,80)
    b.TextColor3=Color3.new(1,1,1)
    b.MouseButton1Click:Connect(function()
        if targetPlayer and targetPlayer.Name==name then
            targetPlayer=nil
            b.BackgroundColor3=Color3.fromRGB(80,80,80)
        else
            for _,x in ipairs(plist:GetChildren()) do
                if x:IsA("TextButton") then x.BackgroundColor3=Color3.fromRGB(80,80,80) end
            end
            targetPlayer=plrs:FindFirstChild(name)
            if targetPlayer then b.BackgroundColor3=Color3.fromRGB(60,180,60) end
        end
    end)
end

spawn(function()
    while true do
        plist:ClearAllChildren()
        for _,p in ipairs(plrs:GetPlayers()) do
            if p~=lp and p.Character then makeBtn(p.Name) end
        end
        plist.CanvasSize=UDim2.new(0,0,0,#plist:GetChildren()*25)
        wait(1)
    end
end)

-- КНОПКИ
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

-- После респавна
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

-- Кручение и наклон вниз
local function spin(char)
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame=hrp.CFrame*CFrame.Angles(math.rad(80),math.rad(spinSpeed),0)
    end
end

-- Проверка стены
local function isBlocked(char,target)
    local hrp=char:FindFirstChild("HumanoidRootPart")
    if hrp and target then
        local ray=Ray.new(hrp.Position,(target.Position-hrp.Position).Unit*5)
        local hit=workspace:FindPartOnRayWithIgnoreList(ray,{char})
        return hit and (hit.Position - target.Position).Magnitude>2
    end
    return false
end

-- ГЛАВНЫЙ ЦИКЛ
rs.Heartbeat:Connect(function()
    if not active or not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local char=lp.Character
    local hrp=char:FindFirstChild("HumanoidRootPart")
    local hum=char:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health>0 and hrp then
        local t=targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and targetPlayer.Character.Humanoid.Health>0 and targetPlayer.Character["HumanoidRootPart"] or nil
        if not t then
            -- nearest
            local dist=nil
            for _,p in ipairs(plrs:GetPlayers()) do
                if p~=lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.Humanoid.Health>0 then
                    local d=(hrp.Position - p.Character["HumanoidRootPart"].Position).Magnitude
                    if not dist or d<dist then
                        t=p.Character["HumanoidRootPart"]
                        dist=d
                    end
                end
            end
        end
        if t then
            local d=(hrp.Position - t.Position).Magnitude
            if d>attackDistance then
                if isBlocked(char,t) then
                    -- обход: вверх и вбок
                    hrp.Velocity=Vector3.new(0,30,0)+ (t.Position-hrp.Position).Unit*speed
                else
                    -- бежим
                    hrp.Velocity=(t.Position-hrp.Position).Unit*speed
                end
            else
                attack()
            end
        end
        spin(char)
    end
end)
