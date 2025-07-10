-- made by chatgpt special for Delta X
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Toggle = Instance.new("TextButton")
local SpeedLabel = Instance.new("TextLabel")
local SpeedSlider = Instance.new("TextBox")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "FreeCamGUI"

Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

Toggle.Size = UDim2.new(0, 180, 0, 30)
Toggle.Position = UDim2.new(0, 10, 0, 10)
Toggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Toggle.Text = "Freecam: OFF"
Toggle.Parent = Frame

SpeedLabel.Size = UDim2.new(0, 60, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 50)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextColor3 = Color3.fromRGB(255,255,255)
SpeedLabel.Text = "Speed:"
SpeedLabel.Parent = Frame

SpeedSlider.Size = UDim2.new(0, 100, 0, 20)
SpeedSlider.Position = UDim2.new(0, 70, 0, 50)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
SpeedSlider.Text = "1"
SpeedSlider.Parent = Frame

-- freecam logic
local freecamEnabled = false
local speed = 1

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local camCF = camera.CFrame

local function updateFreecam()
    if freecamEnabled then
        camera.CameraType = Enum.CameraType.Scriptable
        camera.CFrame = camCF
    else
        camera.CameraType = Enum.CameraType.Custom
    end
end

Toggle.MouseButton1Click:Connect(function()
    freecamEnabled = not freecamEnabled
    Toggle.Text = freecamEnabled and "Freecam: ON" or "Freecam: OFF"
    updateFreecam()
end)

SpeedSlider.FocusLost:Connect(function()
    local value = tonumber(SpeedSlider.Text)
    if value then
        speed = value
    else
        SpeedSlider.Text = tostring(speed)
    end
end)

local moveVector = Vector3.new()
local function getInput()
    local move = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0,0,-1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0,0,1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1,0,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1,0,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.E) then move = move + Vector3.new(0,1,0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then move = move + Vector3.new(0,-1,0) end
    return move
end

UserInputService.InputChanged:Connect(function(input)
    if freecamEnabled and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Delta
        local rot = CFrame.Angles(0, -delta.X*0.002, 0) * CFrame.Angles(-delta.Y*0.002, 0, 0)
        camCF = rot * camCF
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if freecamEnabled then
        local move = getInput()
        camCF = camCF + camCF.LookVector * move.Z * speed * dt
        camCF = camCF + camCF.RightVector * move.X * speed * dt
        camCF = camCF + camCF.UpVector * move.Y * speed * dt
        camera.CFrame = camCF
    end
end)

print("✅ Freecam loaded!")
