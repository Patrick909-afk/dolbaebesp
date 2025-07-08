-- made by @gde_patrick

local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hats = {}
for _,v in pairs(char:GetChildren()) do
    if v:IsA("Accessory") then
        table.insert(hats, v)
    end
end
if #hats == 0 then
    warn("No hats found! Hat fling won't work.")
    return
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "FlingGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 130)
Frame.Position = UDim2.new(0.5, -110, 0.5, -65)
Frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Frame.Active = true
Frame.Draggable = true

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local AutoFlingButton = Instance.new("TextButton", Frame)
AutoFlingButton.Size = UDim2.new(0, 200, 0, 40)
AutoFlingButton.Position = UDim2.new(0,10,0,10)
AutoFlingButton.BackgroundColor3 = Color3.fromRGB(70,130,180)
AutoFlingButton.Text = "AutoFling: OFF"
AutoFlingButton.TextColor3 = Color3.new(1,1,1)
AutoFlingButton.Font = Enum.Font.GothamBold
AutoFlingButton.TextSize = 16

local CloseButton = Instance.new("TextButton", Frame)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200,60,60)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14

local Slider = Instance.new("TextBox", Frame)
Slider.Size = UDim2.new(0, 200, 0, 30)
Slider.Position = UDim2.new(0,10,0,60)
Slider.BackgroundColor3 = Color3.fromRGB(50,50,50)
Slider.Text = "Force: 50000"
Slider.TextColor3 = Color3.new(1,1,1)
Slider.Font = Enum.Font.Gotham
Slider.TextSize = 14
Slider.ClearTextOnFocus = true

local force = 50000
local autofling = false

Slider.FocusLost:Connect(function()
    local num = tonumber(Slider.Text:match("%d+"))
    if num then
        force = num
        Slider.Text = "Force: "..num
    else
        Slider.Text = "Force: "..force
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

AutoFlingButton.MouseButton1Click:Connect(function()
    autofling = not autofling
    AutoFlingButton.Text = "AutoFling: "..(autofling and "ON" or "OFF")
end)

-- антифлинг: убираем физику от других BodyVelocity
game:GetService("RunService").Stepped:Connect(function()
    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyPosition") then
            if v.Name ~= "OurFlingForce" then
                v:Destroy()
            end
        end
    end
end)

-- автофлинг логика
game:GetService("RunService").Heartbeat:Connect(function()
    if autofling then
        for _,player in ipairs(game.Players:GetPlayers()) do
            if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local target = player.Character.HumanoidRootPart
                if (target.Position - char.PrimaryPart.Position).Magnitude < 25 then -- радиус 25
                    for _,hat in ipairs(hats) do
                        local bv = Instance.new("BodyVelocity", hat.Handle)
                        bv.Name = "OurFlingForce"
                        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                        bv.Velocity = (target.Position - char.PrimaryPart.Position).Unit * force
                        game:GetService("Debris"):AddItem(bv, 0.1)
                    end
                end
            end
        end
    end
end)
