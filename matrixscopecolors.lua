-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MM2_GunOnly"
screenGui.ResetOnSpawn = false

pcall(function()
    screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
    screenGui.Parent = playerGui
end

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 210, 0, 265)
mainFrame.Position = UDim2.new(0, 30, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- جعل الواجهة قابلة للسحب (Draggable)
local dragging, dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- زر فتح وإغلاق الواجهة (Open/Close Button) على الشاشة
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 45, 0, 45)
toggleBtn.Position = UDim2.new(0, 30, 0, 200)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.Text = "⚙️"
toggleBtn.TextSize = 20
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0) -- دائري تماماً
toggleCorner.Parent = toggleBtn

toggleBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Function to create buttons
local function createButton(name, color, positionY, textColor)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, positionY)
    btn.BackgroundColor3 = color
    btn.Text = name
    btn.TextColor3 = textColor or Color3.fromRGB(255, 255, 255)
    btn.TextSize = 15
    btn.Font = Enum.Font.SourceSansBold
    btn.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    return btn
end

-- UI Elements
local btnApply = createButton("⚡", Color3.fromRGB(40, 40, 40), 15)

local btnRed = createButton("red", Color3.fromRGB(210, 30, 30), 55)
local btnBlue = createButton("blue", Color3.fromRGB(30, 110, 210), 95)
local btnPurple = createButton("purple", Color3.fromRGB(130, 40, 180), 135)
local btnWhite = createButton("white", Color3.fromRGB(220, 220, 220), 175, Color3.fromRGB(20, 20, 20))
local btnYellow = createButton("yellow", Color3.fromRGB(220, 190, 30), 215, Color3.fromRGB(20, 20, 20))

-- دالة مخصصة لتلوين سلاح الـ Gun فقط لا غير
local function colorGunOnly(color)
    local function colorParts(parentObj)
        for _, obj in ipairs(parentObj:GetDescendants()) do
            if obj:IsA("MeshPart") or obj:IsA("BasePart") then
                obj.Color = color
                obj.Material = Enum.Material.SmoothPlastic
                if obj:IsA("MeshPart") then
                    obj.TextureID = ""
                end
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("SurfaceAppearance") or child:IsA("Texture") or child:IsA("Decal") then
                        child:Destroy()
                    end
                end
            elseif obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("ParticleEmitter") then
                obj.Color = ColorSequence.new(color)
            end
        end
    end

    if player.Character then
        for _, item in ipairs(player.Character:GetChildren()) do
            if item:IsA("Tool") then
                local nameLower = item.Name:lower()
                if nameLower:find("gun") or nameLower:find("revolver") or nameLower:find("pistol") or nameLower:find("sheriff") or nameLower:find("blaster") or nameLower:find("laser") then
                    colorParts(item)
                end
            end
        end
    end

    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                local nameLower = item.Name:lower()
                if nameLower:find("gun") or nameLower:find("revolver") or nameLower:find("pistol") or nameLower:find("sheriff") or nameLower:find("blaster") or nameLower:find("laser") then
                    colorParts(item)
                end
            end
        end
    end
end

-- Button Events
btnRed.MouseButton1Click:Connect(function()
    colorGunOnly(Color3.fromRGB(210, 30, 30))
end)

btnBlue.MouseButton1Click:Connect(function()
    colorExecutor = colorGunOnly(Color3.fromRGB(30, 110, 210)) -- تم التصحيح للاستدعاء السليم
end)

btnBlue.MouseButton1Click:Connect(function()
    colorGunOnly(Color3.fromRGB(30, 110, 210))
end)

btnPurple.MouseButton1Click:Connect(function()
    colorGunOnly(Color3.fromRGB(130, 40, 180))
end)

btnWhite.MouseButton1Click:Connect(function()
    colorGunOnly(Color3.fromRGB(220, 220, 220))
end)

btnYellow.MouseButton1Click:Connect(function()
    colorGunOnly(Color3.fromRGB(220, 190, 30))
end)

btnApply.MouseButton1Click:Connect(function()
    colorGunOnly(Color3.fromRGB(210, 30, 30))
end)

-- Toggle GUI with Double Press 'X' or Open Button
local lastPress = 0
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        local currentTime = tick()
        if currentTime - lastPress < 0.4 then
            mainFrame.Visible = not mainFrame.Visible
        end
        lastPress = currentTime
    end
end)
