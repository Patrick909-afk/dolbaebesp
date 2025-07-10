-- Настройки
local speed = 26
local jumpPower = 45
local spinSpeed = 50
local hitRate = 0.01
local attackDistance = 3
local targetPart = "HumanoidRootPart"

local plrs = game:GetService("Players")
local lp = plrs.LocalPlayer
local rs = game:GetService("RunService")
local mouse = lp:GetMouse()

local active = true
local minimized = false

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

local plist = Instance.new("TextLabel", frame)
plist.Size = UDim2.new(0,200,0,200)
plist.Position = UDim2.new(0,10,0,60)
plist.BackgroundColor3 = Color3.fromRGB(50,50,50)
plist.TextColor3 = Color3.new(1,1,1)
plist.TextWrapped = true
plist.TextYAlignment = Enum.TextYAlignment.Top
plist.Text = "Игроки..."

-- Кнопки
onoff.MouseButton1Click:Connect(function()
    active = not active
    onoff.Text = active and "✅ ВКЛ" or "❌ ВЫКЛ"
    onoff.BackgroundColor3 = active and Color3.fromRGB(60,180,60) or Color3.fromRGB(180,60,60)
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)
mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    plist.Visible = not minimized
    onoff.Visible = not minimized
end)

-- Список игроков
local function updatePlist()
    local text = ""
    for _,p in pairs(plrs:GetPlayers()) do
        if p ~= lp then text = text..p.Name.."\n" end
    end
    plist.Text = text == "" and "Нет других игроков" or text
end
plrs.PlayerAdded:Connect(updatePlist)
plrs.PlayerRemoving:Connect(updatePlist)
updatePlist()

-- Удар
local lastHit = 0
local function attack()
    if tick()-lastHit>=hitRate then
        mouse1click()
        lastHit=tick()
    end
end

-- Ближайший враг
local function getTarget()
    local closest,dist
    local myHRP = lp.Character and lp.Character:FindFirstChild(targetPart)
    if not myHRP then return end
    for _,p in pairs(plrs:GetPlayers()) do
        if p~=lp and p.Character and p.Character:FindFirstChild(targetPart) then
            local mag = (myHRP.Position-p.Character[targetPart].Position).Magnitude
            if not dist or mag<dist then
                closest=p.Character[targetPart]
                dist=mag
            end
        end
    end
    return closest
end

-- Спин
local function spin()
    local c = lp.Character
    if c and c:FindFirstChild(targetPart) then
        c[targetPart].CFrame = c[targetPart].CFrame*CFrame.Angles(0,math.rad(spinSpeed),0)
    end
end

-- Перезапуск
lp.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid").JumpPower=jumpPower
end)

-- Основной цикл
rs.RenderStepped:Connect(function()
    if not active or not lp.Character or not lp.Character:FindFirstChild("Humanoid") then return end
    local hum=lp.Character:FindFirstChildOfClass("Humanoid")
    if hum and hum.Health>0 then
        local t=getTarget()
        local myHRP=lp.Character:FindFirstChild(targetPart)
        if t and myHRP then
            local d=(myHRP.Position-t.Position).Magnitude
            if d>attackDistance then
                local dir=(t.Position-myHRP.Position).Unit
                myHRP.Velocity=dir*speed
            else attack() end
        end
        spin()
    end
end)
