print("Thanks, You using LumosHUD")
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()

local ESPEnabled = true
local FeatureInfoEnabled = true
local BoxESPEnabled = true
local LineESPEnabled = true
local Players = game:GetService("Players")

local function removeESP(player)
    if player.Character then
        if player.Character:FindFirstChild("Highlight") then
            player.Character.Highlight:Destroy()
        end
        if player.Character:FindFirstChild("ESPBox") then
            player.Character.ESPBox:Destroy()
        end
        if player.Character:FindFirstChild("LineESP") then
            player.Character.LineESP:Destroy()
        end
    end
end

local function removeFeatureInfo(player)
    if player.Character then
        if player.Character.Head:FindFirstChild("ESP") then
            player.Character.Head.ESP:Destroy()
        end
        if player.Character:FindFirstChild("HealthBar") then
            player.Character.HealthBar:Destroy()
        end
    end
end

local function esp(player)
    if not ESPEnabled then return end
    if not player.Character then return end
    if player.Character:FindFirstChild("Highlight") then return end

    local highlightc = Instance.new("Highlight")
    highlightc.Parent = player.Character
    highlightc.FillColor = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(125, 125, 125)
    highlightc.OutlineColor = Color3.fromRGB(255, 255, 255)
end

local function espBox(player)
    if not BoxESPEnabled then return end
    if not player.Character then return end
    if player.Character:FindFirstChild("ESPBox") then return end

    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local espBoxGui = Instance.new("BillboardGui")
    espBoxGui.Name = "ESPBox"
    espBoxGui.Parent = character
    espBoxGui.Adornee = humanoidRootPart
    espBoxGui.Size = UDim2.new(0, 10, 0, 10)
    espBoxGui.StudsOffset = Vector3.new(0, 0, 0)
    espBoxGui.AlwaysOnTop = true

    local espBoxFrame = Instance.new("Frame")
    espBoxFrame.Parent = espBoxGui
    espBoxFrame.Size = UDim2.new(1, 0, 1, 0)
    espBoxFrame.BackgroundColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(125, 125, 125)

    local connection
    connection = character.HumanoidRootPart:GetPropertyChangedSignal("Size"):Connect(function()
        espBoxGui.Size = UDim2.new(0, character.HumanoidRootPart.Size.X * 2, 0, character.HumanoidRootPart.Size.Y * 2)
        espBoxGui.CFrame = humanoidRootPart.CFrame
    end)

    game:GetService("Players").PlayerRemoving:Connect(function()
        if connection then connection:Disconnect() end
        if espBoxGui then espBoxGui:Destroy() end
    end)
end

local function lineESP(player)
    if not LineESPEnabled then return end
    if not player.Character then return end
    if player.Character:FindFirstChild("LineESP") then return end

    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local linePart = Instance.new("Part")
    linePart.Name = "LineESP"
    linePart.Anchored = true
    linePart.CanCollide = false
    linePart.Size = Vector3.new(0.1, 0.1, 0)
    linePart.Color = Color3.fromRGB(255, 0, 0)
    linePart.Parent = game.Workspace

    local function updateLine()
        local camera = game.Workspace.CurrentCamera
        local cameraPosition = camera.CFrame.Position
        local characterPosition = humanoidRootPart.Position

        linePart.Size = Vector3.new(0.1, 0.1, (cameraPosition - characterPosition).Magnitude)
        linePart.CFrame = CFrame.new(cameraPosition, characterPosition) * CFrame.new(0, 0, -linePart.Size.Z / 2)
    end
    game:GetService("RunService").RenderStepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            updateLine()
        end
    end)
    game:GetService("Players").PlayerRemoving:Connect(function()
        if linePart then linePart:Destroy() end
    end)
end

local function showhealthbar(player)
    if not FeatureInfoEnabled then return end
    if not player.Character or not player.Character:FindFirstChild("Humanoid") then return end

    local humanoid = player.Character.Humanoid
    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end

    local healthbar = Instance.new("BillboardGui")
    healthbar.Parent = player.Character
    healthbar.Adornee = humanoidRootPart
    healthbar.Size = UDim2.new(4, 0, 0.5, 0)
    healthbar.StudsOffset = Vector3.new(0, 4, 0)
    healthbar.AlwaysOnTop = true
    healthbar.Name = "HealthBar"

    local background = Instance.new("Frame")
    background.Parent = healthbar
    background.Size = UDim2.new(1, 0, 1, 0)
    background.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    background.BorderSizePixel = 0

    local foreground = Instance.new("Frame")
    foreground.Parent = background
    foreground.Size = UDim2.new(1, 0, 1, 0)
    foreground.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    foreground.BorderSizePixel = 0
    foreground.Name = "HealthForeground"

    local function updateHealthBar()
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        foreground.Size = UDim2.new(healthPercent, 0, 1, 0)
        if healthPercent > 0.5 then
            foreground.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        elseif healthPercent > 0.2 then
            foreground.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        else
            foreground.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end

    humanoid.HealthChanged:Connect(updateHealthBar)
    updateHealthBar()
end

local function info(player)
    if not FeatureInfoEnabled then return end
    if not player.Character then return end
    local humanoidRootPart = player.Character:WaitForChild("HumanoidRootPart", 5)
    if not humanoidRootPart then return end
    if player.Character:FindFirstChild("ESP") then return end

    local boxc = Instance.new("BillboardGui")
    boxc.Name = "ESP"
    boxc.Adornee = humanoidRootPart
    boxc.Size = UDim2.new(4, 0, 4, 0)
    boxc.StudsOffset = Vector3.new(0, 3, 0)
    boxc.AlwaysOnTop = true
    boxc.Parent = player.Character:WaitForChild("Head", 10)

    local namelabelc = Instance.new("TextLabel")
    namelabelc.Parent = boxc
    namelabelc.Size = UDim2.new(1, 0, 1.25, 0)
    namelabelc.BackgroundTransparency = 1
    namelabelc.TextStrokeTransparency = 0.5
    namelabelc.TextSize = 14
    namelabelc.Font = Enum.Font.LuckiestGuy
    namelabelc.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
    namelabelc.Text = player.Name

    local teamlabelc = Instance.new("TextLabel")
    teamlabelc.Parent = boxc
    teamlabelc.Size = UDim2.new(1, 0, 0.7, 0)
    teamlabelc.BackgroundTransparency = 1
    teamlabelc.TextStrokeTransparency = 0.5
    teamlabelc.TextSize = 14
    teamlabelc.Font = Enum.Font.LuckiestGuy
    teamlabelc.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
    teamlabelc.Text = player.Team and player.Team.Name or "No team"
end

local Window = Rayfield:CreateWindow({
    Name = "LumosHUD (Private Hack)",
    LoadingTitle = "LumosHUD Loading",
    LoadingSubtitle = "by LumosHUD",
    Discord = {
        Enabled = true,
        Invite = "gARMaGUbeX",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "LumosHUD key",
        Subtitle = "Key System",
        Note = "Join the discord (discord.gg/V2AuYTGZPb)",
        FileName = "Lumos",
        SaveKey = false,
        GrabKeyFromSite = true,
        Key = ["5F9B6299BB97C82B4AC3AA6BD1B31"]
    }
})

local ESPTab = Window:CreateTab("ESP", nil)

ESPTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = true,
    Flag = "ESPEnabled",
    Callback = function(Value)
        ESPEnabled = Value
        for _, player in ipairs(Players:GetPlayers()) do
            if not ESPEnabled then
                removeESP(player)
            else
                esp(player)
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Enable Box ESP",
    CurrentValue = true,
    Flag = "BoxESPEnabled",
    Callback = function(Value)
        BoxESPEnabled = Value
        for _, player in ipairs(Players:GetPlayers()) do
            if not BoxESPEnabled then
                removeESP(player)
            else
                espBox(player)
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Enable Line ESP (Not works)",
    CurrentValue = true,
    Flag = "LineESPEnabled",
    Callback = function(Value)
        LineESPEnabled = Value
        for _, player in ipairs(Players:GetPlayers()) do
            if not LineESPEnabled then
                removeESP(player)
            else
                lineESP(player)
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Enable Feature Info",
    CurrentValue = true,
    Flag = "FeatureInfoEnabled",
    Callback = function(Value)
        FeatureInfoEnabled = Value
        for _, player in ipairs(Players:GetPlayers()) do
            if not FeatureInfoEnabled then
                removeFeatureInfo(player)
            else
                showhealthbar(player)
                info(player)
            end
        end
    end
})

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        esp(player)
        espBox(player)
        lineESP(player)
        if FeatureInfoEnabled then
            showhealthbar(player)
            info(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
    removeFeatureInfo(player)
end)
