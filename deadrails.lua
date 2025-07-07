local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI helper
local function createMenu(name, ypos)
    local gui = Instance.new("ScreenGui", plr.PlayerGui)
    gui.ResetOnSpawn = false
    local frame = Instance.new("Frame", gui)
    frame.BackgroundColor3 = Color3.fromRGB(0,255,0)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Size = UDim2.new(0, 200, 0, 60)
    frame.Position = UDim2.new(0, 100, 0, ypos)

    local title = Instance.new("TextLabel", frame)
    title.Text = name
    title.TextColor3 = Color3.fromRGB(0,255,0)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 18
    title.Size = UDim2.new(1,0,0,20)
    title.BackgroundTransparency = 1

    local toggle = Instance.new("TextButton", frame)
    toggle.Text = name.." OFF"
    toggle.TextColor3 = Color3.fromRGB(0,255,0)
    toggle.Font = Enum.Font.SourceSansBold
    toggle.TextSize = 16
    toggle.Size = UDim2.new(0.5,0,0,20)
    toggle.Position = UDim2.new(0,0,0,20)
    toggle.BackgroundTransparency = 1

    local speedLabel = Instance.new("TextLabel", frame)
    speedLabel.Text = "Speed: 30"
    speedLabel.TextColor3 = Color3.fromRGB(0,255,0)
    speedLabel.Font = Enum.Font.SourceSansBold
    speedLabel.TextSize = 16
    speedLabel.Size = UDim2.new(0.5,0,0,20)
    speedLabel.Position = UDim2.new(0.5,0,0,20)
    speedLabel.BackgroundTransparency = 1

    local plus = Instance.new("TextButton", frame)
    plus.Text = "+"
    plus.TextColor3 = Color3.fromRGB(0,255,0)
    plus.Font = Enum.Font.SourceSansBold
    plus.TextSize = 18
    plus.Size = UDim2.new(0.5,0,0,20)
    plus.Position = UDim2.new(0,0,0,40)
    plus.BackgroundTransparency = 1

    local minus = Instance.new("TextButton", frame)
    minus.Text = "-"
    minus.TextColor3 = Color3.fromRGB(0,255,0)
    minus.Font = Enum.Font.SourceSansBold
    minus.TextSize = 18
    minus.Size = UDim2.new(0.5,0,0,20)
    minus.Position = UDim2.new(0.5,0,0,40)
    minus.BackgroundTransparency = 1

    return {toggle=toggle, speedLabel=speedLabel, plus=plus, minus=minus, frame=frame, gui=gui}
end

-- Fly
local flyUI = createMenu("Patrick Fly", 300)
local flying = false
local flySpeed = 30

flyUI.toggle.MouseButton1Click:Connect(function()
    flying = not flying
    flyUI.toggle.Text = "Patrick Fly "..(flying and "ON" or "OFF")

    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        local bg = Instance.new("BodyGyro", hrp)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
        while flying do
            bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
            bg.CFrame = workspace.CurrentCamera.CFrame
            task.wait()
        end
        bv:Destroy()
        bg:Destroy()
    end
end)

flyUI.plus.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 5
    flyUI.speedLabel.Text = "Speed: "..flySpeed
end)
flyUI.minus.MouseButton1Click:Connect(function()
    flySpeed = math.max(5, flySpeed - 5)
    flyUI.speedLabel.Text = "Speed: "..flySpeed
end)

-- NoClip
local noclipUI = createMenu("Patrick NoClip", 370)
local noclipping = false
local noclipSpeed = 30

noclipUI.toggle.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    noclipUI.toggle.Text = "Patrick NoClip "..(noclipping and "ON" or "OFF")

    if noclipping then
        while noclipping do
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide == true then
                    v.CanCollide = false
                end
            end
            -- двигаться вперёд при нажатии
            hrp.Velocity = workspace.CurrentCamera.CFrame.LookVector * noclipSpeed
            task.wait()
        end
    else
        -- вернуть коллизии
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = true
            end
        end
    end
end)

noclipUI.plus.MouseButton1Click:Connect(function()
    noclipSpeed = noclipSpeed + 5
    noclipUI.speedLabel.Text = "Speed: "..noclipSpeed
end)
noclipUI.minus.MouseButton1Click:Connect(function()
    noclipSpeed = math.max(5, noclipSpeed - 5)
    noclipUI.speedLabel.Text = "Speed: "..noclipSpeed
end)
