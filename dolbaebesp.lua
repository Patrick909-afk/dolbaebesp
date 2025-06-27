-- RobloxESP v13 by @gde_patrick
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RobloxESPv13"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 240)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Text = "RobloxESP v13 by @gde_patrick"
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(60, 0, 80)
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16

local Toggle = Instance.new("TextButton", Frame)
Toggle.Text = "Toggle ESP"
Toggle.Size = UDim2.new(1, -10, 0, 30)
Toggle.Position = UDim2.new(0, 5, 0, 30)
Toggle.BackgroundColor3 = Color3.fromRGB(70,0,120)
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.Font = Enum.Font.SourceSansBold
Toggle.TextSize = 14

local Collapse = Instance.new("TextButton", Frame)
Collapse.Text = "-"
Collapse.Size = UDim2.new(0, 20, 0, 20)
Collapse.Position = UDim2.new(1, -25, 0, 3)
Collapse.BackgroundColor3 = Color3.fromRGB(100,0,150)
Collapse.TextColor3 = Color3.new(1,1,1)

local Collapsed = false
Collapse.MouseButton1Click:Connect(function()
	Collapsed = not Collapsed
	for i,v in ipairs(Frame:GetChildren()) do
		if v ~= Title and v ~= Collapse then
			v.Visible = not Collapsed
		end
	end
	Collapse.Text = Collapsed and "+" or "-"
end)

-- Info labels
local FpsLabel = Instance.new("TextLabel", Frame)
FpsLabel.Text = "FPS: 0"
FpsLabel.Size = UDim2.new(1, -10, 0, 20)
FpsLabel.Position = UDim2.new(0, 5, 0, 70)
FpsLabel.BackgroundTransparency = 1
FpsLabel.TextColor3 = Color3.new(1,1,1)
FpsLabel.Font = Enum.Font.SourceSans
FpsLabel.TextSize = 14

local PingLabel = FpsLabel:Clone()
PingLabel.Parent = Frame
PingLabel.Position = UDim2.new(0, 5, 0, 90)
PingLabel.Text = "Ping: 0"

-- @gde_patrick watermark
local Watermark = Instance.new("TextLabel", ScreenGui)
Watermark.Text = "@gde_patrick"
Watermark.Size = UDim2.new(0,200,0,30)
Watermark.Position = UDim2.new(1, -210, 0, 10)
Watermark.BackgroundTransparency = 1
Watermark.Font = Enum.Font.SourceSansBold
Watermark.TextSize = 20
Watermark.TextColor3 = Color3.new(1,0,0)

-- ESP table
local ESP = {}
local Enabled = true

Toggle.MouseButton1Click:Connect(function()
	Enabled = not Enabled
end)

-- Rainbow
local function rainbowColor(hueOffset)
	return Color3.fromHSV((tick()/2 + hueOffset)%1,1,1)
end

-- Update FPS
local fps = 0
local lastTime = tick()
RunService.RenderStepped:Connect(function()
	local now = tick()
	fps = math.floor(1/(now - lastTime))
	lastTime = now
	FpsLabel.Text = "FPS: "..fps
end)

-- Update Ping
spawn(function()
	while wait(1) do
		local ping = math.floor(LocalPlayer:GetNetworkPing()*1000)
		PingLabel.Text = "Ping: "..ping
	end
end)

-- Create ESP for players
local function createESP(player)
	if player == LocalPlayer then return end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP"
	billboard.Size = UDim2.new(0,100,0,100)
	billboard.Adornee = player.Character and player.Character:FindFirstChild("Head")
	billboard.AlwaysOnTop = true
	billboard.Parent = player.Character

	local nameLabel = Instance.new("TextLabel", billboard)
	nameLabel.Size = UDim2.new(1,0,0,14)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "Обезьяна"
	nameLabel.TextColor3 = Color3.new(1,1,1)
	nameLabel.TextStrokeTransparency = 0
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.TextSize = 14

	local distLabel = Instance.new("TextLabel", billboard)
	distLabel.Position = UDim2.new(0,0,0,14)
	distLabel.Size = UDim2.new(1,0,0,14)
	distLabel.BackgroundTransparency = 1
	distLabel.TextColor3 = Color3.new(1,1,1)
	distLabel.Font = Enum.Font.SourceSans
	distLabel.TextSize = 12

	local healthBar = Instance.new("Frame", billboard)
	healthBar.Size = UDim2.new(0.05,0,1,0)
	healthBar.Position = UDim2.new(-0.06,0,0,0)
	healthBar.BackgroundColor3 = Color3.new(0,1,0)

	local box = Drawing.new("Square")
	box.Thickness = 2
	box.Color = Color3.new(1,0,0)
	box.Filled = false

	local line = Drawing.new("Line")
	line.Thickness = 2
	line.Color = Color3.new(1,1,1)

	ESP[player] = {billboard=billboard, nameLabel=nameLabel, distLabel=distLabel, healthBar=healthBar, box=box, line=line}
end

-- Remove ESP
local function removeESP(player)
	if ESP[player] then
		if ESP[player].box then ESP[player].box:Remove() end
		if ESP[player].line then ESP[player].line:Remove() end
		ESP[player].billboard:Destroy()
		ESP[player]=nil
	end
end

-- Track new players
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		wait(1)
		createESP(player)
	end)
end)

-- Existing players
for _,player in ipairs(Players:GetPlayers()) do
	if player.Character then
		createESP(player)
	end
	player.CharacterAdded:Connect(function()
		wait(1)
		createESP(player)
	end)
end

-- Update loop
RunService.RenderStepped:Connect(function()
	if not Enabled then
		for _,v in pairs(ESP) do
			v.billboard.Enabled = false
			v.box.Visible = false
			v.line.Visible = false
		end
		return
	end
	for player,v in pairs(ESP) do
		if player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
			v.billboard.Enabled = true
			local head = player.Character.Head
			local root = player.Character.HumanoidRootPart

			-- Update rainbow
			local color = rainbowColor(0)
			v.nameLabel.TextColor3 = color
			v.healthBar.BackgroundColor3 = color

			-- HealthBar
			local hp = player.Character:FindFirstChildOfClass("Humanoid").Health
			local max = player.Character:FindFirstChildOfClass("Humanoid").MaxHealth
			v.healthBar.Size = UDim2.new(0.05,0,hp/max,0)

			-- Distance
			local dist = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude)
			v.distLabel.Text = tostring(dist).."m"

			-- Box and Line
			local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(root.Position)
			if onScreen then
				v.box.Position = Vector2.new(pos.X-25,pos.Y-50)
				v.box.Size = Vector2.new(50,100)
				v.box.Color = color
				v.box.Visible = true

				v.line.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X/2,0)
				v.line.To = Vector2.new(pos.X,pos.Y)
				v.line.Color = color
				v.line.Visible = true
			else
				v.box.Visible = false
				v.line.Visible = false
			end
		else
			v.billboard.Enabled = false
			v.box.Visible = false
			v.line.Visible = false
		end
	end
end)
