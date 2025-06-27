-- RobloxESP v12 by @gde_patrick
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RobloxESPv12"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 320)
MainFrame.Position = UDim2.new(0, 100, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -30, 0, 30)
Title.Text = "RobloxESP v12 by @gde_patrick"
Title.TextColor3 = Color3.fromRGB(255, 0, 100)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeBtn = Instance.new("TextButton", MainFrame)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.Text = "_"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
MinimizeBtn.TextColor3 = Color3.new(1,1,1)

local IsMinimized = false
local Options = {
    BoxESP = true,
    HealthBar = true,
    Distance = true,
    Tracers = true,
    NameESP = true,
}

-- Цвет ESP
local ESPColor = Color3.new(1,0,0)
local ColorBox = Instance.new("TextBox", MainFrame)
ColorBox.Size = UDim2.new(1, 0, 0, 25)
ColorBox.Position = UDim2.new(0,0,0,30)
ColorBox.Text = "255,0,0"
ColorBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
ColorBox.TextColor3 = Color3.new(1,1,1)
ColorBox.TextSize = 14

ColorBox.FocusLost:Connect(function()
    local r,g,b = string.match(ColorBox.Text,"(%d+),(%d+),(%d+)")
    if r and g and b then
        ESPColor = Color3.fromRGB(tonumber(r),tonumber(g),tonumber(b))
    end
end)

local ToggleButtons = {}
local y = 55
for name,_ in pairs(Options) do
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

-- FPS
local Stats = Instance.new("TextLabel", MainFrame)
Stats.Position = UDim2.new(0,0,1,-20)
Stats.Size = UDim2.new(1,0,0,20)
Stats.BackgroundTransparency = 1
Stats.TextColor3 = Color3.new(1,1,1)
Stats.Font = Enum.Font.SourceSans
Stats.TextSize = 14

RunService.RenderStepped:Connect(function()
    local fps = math.floor(1 / RunService.RenderStepped:Wait())
    Stats.Text = "FPS: "..fps
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    IsMinimized = not IsMinimized
    if IsMinimized then
        for _,btn in pairs(ToggleButtons) do btn.Visible = false end
        Stats.Visible = false
        ColorBox.Visible = false
        Title.Visible = false
        MainFrame.Size = UDim2.new(0, 120, 0, 30)
        MinimizeBtn.Text = "☰"
    else
        for _,btn in pairs(ToggleButtons) do btn.Visible = true end
        Stats.Visible = true
        ColorBox.Visible = true
        Title.Visible = true
        MainFrame.Size = UDim2.new(0, 250, 0, 320)
        MinimizeBtn.Text = "_"
    end
end)

-- ESP
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "patrick_esp"

local function create3DBox(plr)
    if plr == LocalPlayer then return end
    local box = Instance.new("BoxHandleAdornment", ESPFolder)
    box.Adornee = plr.Character:WaitForChild("HumanoidRootPart")
    box.Size = Vector3.new(4,6,2)
    box.Color3 = ESPColor
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Transparency = 0.3
    box.Name = plr.Name.."_Box"

    local Billboard = Instance.new("BillboardGui", ESPFolder)
    Billboard.Name = plr.Name.."_Name"
    Billboard.Adornee = plr.Character:WaitForChild("Head")
    Billboard.Size = UDim2.new(0,100,0,40)
    Billboard.AlwaysOnTop = true

    local Name = Instance.new("TextLabel", Billboard)
    Name.Position = UDim2.new(0,0,0,-10)
    Name.Size = UDim2.new(1,0,0,20)
    Name.Text = "Обезьяна"
    Name.TextColor3 = ESPColor
    Name.BackgroundTransparency = 1
    Name.Font = Enum.Font.SourceSansBold
    Name.TextSize = 14

    local Distance = Instance.new("TextLabel", Billboard)
    Distance.Position = UDim2.new(0,0,0,20)
    Distance.Size = UDim2.new(1,0,0,20)
    Distance.TextColor3 = ESPColor
    Distance.BackgroundTransparency = 1
    Distance.Font = Enum.Font.SourceSans
    Distance.TextSize = 12

    RunService.RenderStepped:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            Distance.Text = Options.Distance and string.format("Distance: %.0f", dist) or ""
            Name.Text = Options.NameESP and "Обезьяна" or ""
            box.Visible = Options.BoxESP
            box.Color3 = ESPColor
            Name.TextColor3 = ESPColor
            Distance.TextColor3 = ESPColor
        end
    end)
end

for _,p in pairs(Players:GetPlayers()) do
    if p.Character then create3DBox(p) end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        create3DBox(p)
    end)
end)

-- подпись сверху
local TextLabel = Instance.new("TextLabel", ScreenGui)
TextLabel.Size = UDim2.new(0,200,0,30)
TextLabel.Position = UDim2.new(0.5,-100,0,0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "@gde_patrick"
TextLabel.Font = Enum.Font.SourceSansBold
TextLabel.TextSize = 24
TextLabel.TextStrokeTransparency = 0.3
TextLabel.TextColor3 = Color3.new(1,0,0)
