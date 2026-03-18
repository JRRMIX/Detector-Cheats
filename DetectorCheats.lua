-- =============================================
-- Detector Cheats 2026 - SIN INVISIBILIDAD
-- Fly + Speed + BodyMovers + Sistema de Roles + Auras
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local localPlayer = Players.LocalPlayer

-- ==================== CONFIG CHEATS ====================
local MAX_HORIZ_SPEED = 95
local MAX_VERT_SPEED = 35
local AIR_TIME_THRESHOLD = 5.5
local GROUND_RAY_DIST = 18
local CHEAT_FRAMES_TO_FLAG = 6

local playerData = {}
local warnings = {}

-- ==================== ROLES ====================
local Roles = {
    -- Owners
    ["SoufiwIsReal"]       = {Name = "Owner",  Emoji = "🟡", Color = Color3.fromRGB(255, 221, 0)},
    ["SoufiwIsNotReal"]    = {Name = "Owner",  Emoji = "🟡", Color = Color3.fromRGB(255, 221, 0)},
    ["MarkaDevSheriffs"]   = {Name = "Owner",  Emoji = "🟡", Color = Color3.fromRGB(255, 221, 0)},
    ["EduardoMxe"]         = {Name = "Owner",  Emoji = "🟡", Color = Color3.fromRGB(255, 221, 0)},

    -- Holders
    ["top_creation"]       = {Name = "Holder", Emoji = "🟠", Color = Color3.fromRGB(255, 140, 0)},

    -- Devs
    ["Awastoki"]           = {Name = "Dev",    Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},
    ["decim8or"]           = {Name = "Dev",    Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},
    ["3ds_min"]            = {Name = "Dev",    Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},
    ["thecknisic"]         = {Name = "Dev",    Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},
    ["EnlocK"]             = {Name = "Dev",    Emoji = "🔵", Color = Color3.fromRGB(0, 170, 255)},

    -- Mods
    ["w65vutRealVpxr"]     = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["PawitaTB"]           = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["xShuup"]             = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["Yere_22"]            = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["VynilTronix"]        = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["Souligraphy"]        = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["pszk"]               = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["TisBeDrewModAcc"]    = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["PAQUIXYZ"]           = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["justc2yber"]         = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["asriel_09yt"]        = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["cool_man8773"]       = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["eternalbinds"]       = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["SoufiwDev"]          = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},
    ["BIuIava"]            = {Name = "Mod",    Emoji = "🟢", Color = Color3.fromRGB(0, 200, 100)},

    -- Tester
    ["PanCollin"]          = {Name = "Tester", Emoji = "🟣", Color = Color3.fromRGB(170, 0, 255)},

    -- MVP
    ["xitadoriix"]         = {Name = "MVP - FAMOUS CREATOR", Emoji = "🌟", Color = Color3.fromRGB(255, 215, 0)},

    -- Cat
    ["Plutonem"]           = {Name = "Cat",    Emoji = "🐾", Color = Color3.fromRGB(255, 120, 180)},
    ["JdmKooki"]           = {Name = "Cat",    Emoji = "🐾", Color = Color3.fromRGB(255, 120, 180)},
}

-- ==================== FUNCIONES CHEATS ====================
local function hasUnauthorizedBodyMover(char)
    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("AlignPosition") or
           obj:IsA("LinearVelocity") or obj:IsA("BodyGyro") then
            if not obj.Name:lower():find("anim") and not obj.Name:lower():find("game") then
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
   
    local result = Workspace:Raycast(root.Position + Vector3.new(0, 3, 0), Vector3.new(0, -GROUND_RAY_DIST, 0), rayParams)
    if result then
        return true, (root.Position.Y - result.Position.Y)
    end
    return false, GROUND_RAY_DIST + 15
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
    bb.LightInfluence = 0
   
    local main = Instance.new("TextLabel")
    main.Parent = bb
    main.Size = UDim2.new(1,0,0.55,0)
    main.BackgroundTransparency = 1
    main.Text = "¡Peligro!"
    main.TextColor3 = Color3.new(1,0,0)
    main.TextScaled = true
    main.Font = Enum.Font.GothamBlack
    main.TextStrokeTransparency = 0
    main.TextStrokeColor3 = Color3.new(0,0,0)
   
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
    print("[DETECTADO] " .. player.Name .. " → " .. sub.Text)
end

local function removeWarning(player)
    if warnings[player] then
        warnings[player].hl:Destroy()
        warnings[player].bb:Destroy()
        warnings[player] = nil
    end
end

local function checkPlayer(player)
    local char = player.Character
    if not char then
        removeWarning(player)
        playerData[player] = nil
        return
    end
   
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
   
    if not playerData[player] then
        playerData[player] = {airTime = 0, frames = 0, lastFlag = 0, reasons = {}}
    end
   
    local data = playerData[player]
    local currentReasons = {}
    local cheating = false

    -- FLY
    local onGround, dist = getGroundInfo(root)
    local vertVelAbs = math.abs(root.Velocity.Y)
    local inAirSusp = not onGround and dist > 7 and hum.FloorMaterial == Enum.Material.Air
   
    if inAirSusp then
        data.airTime = data.airTime + 0.033
        if data.airTime > AIR_TIME_THRESHOLD or vertVelAbs > MAX_VERT_SPEED then
            table.insert(currentReasons, "Fly")
            cheating = true
        end
    else
        data.airTime = math.max(0, data.airTime - 2)
    end
   
    -- BODY MOVERS
    if hasUnauthorizedBodyMover(char) then
        table.insert(currentReasons, "BodyMover")
        cheating = true
    end
   
    -- SPEED
    local horiz = (root.Velocity * Vector3.new(1,0,1)).Magnitude
    if horiz > MAX_HORIZ_SPEED and hum.MoveDirection.Magnitude > 0.05 then
        table.insert(currentReasons, "Speed")
        cheating = true
    end
   
    if cheating then
        data.reasons = currentReasons
        data.frames = data.frames + 1
        if data.frames >= CHEAT_FRAMES_TO_FLAG then
            createWarning(player, currentReasons)
            data.lastFlag = tick()
        end
    else
        removeWarning(player)
        data.frames = 0
    end
end

-- ==================== AURA + MENSAJE AL UNIRSE ====================
local function createAura(character, color)
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, v in ipairs(root:GetChildren()) do
        if v.Name == "RoleAura" then v:Destroy() end
    end

    local attachment = Instance.new("Attachment")
    attachment.Name = "RoleAura"
    attachment.Parent = root

    local particle = Instance.new("ParticleEmitter")
    particle.Name = "RoleAura"
    particle.Texture = "rbxassetid://243098098"
    particle.Color = ColorSequence.new(color)
    particle.LightEmission = 1
    particle.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 4), NumberSequenceKeypoint.new(1, 0)})
    particle.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.6), NumberSequenceKeypoint.new(1, 1)})
    particle.Lifetime = NumberRange.new(0.8, 1.2)
    particle.Rate = 80
    particle.SpreadAngle = Vector2.new(360, 360)
    particle.Speed = NumberRange.new(1, 3)
    particle.RotSpeed = NumberRange.new(-50, 50)
    particle.Parent = attachment
end

local function showJoinMessage(player, roleInfo)
    local isOwner = roleInfo.Name == "Owner"

    local text = isOwner and "⚠️ PELIGRO EXTREMO ⚠️\nOwner se unió al server\n\n¿Salir o Continuar?" 
                 or "👤 " .. roleInfo.Emoji .. " " .. roleInfo.Name .. " se unió al server"

    StarterGui:SetCore("SendNotification", {
        Title = "Rol Detectado",
        Text = text,
        Duration = isOwner and 15 or 8,
        Button1 = isOwner and "Salir" or nil,
        Button2 = isOwner and "Continuar" or nil,
        Callback = isOwner and function(clicked)
            if clicked == "Salir" then
                game:Shutdown()
            end
        end or nil
    })

    print("[ROL] " .. player.Name .. " → " .. roleInfo.Name)
end

local function onCharacterAdded(character, player)
    task.wait(1.5)
    local roleInfo = Roles[player.Name]
    if roleInfo then
        createAura(character, roleInfo.Color)
        if player == localPlayer then
            showJoinMessage(player, roleInfo)
        end
    end
end

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(char)
        onCharacterAdded(char, player)
    end)

    if player.Character then
        onCharacterAdded(player.Character, player)
    end

    if player ~= localPlayer then
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            local roleInfo = Roles[player.Name]
            if roleInfo then
                showJoinMessage(player, roleInfo)
            end
        end)
    end
end

-- ==================== CONEXIONES ====================
RunService.Heartbeat:Connect(function()
    for _, plr in ipairs(Players:GetPlayers()) do
        pcall(checkPlayer, plr)
    end
end)

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(plr)
    removeWarning(plr)
    playerData[plr] = nil
end)

-- Cargar jugadores ya en el servidor
for _, plr in ipairs(Players:GetPlayers()) do
    onPlayerAdded(plr)
end

-- Cargar propio personaje
if localPlayer.Character then
    task.wait(2)
    onCharacterAdded(localPlayer.Character, localPlayer)
end

print("✅ Detector Cheats 2026 (SIN INVISIBILIDAD) + Roles + Auras cargado")
print("EduardoMxe agregado como Owner")
