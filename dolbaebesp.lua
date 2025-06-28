-- RobloxLabubuStealer ULTIMATE v2 by @gde_patrick

local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local rs = game:GetService("RunService")
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.05,0,0.1,0)
frame.Size = UDim2.new(0,260,0,380)
frame.BackgroundColor3 = Color3.fromRGB(40,0,70)
frame.Active, frame.Draggable = true, true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "RobloxLabubuStealer ULTIMATE v2 by @gde_patrick"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundColor3 = Color3.fromRGB(70,0,140)
title.TextScaled = true

local btnY, btnH = 35, 25
local buttons, settings = {}, {
    autoFarm=false, autoBuy=false, autoSell=false, fullAutoPlay=false,
    esp=false, rainbow=false, healthbar=false, lines=false, fps=true,
    color=Color3.fromRGB(255,0,255), minimized=false
}

local function makeButton(text)
    local btn = Instance.new("TextButton", frame)
    btn.Position = UDim2.new(0,0,0,btnY)
    btn.Size = UDim2.new(1,0,0,btnH)
    btn.Text = text..": OFF"
    btnY = btnY + btnH + 5
    return btn
end

buttons.autoFarm = makeButton("AutoFarm")
buttons.autoBuy = makeButton("AutoBuy")
buttons.autoSell = makeButton("AutoSell")
buttons.fullAutoPlay = makeButton("FullAutoPlay")
buttons.esp = makeButton("ESP")
buttons.rainbow = makeButton("RainbowESP")
buttons.healthbar = makeButton("HealthBar")
buttons.lines = makeButton("Lines")

local minimize = Instance.new("TextButton", frame)
minimize.Position = UDim2.new(0,0,1,-25)
minimize.Size = UDim2.new(1,0,0,25)
minimize.Text = "Minimize"

-- Переключатели
for k,btn in pairs(buttons) do
    btn.MouseButton1Click:Connect(function()
        settings[k] = not settings[k]
        btn.Text = btn.Text:match(".*:")..(settings[k] and " ON" or " OFF")
    end)
end

minimize.MouseButton1Click:Connect(function()
    settings.minimized=not settings.minimized
    for _,btn in pairs(buttons) do btn.Visible=not settings.minimized end
    title.Visible=not settings.minimized
    minimize.Text=settings.minimized and "Maximize" or "Minimize"
end)

-- FPS, PING
local info=Instance.new("TextLabel",frame)
info.Position=UDim2.new(0,0,1,-50)
info.Size=UDim2.new(1,0,0,25)
info.BackgroundTransparency=1
info.TextColor3=Color3.fromRGB(255,255,255)
info.TextScaled=true

local fps,ping=0,0
spawn(function()
    while wait(1) do
        fps=math.floor(rs.RenderStepped:Wait() and 1/wait())
        pcall(function() ping=plr:GetNetworkPing()*1000 end)
        info.Text="FPS: "..fps.." | Ping: "..math.floor(ping)
    end
end)

-- Радужный цвет
local function rainbow()
    local t=tick()%5/5
    return Color3.fromHSV(t,1,1)
end

-- ESP и визуалы
spawn(function()
    while wait() do
        if settings.esp then
            for _,p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p~=plr then
                    if not p.Character:FindFirstChild("ESPBill") then
                        local bb=Instance.new("BillboardGui",p.Character)
                        bb.Name="ESPBill";bb.Size=UDim2.new(0,100,0,40);bb.AlwaysOnTop=true
                        local tl=Instance.new("TextLabel",bb)
                        tl.Size=UDim2.new(1,0,1,0)
                        tl.BackgroundTransparency=1;tl.Text="Обезьяна"
                        tl.TextStrokeTransparency=0
                        tl.TextScaled=true
                        bb.StudsOffset=Vector3.new(0,3,0)
                        if settings.healthbar and p.Character:FindFirstChild("Humanoid") then
                            local hb=Instance.new("TextLabel",bb)
                            hb.Name="HB";hb.Size=UDim2.new(1,0,0,10)
                            hb.Position=UDim2.new(0,0,1,0);hb.BackgroundTransparency=0.5
                            hb.BackgroundColor3=Color3.fromRGB(0,255,0)
                        end
                    else
                        local tl=p.Character.ESPBill:FindFirstChildOfClass("TextLabel")
                        tl.TextColor3=settings.rainbow and rainbow() or settings.color
                        if settings.healthbar and p.Character:FindFirstChild("Humanoid") then
                            local hb=p.Character.ESPBill:FindFirstChild("HB")
                            if hb then hb.Size=UDim2.new(p.Character.Humanoid.Health/p.Character.Humanoid.MaxHealth,0,0,10) end
                        end
                    end
                end
            end
        else
            for _,p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("ESPBill") then
                    p.Character.ESPBill:Destroy()
                end
            end
        end
    end
end)

-- Линии
local cam=workspace.CurrentCamera
spawn(function()
    while wait() do
        if settings.lines then
            for _,v in pairs(gui:GetChildren()) do if v:IsA("Frame") and v.Name=="Line" then v:Destroy() end end
            for _,p in pairs(game.Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p~=plr then
                    local a,b=cam:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
                    if b then
                        local l=Instance.new("Frame",gui)
                        l.Name="Line";l.BackgroundColor3=settings.rainbow and rainbow() or settings.color
                        l.BorderSizePixel=0
                        l.Size=UDim2.new(0,2,0,(a.Y-50))
                        l.Position=UDim2.new(0,a.X,0,50)
                    end
                end
            end
        else
            for _,v in pairs(gui:GetChildren()) do if v:IsA("Frame") and v.Name=="Line" then v:Destroy() end end
        end
    end
end)

-- FullAutoPlay
spawn(function()
    while wait(3) do
        if settings.fullAutoPlay then
            local base,price= nil,0
            for _,b in pairs(workspace.Bases:GetChildren()) do
                if b:FindFirstChild("Owner") and b.Owner.Value~=plr.Name and b.Open.Value==true then
                    local v=b:FindFirstChild("Value") and b.Value.Value or 0
                    if v>price then base=b;price=v end
                end
            end
            if base then
                plr.Character.HumanoidRootPart.CFrame=base.PrimaryPart.CFrame+Vector3.new(0,5,0)
                wait(1)
                local my=workspace.Bases:FindFirstChild(plr.Name.."Base")
                if my then plr.Character.HumanoidRootPart.CFrame=my.PrimaryPart.CFrame+Vector3.new(0,5,0) end
            end
        end
    end
end)

-- Подпись
local sign=Instance.new("TextLabel",gui)
sign.Size=UDim2.new(0,200,0,30);sign.Position=UDim2.new(1,-210,1,-40)
sign.Text="@gde_patrick";sign.TextColor3=Color3.fromRGB(255,50,150)
sign.BackgroundTransparency=1;sign.TextStrokeTransparency=0
