-- Create GUI and Aimbot functionality

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = game:GetService("Workspace").CurrentCamera
local UIS = game:GetService("UserInputService")

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.IgnoreGuiInset = true

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Position = UDim2.new(0.5, -50, 0.05, 0)  -- Positioning at the top-center
Frame.Size = UDim2.new(0, 100, 0, 50)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.BackgroundTransparency = 0.5

local Label = Instance.new("TextLabel")
Label.Parent = Frame
Label.Size = UDim2.new(1, 0, 0.5, 0)
Label.Text = "Aimbot"
Label.TextColor3 = Color3.fromRGB(255, 255, 255)
Label.TextSize = 20
Label.BackgroundTransparency = 1

local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = Frame
ToggleButton.Size = UDim2.new(0, 30, 0, 30)
ToggleButton.Position = UDim2.new(1, -40, 0.5, -15)
ToggleButton.Text = ""
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red color
ToggleButton.BorderSizePixel = 0

-- Crosshair creation
local crosshair = Instance.new("Frame")
crosshair.Parent = ScreenGui
crosshair.Size = UDim2.new(0, 30, 0, 30)
crosshair.Position = UDim2.new(0.5, -15, 0.5, -15)  -- Center of the screen
crosshair.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
crosshair.BorderSizePixel = 0

-- Aimbot logic
local aimbotEnabled = false
local targetPlayer = nil

-- Function to find the nearest player
local function getNearestPlayer()
    local nearestPlayer = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local distance = (Camera.CFrame.Position - player.Character.Head.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestPlayer = player
            end
        end
    end
    return nearestPlayer
end

-- Update the aimbot
local function updateAimbot()
    if aimbotEnabled and targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        local targetHead = targetPlayer.Character.Head
        local direction = (targetHead.Position - Camera.CFrame.Position).unit
        local targetRotation = CFrame.lookAt(Camera.CFrame.Position, targetHead.Position)
        Camera.CFrame = targetRotation
    end
end

-- Toggle aimbot on/off when the button is clicked
ToggleButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled

    if aimbotEnabled then
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green color
        targetPlayer = getNearestPlayer()
        print("Aimbot enabled, targeting " .. (targetPlayer and targetPlayer.Name or "none"))
    else
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red color
        targetPlayer = nil
        print("Aimbot disabled")
    end
end)

-- Update the target player every frame
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        targetPlayer = getNearestPlayer()
        updateAimbot()
    end
end)

-- Ensure crosshair is always in the center
RunService.RenderStepped:Connect(function()
    crosshair.Position = UDim2.new(0.5, -15, 0.5, -15)  -- Keeps it in the center
end)

-- Turn off aimbot on death/reset
LocalPlayer.CharacterAdded:Connect(function()
    aimbotEnabled = false
    ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Red color
    print("Aimbot disabled due to death/reset")
end)
