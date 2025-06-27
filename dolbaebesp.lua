-- RobloxESP v12 by @gde_patrick (финалка)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPColor = Color3.new(1, 0, 0)
local ESPFolder = Instance.new("Folder", game.CoreGui)
ESPFolder.Name = "patrick_esp"

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "RobloxESPv12"

-- UI
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

local Options = {
	BoxESP = true,
	HealthBar = true,
	Distance = true,
	Tracers = true,
	NameESP = true,
}
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
	y += 25
end

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

local IsMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
	IsMinimized = not IsMinimized
	for _,btn in pairs(ToggleButtons) do btn.Visible = not IsMinimized end
	Stats.Visible = not IsMinimized
	ColorBox.Visible = not IsMinimized
	Title.Visible = not IsMinimized
	MainFrame.Size = IsMinimized and UDim2.new(0, 120, 0, 30) or UDim2.new(0, 250, 0, 320)
	MinimizeBtn.Text = IsMinimized and "☰" or "_"
end)

local function createESP(plr)
	if plr == LocalPlayer then return end

	local function refresh()
		if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
		local HRP = plr.Character.HumanoidRootPart

		local box = Instance.new("BoxHandleAdornment", ESPFolder)
		box.Adornee = HRP
		box.Size = Vector3.new(4,6,2)
		box.Color3 = ESPColor
		box.AlwaysOnTop = true
		box.ZIndex = 5
		box.Transparency = 0.3
		box.Name = plr.Name.."_Box"

		local line = Instance.new("Beam", ESPFolder)
		local at0 = Instance.new("Attachment", workspace.CurrentCamera)
		local at1 = Instance.new("Attachment", HRP)
		line.Attachment0 = at0
		line.Attachment1 = at1
		line.Color = ColorSequence.new(ESPColor)
		line.Width0 = 0.05
		line.Width1 = 0.05
		line.FaceCamera = true
		line.Name = plr.Name.."_Line"

		local gui = Instance.new("BillboardGui", ESPFolder)
		gui.Adornee = plr.Character:WaitForChild("Head")
		gui.Size = UDim2.new(0,100,0,40)
		gui.AlwaysOnTop = true
		gui.Name = plr.Name.."_Name"

		local name = Instance.new("TextLabel", gui)
		name.Position = UDim2.new(0,0,0,-10)
		name.Size = UDim2.new(1,0,0,20)
		name.Text = "Обезьяна"
		name.TextColor3 = ESPColor
		name.BackgroundTransparency = 1
		name.Font = Enum.Font.SourceSansBold
		name.TextSize = 14

		local dist = Instance.new("TextLabel", gui)
		dist.Position = UDim2.new(0,0,0,20)
		dist.Size = UDim2.new(1,0,0,20)
		dist.TextColor3 = ESPColor
		dist.BackgroundTransparency = 1
		dist.Font = Enum.Font.SourceSans
		dist.TextSize = 12

		RunService.RenderStepped:Connect(function()
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local d = (LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
				dist.Text = Options.Distance and string.format("Dist: %.0f", d) or ""
				name.Text = Options.NameESP and "Обезьяна" or ""
				box.Visible = Options.BoxESP
				line.Enabled = Options.Tracers
				box.Color3 = ESPColor
				line.Color = ColorSequence.new(ESPColor)
				name.TextColor3 = ESPColor
				dist.TextColor3 = ESPColor
			end
		end)
	end

	refresh()
	plr.CharacterAdded:Connect(function()
		wait(1)
		for _,v in pairs(ESPFolder:GetChildren()) do
			if string.find(v.Name, plr.Name) then v:Destroy() end
		end
		refresh()
	end)
end

for _,p in pairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		createESP(p)
	end
end
Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(1)
		createESP(p)
	end)
end)

-- подпись
local Tag = Instance.new("TextLabel", ScreenGui)
Tag.Size = UDim2.new(0,200,0,30)
Tag.Position = UDim2.new(0.5,-100,0,0)
Tag.BackgroundTransparency = 1
Tag.Text = "@gde_patrick"
Tag.Font = Enum.Font.SourceSansBold
Tag.TextSize = 24
Tag.TextStrokeTransparency = 0.3
Tag.TextColor3 = Color3.new(1,0,0)
