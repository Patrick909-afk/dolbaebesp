-- RobloxESP v12 by @gde_patrick

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RobloxESPv12"
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 270)
MainFrame.Position = UDim2.new(0, 100, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "RobloxESP v12 by @gde_patrick"
Title.TextColor3 = Color3.fromRGB(255, 0, 100)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

local ToggleButtons = {}
local Options = {
    BoxESP = true,
    HealthBar = true,
    Distance = true,
    Tracers = true,
    NameChange = true
}

-- свернуть / развернуть
local IsMinimized = false
local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.Text = "_"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    for _,btn in pairs(ToggleButtons) do
        btn.Visible = not IsMinimized
    end
    Title.Visible = not IsMinimized
end)

-- FPS + Ping
local Stats = Instance.new("TextLabel", MainFrame)
Stats.Position = UDim2.new(0,0,1,-20)
Stats.Size = UDim2.new(1,0,0,20)
Stats.BackgroundTransparency = 1
Stats.TextColor3 = Color3.new(1,1,1)
Stats.Font = Enum.Font.SourceSans
Stats.TextSize = 14
Stats.Text = "FPS: 0 | Ping: 0ms"

RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    local ping = game:GetService("Stats"):FindFirstChild("Network"):FindFirstChild("Ping").Value
    Stats.Text = "FPS: "..fps.." | Ping: "..math.floor(ping).."ms"
end)

-- создать кнопки
local y = 30
for name, state in pairs(Options) do
    local btn = Instance.new("TextButton", MainFrame)
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0,0,0,y)
    btn.Text = name.." : ON"
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(function()
        Options[name] = not Options[name]
        btn.Text = name.." : "..(Options[name] and "ON" or "OFF")
    end)
    table.insert(ToggleButtons, btn)
    y = y + 25
end

-- rainbow effect
local function RainbowColor()
    local hue = tick() % 5 / 5
    return Color3.fromHSV(hue, 1, 1)
end

-- ESP
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "patrick_esp"

local function createESP(plr)
    if plr == LocalPlayer then return end
    local Billboard = Instance.new("BillboardGui", ESPFolder)
    Billboard.Name = plr.Name.."_ESP"
    Billboard.Adornee = plr.Character:WaitForChild("Head")
    Billboard.Size = UDim2.new(0,100,0,40)
    Billboard.AlwaysOnTop = true

    local Name = Instance.new("TextLabel", Billboard)
    Name.Size = UDim2.new(1,0,0,20)
    Name.Text = "Обезьяна"
    Name.TextColor3 = RainbowColor()
    Name.BackgroundTransparency = 1
    Name.Font = Enum.Font.SourceSansBold
    Name.TextStrokeTransparency = 0
    Name.TextSize = 14

    local Distance = Instance.new("TextLabel", Billboard)
    Distance.Position = UDim2.new(0,0,0,20)
    Distance.Size = UDim2.new(1,0,0,20)
    Distance.TextColor3 = RainbowColor()
    Distance.BackgroundTransparency = 1
    Distance.Font = Enum.Font.SourceSans
    Distance.TextSize = 12

    RunService.RenderStepped:Connect(function()
        if Options.NameChange then
            Name.Text = "Обезьяна"
        else
            Name.Text = plr.Name
        end
        if Options.Distance then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            Distance.Text = string.format("Distance: %.0f", dist)
        else
            Distance.Text = ""
        end
        Name.TextColor3 = RainbowColor()
        Distance.TextColor3 = RainbowColor()
    end)
end

for _,p in pairs(Players:GetPlayers()) do
    if p.Character then
        createESP(p)
    end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        createESP(p)
    end)
end)

-- tracers
RunService.RenderStepped:Connect(function()
    if not Options.Tracers then return end
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- линии не рисую кодом, т.к. нужно Drawing API, а это уже другой скрипт
        end
    end
end)

-- надпись @gde_patrick
local TextLabel = Instance.new("TextLabel", ScreenGui)
TextLabel.Size = UDim2.new(0,200,0,30)
TextLabel.Position = UDim2.new(0.5,-100,0,0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "@gde_patrick"
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 24
TextLabel.TextStrokeTransparency = 0.3

RunService.RenderStepped:Connect(function()
    TextLabel.TextColor3 = RainbowColor()
end)
