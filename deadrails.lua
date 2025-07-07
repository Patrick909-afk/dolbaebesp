local main = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local up = Instance.new("TextButton")
local down = Instance.new("TextButton")
local toggleFly = Instance.new("TextButton")
local title = Instance.new("TextLabel")
local plus = Instance.new("TextButton")
local speedLabel = Instance.new("TextLabel")
local minus = Instance.new("TextButton")
local close = Instance.new("TextButton")
local minimize = Instance.new("TextButton")
local expand = Instance.new("TextButton")

local flying = false
local speed = 1
local player = game.Players.LocalPlayer
local hrp = player.Character:WaitForChild("HumanoidRootPart")
local bv = Instance.new("BodyVelocity")
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Velocity = Vector3.new(0, 0, 0)
bv.Parent = hrp

main.Name = "PatrickFly"
main.Parent = player:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

Frame.Parent = main
Frame.BackgroundColor3 = Color3.fromRGB(57, 255, 20)
Frame.Position = UDim2.new(0.1, 0, 0.4, 0)
Frame.Size = UDim2.new(0, 190, 0, 57)
Frame.Draggable = true
Frame.Active = true

title.Parent = Frame
title.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
title.Size = UDim2.new(0, 100, 0, 28)
title.Position = UDim2.new(0.48, 0, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.Text = "Patrick Fly"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.TextScaled = true

up.Name = "up"
up.Parent = Frame
up.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
up.Size = UDim2.new(0, 44, 0, 28)
up.Font = Enum.Font.SourceSans
up.Text = "UP"
up.TextColor3 = Color3.fromRGB(0, 0, 0)
up.TextSize = 14

down.Name = "down"
down.Parent = Frame
down.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
down.Position = UDim2.new(0, 0, 0.5, 0)
down.Size = UDim2.new(0, 44, 0, 28)
down.Font = Enum.Font.SourceSans
down.Text = "DOWN"
down.TextColor3 = Color3.fromRGB(0, 0, 0)
down.TextSize = 14

toggleFly.Name = "toggleFly"
toggleFly.Parent = Frame
toggleFly.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
toggleFly.Position = UDim2.new(0.7, 0, 0.5, 0)
toggleFly.Size = UDim2.new(0, 56, 0, 28)
toggleFly.Font = Enum.Font.SourceSans
toggleFly.Text = "fly"
toggleFly.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleFly.TextSize = 14

plus.Name = "plus"
plus.Parent = Frame
plus.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
plus.Position = UDim2.new(0.23, 0, 0, 0)
plus.Size = UDim2.new(0, 45, 0, 28)
plus.Font = Enum.Font.SourceSans
plus.Text = "+"
plus.TextColor3 = Color3.fromRGB(0, 0, 0)
plus.TextScaled = true

speedLabel.Name = "speed"
speedLabel.Parent = Frame
speedLabel.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
speedLabel.Position = UDim2.new(0.48, 0, 0.5, 0)
speedLabel.Size = UDim2.new(0, 44, 0, 28)
speedLabel.Font = Enum.Font.SourceSans
speedLabel.Text = tostring(speed)
speedLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
speedLabel.TextScaled = true

minus.Name = "minus"
minus.Parent = Frame
minus.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
minus.Position = UDim2.new(0.23, 0, 0.5, 0)
minus.Size = UDim2.new(0, 45, 0, 28)
minus.Font = Enum.Font.SourceSans
minus.Text = "-"
minus.TextColor3 = Color3.fromRGB(0, 0, 0)
minus.TextScaled = true

close.Name = "close"
close.Parent = Frame
close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
close.Size = UDim2.new(0, 45, 0, 28)
close.Font = Enum.Font.SourceSans
close.Text = "X"
close.TextSize = 20
close.Position = UDim2.new(0, 0, -1, 27)

minimize.Name = "minimize"
minimize.Parent = Frame
minimize.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
minimize.Size = UDim2.new(0, 45, 0, 28)
minimize.Text = "-"
minimize.Position = UDim2.new(0, 44, -1, 27)

expand.Name = "expand"
expand.Parent = Frame
expand.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
expand.Size = UDim2.new(0, 45, 0, 28)
expand.Text = "+"
expand.Position = UDim2.new(0, 44, -1, 57)
expand.Visible = false

-- Полёт
toggleFly.MouseButton1Click:Connect(function()
	flying = not flying
	bv.MaxForce = flying and Vector3.new(9e9, 9e9, 9e9) or Vector3.new(0, 0, 0)
end)

plus.MouseButton1Click:Connect(function()
	speed = speed + 1
	speedLabel.Text = tostring(speed)
end)

minus.MouseButton1Click:Connect(function()
	if speed > 1 then
		speed = speed - 1
		speedLabel.Text = tostring(speed)
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if flying then
		bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
	else
		bv.Velocity = Vector3.new(0, 0, 0)
	end
end)

up.MouseButton1Click:Connect(function()
	hrp.CFrame = hrp.CFrame * CFrame.new(0, 2, 0)
end)

down.MouseButton1Click:Connect(function()
	hrp.CFrame = hrp.CFrame * CFrame.new(0, -2, 0)
end)

close.MouseButton1Click:Connect(function()
	main:Destroy()
end)

minimize.MouseButton1Click:Connect(function()
	for _,v in pairs(Frame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") then
			v.Visible = false
		end
	end
	expand.Visible = true
end)

expand.MouseButton1Click:Connect(function()
	for _,v in pairs(Frame:GetChildren()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") then
			v.Visible = true
		end
	end
	expand.Visible = false
end)

-- ESP поездов
for _, train in pairs(workspace:GetDescendants()) do
	if train:IsA("Model") and train.Name == "Train" then
		local billboard = Instance.new("BillboardGui", train)
		billboard.Size = UDim2.new(0,100,0,20)
		billboard.Adornee = train:FindFirstChild("PrimaryPart") or train:FindFirstChildWhichIsA("BasePart")
		local text = Instance.new("TextLabel", billboard)
		text.BackgroundTransparency = 1
		text.Text = "TRAIN"
		text.TextColor3 = Color3.fromRGB(0,255,0)
		text.TextScaled = true
		text.Font = Enum.Font.SourceSansBold
	end
end
