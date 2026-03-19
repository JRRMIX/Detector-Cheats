-- =============================================
-- DeltaDetector X - OPTIMIZADO + ANTI-LAG + FPS COUNTER (2026)
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local UserSettings = UserSettings()
local localPlayer = Players.LocalPlayer

-- ==================== PANTALLA DE CARGA PERSONALIZADA (FULL SCREEN) ====================
local function createLoadingScreen()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DeltaDetectorLoader"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 999
    screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.Position = UDim2.new(0, 0, 0, 0)
    bg.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.9, 0, 0.14, 0)
    title.Position = UDim2.new(0.05, 0, 0.25, 0)
    title.BackgroundTransparency = 1
    title.Text = "DeltaDetector X"
    title.TextColor3 = Color3.fromRGB(180, 0, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBlack
    title.TextStrokeTransparency = 0.1
    title.TextStrokeColor3 = Color3.new(0, 0, 0)
    title.Parent = bg

    local gameName = Instance.new("TextLabel")
    gameName.Size = UDim2.new(0.9, 0, 0.09, 0)
    gameName.Position = UDim2.new(0.05, 0, 0.42, 0)
    gameName.BackgroundTransparency = 1
    gameName.Text = "[🍀DUELS] Asesinos VS Sheriffs"
    gameName.TextColor3 = Color3.new(1, 1, 1)
    gameName.TextScaled = true
    gameName.Font = Enum.Font.GothamBold
    gameName.TextStrokeTransparency = 0.6
    gameName.Parent = bg

    local credit = Instance.new("TextLabel")
    credit.Size = UDim2.new(0.6, 0, 0.06, 0)
    credit.Position = UDim2.new(0.2, 0, 0.54, 0)
    credit.BackgroundTransparency = 1
    credit.Text = "creada por @Jomix47"
    credit.TextColor3 = Color3.fromRGB(255, 40, 40)
    credit.TextScaled = true
    credit.Font = Enum.Font.Gotham
    credit.TextStrokeTransparency = 0.7
    credit.Parent = bg

    local loading = Instance.new("TextLabel")
    loading.Size = UDim2.new(0.5, 0, 0.07, 0)
    loading.Position = UDim2.new(0.25, 0, 0.68, 0)
    loading.BackgroundTransparency = 1
    loading.Text = "Cargando..."
    loading.TextColor3 = Color3.fromRGB(200, 200, 200)
    loading.TextScaled = true
    loading.Font = Enum.Font.Gotham
    loading.TextStrokeTransparency = 0.8
    loading.Parent = bg

    bg.BackgroundTransparency = 0.6
    title.TextTransparency = 1
    gameName.TextTransparency = 1
    credit.TextTransparency = 1
    loading.TextTransparency = 1

    TweenService:Create(bg, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {BackgroundTransparency = 0.15}):Play()
    TweenService:Create(title, TweenInfo.new(1.1), {TextTransparency = 0}):Play()
    TweenService:Create(gameName, TweenInfo.new(1.3), {TextTransparency = 0}):Play()
    TweenService:Create(credit, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
    TweenService:Create(loading, TweenInfo.new(1.7), {TextTransparency = 0}):Play()

    task.delay(3.2, function()
        loading.Text = "Bienvenido"
        loading.TextColor3 = Color3.fromRGB(0, 255, 100)
        TweenService:Create(loading, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
        task.wait(1.4)
        TweenService:Create(bg, TweenInfo.new(1.0, Enum.EasingStyle.Sine), {BackgroundTransparency = 1}):Play()
        TweenService:Create(title, TweenInfo.new(1.0), {TextTransparency = 1}):Play()
        TweenService:Create(gameName, TweenInfo.new(1.0), {TextTransparency = 1}):Play()
        TweenService:Create(credit, TweenInfo.new(1.0), {TextTransparency = 1}):Play()
        TweenService:Create(loading, TweenInfo.new(1.0), {TextTransparency = 1}):Play()
        task.wait(1.1)
        screenGui:Destroy()
    end)
end

-- ==================== ANTI-LAG + LOW GRAPHICS MODE ====================
local function applyLowGraphicsMode()
    -- Forzar calidad baja (no siempre funciona al 100%, pero ayuda)
    pcall(function()
        UserSettings().GameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel2 -- o QualityLevel1 para más bajo
    end)

    -- Ajustes globales de Lighting (muy efectivo en low-end)
    Lighting.GlobalShadows = false
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.ShadowSoftness = 0
    if Lighting:FindFirstChild("Bloom") then Lighting.Bloom.Enabled = false end
    if Lighting:FindFirstChild("SunRays") then Lighting.SunRays.Enabled = false end
    if Lighting:FindFirstChild("ColorCorrection") then Lighting.ColorCorrection.Enabled = false end
    if Lighting:FindFirstChild("DepthOfField") then Lighting.DepthOfField.Enabled = false end
    if Lighting:FindFirstChild("Blur") then Lighting.Blur.Enabled = false end

    -- Quitar partículas y efectos pesados en el workspace
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Sparkles") then
            obj.Enabled = false
        end
    end

    -- Texturas bajas + sin caras
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("Decal") and part.Name == "face" then
                    part.Transparency = 1
                    part.Visible = false
                elseif part:IsA("BasePart") or part:IsA("MeshPart") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                    part.CastShadow = false
                end
            end
        end
    end

    -- Listener para nuevos personajes (sin cara + low material)
    Players.PlayerAdded:Connect(function(plr)
        if plr == localPlayer then return end
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.5)
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("Decal") and part.Name == "face" then
                    part.Transparency = 1
                    part.Visible = false
                elseif part:IsA("BasePart") or part:IsA("MeshPart") then
                    part.Material = Enum.Material.Plastic
                    part.Reflectance = 0
                    part.CastShadow = false
                end
            end
        end)
    end)
end

-- ==================== FPS COUNTER (esquina superior derecha) ====================
local function createFPSCounter()
    local gui = Instance.new("ScreenGui")
    gui.Name = "FPSCounterGui"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = localPlayer:WaitForChild("PlayerGui")

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 80, 0, 30)
    label.Position = UDim2.new(1, -90, 0, 10)
    label.BackgroundTransparency = 0.6
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.TextColor3 = Color3.fromRGB(220, 255, 180)
    label.TextStrokeTransparency = 0.6
    label.TextStrokeColor3 = Color3.new(0,0,0)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.Text = "FPS: --"
    label.Parent = gui

    local lastTime = tick()
    local frameCount = 0

    RunService.RenderStepped:Connect(function(dt)
        frameCount += 1
        if tick() - lastTime >= 1 then
            local fps = math.floor(frameCount / (tick() - lastTime))
            label.Text = "FPS: " .. tostring(fps)
            frameCount = 0
            lastTime = tick()

            -- Color según rendimiento
            if fps >= 55 then
                label.TextColor3 = Color3.fromRGB(100, 255, 140)
            elseif fps >= 35 then
                label.TextColor3 = Color3.fromRGB(255, 220, 100)
            else
                label.TextColor3 = Color3.fromRGB(255, 80, 80)
            end
        end
    end)
end

-- ==================== CONFIG CHEATS ====================
local MAX_HORIZ_SPEED = 95
local MAX_VERT_SPEED = 48
local AIR_TIME_THRESHOLD = 3.3
local GROUND_RAY_DIST = 22
local CHEAT_FRAMES_TO_FLAG = 3
local TELEPORT_THRESHOLD = 23
local LOW_FLY_THRESHOLD = 9.0

local SCAN_INTERVAL = 0.30

local playerData = {}
local warnings = {}
local LAST_POS = {}
local FLY_TIME = {}
local LAST_SCAN = 0

-- ==================== ROLES ====================
local Roles = {
    ["SoufiwIsReal"]       = {Name = "Owner",     Emoji = "🟡", Color = Color3.fromRGB(255, 221, 0)},
    ["SoufiwIsNotReal"]    = {Name = "Owner",     Emoji = "🟡", Color = Color3.fromRGB(255, 221, 0)},
    ["MarkaDevSheriffs"]   = {Name = "Owner",     Emoji = "🟡", Color = Color3.fromRGB(255, 221, 0)},
    ["top_creation"]       = {Name = "Holder",    Emoji = "🟠", Color = Color3.fromRGB(255, 140, 0)},
    ["Awastoki"]           = {Name = "Dev",       Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},
    ["decim8or"]           = {Name = "Dev",       Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},
    ["3ds_min"]            = {Name = "Dev",       Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},
    ["thecknisic"]         = {Name = "Dev",       Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},
    ["EnlocK"]             = {Name = "Dev",       Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},
    ["w65vutRealVpxr"]     = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["PawitaTB"]           = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["xShuup"]             = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["Yere_22"]            = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["VynilTronix"]        = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["Souligraphy"]        = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["pszk"]               = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["TisBeDrewModAcc"]    = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["PAQUIXYZ"]           = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["justc2yber"]         = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["asriel_09yt"]        = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["cool_man8773"]       = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["eternalbinds"]       = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["SoufiwDev"]          = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["BIuIava"]            = {Name = "Mod",       Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["PanCollin"]          = {Name = "Tester",    Emoji = "🟣", Color = Color3.fromRGB(170, 0, 255)},
    ["xitadoriix"]         = {Name = "MVP - FAMOUS CREATOR", Emoji = "🌟", Color = Color3.fromRGB(255, 215, 0)},
    ["Plutonem"]           = {Name = "Cat",       Emoji = "🐾", Color = Color3.fromRGB(255, 120, 180)},
    ["JdmKooki"]           = {Name = "Cat",       Emoji = "🐾", Color = Color3.fromRGB(255, 120, 180)},
}

-- (Aquí van las funciones hasUnauthorizedBodyMover, getGroundInfo, createWarning, removeWarning, scanAllPlayers sin cambios)

local function hasUnauthorizedBodyMover(char)
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("AlignPosition") or
           obj:IsA("LinearVelocity") or obj:IsA("BodyGyro") or obj:IsA("VectorForce") then
            local n = obj.Name:lower()
            if not (n:find("anim") or n:find("game") or n:find("default") or n:find("ragdoll")) then
                return true
            end
        end
    end
    return false
end

local function getGroundInfo(root)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {root.Parent}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.IgnoreWater = true

    local result = Workspace:Raycast(root.Position + Vector3.new(0, 5, 0), Vector3.new(0, -GROUND_RAY_DIST, 0), rayParams)
    if result then
        local dist = root.Position.Y - result.Position.Y
        return dist < 7, dist
    end
    return false, GROUND_RAY_DIST + 10
end

local function createWarning(player, reasons)
    local char = player.Character
    if not char then return end
    local adornee = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    if not adornee then return end

    if warnings[player] then
        warnings[player].sub.Text = "(" .. table.concat(reasons, " + ") .. ")"
        return
    end

    local hl = Instance.new("Highlight")
    hl.Adornee = char
    hl.Parent = char
    hl.FillColor = Color3.fromRGB(255, 0, 0)
    hl.FillTransparency = 0.35
    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local bb = Instance.new("BillboardGui")
    bb.Adornee = adornee
    bb.Parent = adornee
    bb.Size = UDim2.new(0, 200, 0, 70)
    bb.StudsOffset = Vector3.new(0, 4.5, 0)
    bb.AlwaysOnTop = true

    local main = Instance.new("TextLabel")
    main.Parent = bb
    main.Size = UDim2.new(1,0,0.55,0)
    main.BackgroundTransparency = 1
    main.Text = "¡Peligro!"
    main.TextColor3 = Color3.new(1,0,0)
    main.TextScaled = true
    main.Font = Enum.Font.GothamBlack
    main.TextStrokeTransparency = 0

    local sub = Instance.new("TextLabel")
    sub.Parent = bb
    sub.Size = UDim2.new(1,0,0.45,0)
    sub.Position = UDim2.new(0,0,0.55,0)
    sub.BackgroundTransparency = 1
    sub.Text = "(" .. table.concat(reasons, " + ") .. ")"
    sub.TextColor3 = Color3.new(1, 0.9, 0.9)
    sub.TextScaled = true
    sub.Font = Enum.Font.Gotham
    sub.TextStrokeTransparency = 0.5

    warnings[player] = {hl = hl, bb = bb, sub = sub}
end

local function removeWarning(player)
    if warnings[player] then
        pcall(function() warnings[player].hl:Destroy() end)
        pcall(function() warnings[player].bb:Destroy() end)
        warnings[player] = nil
    end
end

local function scanAllPlayers()
    local now = tick()
    if now - LAST_SCAN < SCAN_INTERVAL then return end
    LAST_SCAN = now

    for _, player in ipairs(Players:GetPlayers()) do
        if player == localPlayer then continue end

        local char = player.Character
        if not char then 
            removeWarning(player)
            playerData[player] = nil
            continue 
        end

        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if not root or not hum or hum.Health <= 0 then continue end

        if not playerData[player] then playerData[player] = {frames = 0} end
        if not FLY_TIME[player] then FLY_TIME[player] = 0 end
        if not LAST_POS[player] then LAST_POS[player] = root.Position end

        local currentReasons = {}
        local cheating = false

        local onGround, dist = getGroundInfo(root)
        local vertVel = math.abs(root.Velocity.Y)
        local horiz = (root.Velocity * Vector3.new(1,0,1)).Magnitude

        local lastPos = LAST_POS[player]
        LAST_POS[player] = root.Position

        local inAir = not onGround and dist > 6

        if inAir or dist > LOW_FLY_THRESHOLD then
            FLY_TIME[player] = FLY_TIME[player] + SCAN_INTERVAL

            if dist > LOW_FLY_THRESHOLD and dist < 18 then
                table.insert(currentReasons, "Low-Fly")
                cheating = true
            end

            if lastPos and (root.Position - lastPos).Magnitude > TELEPORT_THRESHOLD then
                table.insert(currentReasons, "CFrame-Fly")
                cheating = true
            end

            if FLY_TIME[player] > AIR_TIME_THRESHOLD or vertVel > MAX_VERT_SPEED then
                table.insert(currentReasons, "Fly")
                cheating = true
            end
        else
            FLY_TIME[player] = math.max(0, FLY_TIME[player] - 4)
        end

        if hasUnauthorizedBodyMover(char) then
            table.insert(currentReasons, "BodyMover")
            cheating = true
        end

        if horiz > MAX_HORIZ_SPEED and hum.MoveDirection.Magnitude > 0.05 then
            table.insert(currentReasons, "Speed")
            cheating = true
        end

        if cheating and #currentReasons > 0 then
            playerData[player].frames = (playerData[player].frames or 0) + 1
            if playerData[player].frames >= CHEAT_FRAMES_TO_FLAG then
                createWarning(player, currentReasons)
            end
        else
            removeWarning(player)
            playerData[player].frames = 0
        end
    end
end

-- ==================== ROLES ====================
local function createRoleLabel(character, roleInfo)
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    for _, v in ipairs(head:GetChildren()) do
        if v.Name == "RoleLabel" then v:Destroy() end
    end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RoleLabel"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 220, 0, 60)
    billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.Parent = head

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = roleInfo.Emoji .. " " .. roleInfo.Name
    text.TextColor3 = roleInfo.Color
    text.TextScaled = true
    text.Font = Enum.Font.GothamBold
    text.TextStrokeTransparency = 0
    text.TextStrokeColor3 = Color3.new(0, 0, 0)
    text.Parent = billboard
end

local function onCharacterAdded(character, player)
    task.wait(1.2)
    local roleInfo = Roles[player.Name]
    if roleInfo then
        createRoleLabel(character, roleInfo)
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(char)
        onCharacterAdded(char, player)
    end)
    if player.Character then onCharacterAdded(player.Character, player) end
end

-- ==================== INICIO ====================
createLoadingScreen()
applyLowGraphicsMode()          -- ← Activa anti-lag y low graphics
createFPSCounter()              -- ← FPS en esquina superior derecha

RunService.Heartbeat:Connect(scanAllPlayers)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(plr)
    removeWarning(plr)
    playerData[plr] = nil
    LAST_POS[plr] = nil
    FLY_TIME[plr] = nil
end)

for _, plr in ipairs(Players:GetPlayers()) do
    onPlayerAdded(plr)
end

if localPlayer.Character then
    task.wait(2)
    onCharacterAdded(localPlayer.Character, localPlayer)
end

print("✅ DeltaDetector X + Anti-Lag + FPS cargado correctamente")
