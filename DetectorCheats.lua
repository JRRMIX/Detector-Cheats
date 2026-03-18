-- =============================================
-- Detector Cheats 2026 - SOLO NOMBRE DE ROL ARRIBA
-- Fly + Speed + BodyMovers + Roles visibles arriba del jugador
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

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
    -- ["EduardoMxe"]         = {Name = "Owner",  Emoji = "🟡", Color = Color3.fromRGB(255, 221, 0)},  -- Eliminado

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

-- ==================== CHEAT DETECTION (sin cambios) ====================
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

local function checkPlayer(player)
    local char = player.Character
    if not char then removeWarning(player) playerData[player] = nil return end
   
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not root or not hum or hum.Health <= 0 then return end
   
    if not playerData[player] then
        playerData[player] = {airTime = 0, frames = 0, reasons = {}}
    end
   
    local data = playerData[player]
    local currentReasons = {}
    local cheating = false

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
   
    if hasUnauthorizedBodyMover(char) then
        table.insert(currentReasons, "BodyMover")
        cheating = true
    end
   
    local horiz = (root.Velocity * Vector3.new(1,0,1)).Magnitude
    if horiz > MAX_HORIZ_SPEED and hum.MoveDirection.Magnitude > 0.05 then
        table.insert(currentReasons, "Speed")
        cheating = true
    end
   
    if cheating then
        data.reasons = currentReasons
        data.frames = (data.frames or 0) + 1
        if data.frames >= CHEAT_FRAMES_TO_FLAG then
            createWarning(player, currentReasons)
        end
    else
        removeWarning(player)
        data.frames = 0
    end
end

-- ==================== SOLO NOMBRE DE ROL ARRIBA ====================
local function createRoleLabel(character, roleInfo)
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end

    -- Eliminar label anterior si existe
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
    if player.Character then
        onCharacterAdded(player.Character, player)
    end
end

-- ==================== INICIO ====================
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

for _, plr in ipairs(Players:GetPlayers()) do
    onPlayerAdded(plr)
end

if localPlayer.Character then
    task.wait(2)
    onCharacterAdded(localPlayer.Character, localPlayer)
end

print("✅ Detector cargado correctamente")
print("EduardoMxe eliminado como Owner - Solo muestra nombre de rol arriba del jugador")
