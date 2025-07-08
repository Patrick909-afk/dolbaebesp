-- Fling Script with invisible part & GUI
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") or nil

-- создаём невидимую fling деталь
local flingPart = Instance.new("Part")
flingPart.Size = Vector3.new(5,5,5)
flingPart.Transparency = 1
flingPart.Anchored = false
flingPart.CanCollide = true
flingPart.Massless = true
flingPart.Name = "FlingPart"
flingPart.Parent = workspace

-- Привязать flingPart к персонажу
local weld = Instance.new("WeldConstraint")
weld.Part0 = hrp
weld.Part1 = flingPart
weld.Parent = flingPart

-- AngularVelocity для вращения
local av = Instance.new("BodyAngularVelocity")
av.AngularVelocity = Vector3.new(0,50000,0) -- 50000 по Y
av.MaxTorque = Vector3.new(1e9,1e9,1e9)
av.P = 1250
av.Parent = flingPart

-- GUI
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "FlingGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,150,0,50)
frame.Position = UDim2.new(0.5,-75,0.1,0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true

local flingBtn = Instance.new("TextButton", frame)
flingBtn.Size = UDim2.new(0.7,0,1,0)
flingBtn.Position = UDim2.new(0,0,0,0)
flingBtn.Text = "FLING"
flingBtn.BackgroundColor3 = Color3.fromRGB(80,200,80)
flingBtn.TextColor3 = Color3.new(1,1,1)

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0.3,0,1,0)
closeBtn.Position = UDim2.new(0.7,0,0,0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)
closeBtn.TextColor3 = Color3.new(1,1,1)

-- при нажатии включить вращение (уже включено, но перезапустим)
flingBtn.MouseButton1Click:Connect(function()
    av.AngularVelocity = Vector3.new(0,50000,0)
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    flingPart:Destroy()
end)

print("Fling script loaded. Подойди к игроку, нажми Fling и он улетит!")
