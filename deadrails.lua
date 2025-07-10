-- Freecam GUI
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local cam = workspace.CurrentCamera

local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FreecamGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true

local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.8, 0, 0, 40)
toggleBtn.Position = UDim2.new(0.1,0,0.2,0)
toggleBtn.Text = "Freecam: OFF"

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0.2, 0, 0, 30)
closeBtn.Position = UDim2.new(0.8,0,0,0)
closeBtn.Text = "✖"

local flying = false
local speed = 1
local sensitivity = 0.3
local rotation = Vector2.new()

local keys = {}

UIS.InputBegan:Connect(function(input, gpe)
	if not gpe then
		keys[input.KeyCode] = true
	end
end)

UIS.InputEnded:Connect(function(input, gpe)
	if not gpe then
		keys[input.KeyCode] = false
	end
end)

local conn
local function startFreecam()
	flying = true
	toggleBtn.Text = "Freecam: ON"
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CFrame = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.CFrame or cam.CFrame
	mouse.Icon = "rbxasset://SystemCursors/Cross"

	local lastMousePos = Vector2.new(mouse.X, mouse.Y)
	
	conn = RS.RenderStepped:Connect(function(dt)
		-- Mouse rotation
		local delta = Vector2.new(mouse.X, mouse.Y) - lastMousePos
		lastMousePos = Vector2.new(mouse.X, mouse.Y)
		rotation = rotation + delta * sensitivity * dt * 10

		local cf = CFrame.new(cam.CFrame.Position) * CFrame.Angles(0, -rotation.X, 0) * CFrame.Angles(-rotation.Y, 0, 0)

		-- Movement
		local move = Vector3.new()
		if keys[Enum.KeyCode.W] then move = move + Vector3.new(0,0,-1) end
		if keys[Enum.KeyCode.S] then move = move + Vector3.new(0,0,1) end
		if keys[Enum.KeyCode.A] then move = move + Vector3.new(-1,0,0) end
		if keys[Enum.KeyCode.D] then move = move + Vector3.new(1,0,0) end
		if keys[Enum.KeyCode.E] then move = move + Vector3.new(0,1,0) end
		if keys[Enum.KeyCode.Q] then move = move + Vector3.new(0,-1,0) end

		if move.Magnitude > 0 then
			cf = cf + (cf.LookVector * move.Z + cf.RightVector * move.X + cf.UpVector * move.Y) * speed
		end

		cam.CFrame = cf
	end)
end

local function stopFreecam()
	flying = false
	toggleBtn.Text = "Freecam: OFF"
	cam.CameraType = Enum.CameraType.Custom
	rotation = Vector2.new()
	if conn then conn:Disconnect() end
	mouse.Icon = ""
end

toggleBtn.MouseButton1Click:Connect(function()
	if flying then
		stopFreecam()
	else
		startFreecam()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

-- Вернуть камеру после респавна
player.CharacterAdded:Connect(function()
	if flying then
		wait(1)
		cam.CFrame = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.CFrame or cam.CFrame
	end
end)
