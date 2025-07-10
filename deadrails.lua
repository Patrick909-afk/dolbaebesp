local player = game.Players.LocalPlayer
local cam = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FreecamGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.Active = true
frame.Draggable = true

local onOffBtn = Instance.new("TextButton", frame)
onOffBtn.Size = UDim2.new(0.8, 0, 0, 40)
onOffBtn.Position = UDim2.new(0.1,0,0.2,0)
onOffBtn.Text = "Freecam: OFF"

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0.2, 0, 0, 30)
closeBtn.Position = UDim2.new(0.8,0,0,0)
closeBtn.Text = "✖"

local flying = false
local speed = 2
local moveDir = Vector3.new()

-- Функция старта
local function startFreecam()
	flying = true
	onOffBtn.Text = "Freecam: ON"
	cam.CameraType = Enum.CameraType.Scriptable
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		cam.CFrame = player.Character.HumanoidRootPart.CFrame
	end
end

-- Стоп
local function stopFreecam()
	flying = false
	onOffBtn.Text = "Freecam: OFF"
	cam.CameraType = Enum.CameraType.Custom
end

onOffBtn.MouseButton1Click:Connect(function()
	if flying then
		stopFreecam()
	else
		startFreecam()
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

-- Движение
local keys = {}
uis.InputBegan:Connect(function(input, gpe)
	if not gpe then
		keys[input.KeyCode] = true
	end
end)
uis.InputEnded:Connect(function(input, gpe)
	if not gpe then
		keys[input.KeyCode] = false
	end
end)

-- Обновление камеры
rs.RenderStepped:Connect(function(dt)
	if flying then
		local move = Vector3.new()
		if keys[Enum.KeyCode.W] then move = move + Vector3.new(0,0,-1) end
		if keys[Enum.KeyCode.S] then move = move + Vector3.new(0,0,1) end
		if keys[Enum.KeyCode.A] then move = move + Vector3.new(-1,0,0) end
		if keys[Enum.KeyCode.D] then move = move + Vector3.new(1,0,0) end
		if keys[Enum.KeyCode.E] then move = move + Vector3.new(0,1,0) end
		if keys[Enum.KeyCode.Q] then move = move + Vector3.new(0,-1,0) end
		
		if move.Magnitude > 0 then
			cam.CFrame = cam.CFrame * CFrame.new(move * speed * dt * 20)
		end
	end
end)

-- После возрождения
player.CharacterAdded:Connect(function()
	if flying then
		wait(1)
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			cam.CFrame = player.Character.HumanoidRootPart.CFrame
		end
	end
end)
