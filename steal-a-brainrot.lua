local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- создаём группу коллизий
pcall(function()
    PhysicsService:CreateCollisionGroup("FlingGroup")
    PhysicsService:CollisionGroupSetCollidable("FlingGroup", "Default", true)
end)

local function createFlingPart()
    local part = Instance.new("Part")
    part.Name = "FlingPart"
    part.Size = Vector3.new(5,5,5)
    part.Transparency = 1
    part.Anchored = false
    part.CanCollide = true
    part.Massless = true
    PhysicsService:SetPartCollisionGroup(part, "FlingGroup")
    part.Parent = workspace
    local av = Instance.new("BodyAngularVelocity")
    av.AngularVelocity = Vector3.new(0,0,0)
    av.MaxTorque = Vector3.new(1e9,1e9,1e9)
    av.P = 1250
    av.Parent = part
    return part, av
end

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

local flingActive = false
local flingPart, av = createFlingPart()

-- держим flingPart впереди и выше
RunService.Heartbeat:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and flingPart then
        local hrp = lp.Character.HumanoidRootPart
        flingPart.Position = hrp.Position + hrp.CFrame.LookVector * 6 + Vector3.new(0,3,0)
    end
end)

-- при смерти пересоздать flingPart
lp.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(0.2)
    if flingPart then flingPart:Destroy() end
    flingPart, av = createFlingPart()
end)

-- при нажатии включаем вращение
flingBtn.MouseButton1Click:Connect(function()
    flingActive = not flingActive
    if flingActive then
        av.AngularVelocity = Vector3.new(0,50000,0)
        flingBtn.Text = "ON"
        flingBtn.BackgroundColor3 = Color3.fromRGB(100,255,100)
    else
        av.AngularVelocity = Vector3.new(0,0,0)
        flingBtn.Text = "FLING"
        flingBtn.BackgroundColor3 = Color3.fromRGB(80,200,80)
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    if flingPart then flingPart:Destroy() end
end)

print("✅ Loaded! Подходи к игрокам, включи FLING и смотри как их кидает, а тебя не трогает.")
