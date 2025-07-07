local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- ESP поездов
local function createTrainESP(train)
    local billboard = Instance.new("BillboardGui", train)
    billboard.Size = UDim2.new(0,100,0,40)
    billboard.AlwaysOnTop = true
    local text = Instance.new("TextLabel", billboard)
    text.BackgroundTransparency = 1
    text.Text = "🚂 Train"
    text.TextColor3 = Color3.fromRGB(0,255,0)
    text.TextStrokeTransparency = 0
    text.TextScaled = true
end
for _,v in ipairs(Workspace:GetDescendants()) do
    if v.Name:lower():find("train") then
        createTrainESP(v)
    end
end
Workspace.DescendantAdded:Connect(function(v)
    if v.Name:lower():find("train") then
        createTrainESP(v)
    end
end)

------------------------------------------------------------
-- Patrick Fly меню
------------------------------------------------------------
local flyGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
flyGui.Name = "PatrickFlyGUI"
local flyFrame = Instance.new("Frame", flyGui)
flyFrame.Size = UDim2.new(0,200,0,100)
flyFrame.Position = UDim2.new(0.05,0,0.4,0)
flyFrame.BackgroundColor3 = Color3.fromRGB(0,255,0)
flyFrame.Active = true
flyFrame.Draggable = true

local flyTitle = Instance.new("TextLabel", flyFrame)
flyTitle.Text = "Patrick Fly"
flyTitle.Size = UDim2.new(1,0,0,20)
flyTitle.BackgroundTransparency = 1
flyTitle.TextColor3 = Color3.fromRGB(0,255,0)

local flyOn = Instance.new("TextButton", flyFrame)
flyOn.Text = "Fly: OFF"
flyOn.Position = UDim2.new(0,0,0,25)
flyOn.Size = UDim2.new(0.5,0,0,25)

local plus = Instance.new("TextButton", flyFrame)
plus.Text = "+"
plus.Position = UDim2.new(0,0,0,55)
plus.Size = UDim2.new(0.25,0,0,25)

local minus = Instance.new("TextButton", flyFrame)
minus.Text = "-"
minus.Position = UDim2.new(0.25,0,0,55)
minus.Size = UDim2.new(0.25,0,0,25)

local speedLabel = Instance.new("TextLabel", flyFrame)
speedLabel.Text = "Speed: 1"
speedLabel.Position = UDim2.new(0.5,0,0,55)
speedLabel.Size = UDim2.new(0.5,0,0,25)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(0,255,0)

------------------------------------------------------------
-- Patrick NoClip меню
------------------------------------------------------------
local clipGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
clipGui.Name = "PatrickNoClipGUI"
local clipFrame = Instance.new("Frame", clipGui)
clipFrame.Size = UDim2.new(0,200,0,100)
clipFrame.Position = UDim2.new(0.05,0,0.55,0)
clipFrame.BackgroundColor3 = Color3.fromRGB(0,255,0)
clipFrame.Active = true
clipFrame.Draggable = true

local clipTitle = Instance.new("TextLabel", clipFrame)
clipTitle.Text = "Patrick NoClip"
clipTitle.Size = UDim2.new(1,0,0,20)
clipTitle.BackgroundTransparency = 1
clipTitle.TextColor3 = Color3.fromRGB(0,255,0)

local clipOn = Instance.new("TextButton", clipFrame)
clipOn.Text = "NoClip: OFF"
clipOn.Position = UDim2.new(0,0,0,25)
clipOn.Size = UDim2.new(0.5,0,0,25)

local cplus = Instance.new("TextButton", clipFrame)
cplus.Text = "+"
cplus.Position = UDim2.new(0,0,0,55)
cplus.Size = UDim2.new(0.25,0,0,25)

local cminus = Instance.new("TextButton", clipFrame)
cminus.Text = "-"
cminus.Position = UDim2.new(0.25,0,0,0,55)
cminus.Size = UDim2.new(0.25,0,0,25)

local cspeedLabel = Instance.new("TextLabel", clipFrame)
cspeedLabel.Text = "Speed: 1"
cspeedLabel.Position = UDim2.new(0.5,0,0,55)
cspeedLabel.Size = UDim2.new(0.5,0,0,25)
cspeedLabel.BackgroundTransparency = 1
cspeedLabel.TextColor3 = Color3.fromRGB(0,255,0)

------------------------------------------------------------
-- Fly логика
------------------------------------------------------------
local flySpeed = 1
local flying = false
local flyBV, flyBG

local function startFly()
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart")
    flyBV = Instance.new("BodyVelocity", root)
    flyBV.Velocity = Vector3.zero
    flyBV.MaxForce = Vector3.new(9e9,9e9,9e9)
    flyBG = Instance.new("BodyGyro", root)
    flyBG.CFrame = Workspace.CurrentCamera.CFrame
    flyBG.MaxTorque = Vector3.new(9e9,9e9,9e9)
    RunService.RenderStepped:Connect(function()
        if flying then
            flyBV.Velocity = Workspace.CurrentCamera.CFrame.LookVector * flySpeed*5
            flyBG.CFrame = Workspace.CurrentCamera.CFrame
        end
    end)
end

flyOn.MouseButton1Click:Connect(function()
    flying = not flying
    flyOn.Text = "Fly: "..(flying and "ON" or "OFF")
    if flying then startFly() else
        if flyBV then flyBV:Destroy() end
        if flyBG then flyBG:Destroy() end
    end
end)
plus.MouseButton1Click:Connect(function()
    flySpeed = flySpeed + 1
    speedLabel.Text = "Speed: "..flySpeed
end)
minus.MouseButton1Click:Connect(function()
    flySpeed = math.max(1, flySpeed - 1)
    speedLabel.Text = "Speed: "..flySpeed
end)

------------------------------------------------------------
-- NoClip логика
------------------------------------------------------------
local clipSpeed = 1
local noclipping = false

clipOn.MouseButton1Click:Connect(function()
    noclipping = not noclipping
    clipOn.Text = "NoClip: "..(noclipping and "ON" or "OFF")
    RunService.Stepped:Connect(function()
        if noclipping then
            for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)
cplus.MouseButton1Click:Connect(function()
    clipSpeed = clipSpeed + 1
    cspeedLabel.Text = "Speed: "..clipSpeed
end)
cminus.MouseButton1Click:Connect(function()
    clipSpeed = math.max(1, clipSpeed - 1)
    cspeedLabel.Text = "Speed: "..clipSpeed
end)
