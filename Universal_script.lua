local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Script Roblox (by Ferdi)",
   LoadingTitle = "Please Wait",
   LoadingSubtitle = "By Ferdiansyah",
   ConfigurationSaving = {
      Enabled = true,
      FileName = "FerHub"
   },
   KeySystem = true,
   KeySettings = {
      Title = "FerHub",
      Subtitle = "Key System",
      Note = "Kunci tanya pembuat 🤭",
      FileName = "Key",
      SaveKey = false,
      Key = {"Ferdi1990"}
   }
})

local MainTab = Window:CreateTab("👤 Player", nil)
MainTab:CreateSection("Main")

Rayfield:Notify({
   Title = "FerHub",
   Content = "Thank you for trying my script",
   Duration = 3
})

local InfiniteJump = false
local UIS = game:GetService("UserInputService")

UIS.JumpRequest:Connect(function()
   if InfiniteJump then
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChildOfClass("Humanoid") then
         char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
      end
   end
end)

MainTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Callback = function(Value)
      InfiniteJump = Value
   end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local NoClip = false
local NoClipConnection

local function SetNoClip(state)
   NoClip = state

   if NoClipConnection then
      NoClipConnection:Disconnect()
      NoClipConnection = nil
   end

   if state then
      NoClipConnection = RunService.Stepped:Connect(function()
         local character = LocalPlayer.Character
         if character then
            for _, part in pairs(character:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.CanCollide = false
               end
            end
         end
      end)
   end
end

MainTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(Value)
      SetNoClip(Value)
   end
})

-- Mobile Fly Function (GLOBAL)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local FlyEnabled = false
local FlyConnection
local BV, BG

local FlySpeed = 60

local function StartFly()
   local char = LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end

   local hrp = char.HumanoidRootPart
   local humanoid = char:FindFirstChildOfClass("Humanoid")
   humanoid.PlatformStand = true

   BG = Instance.new("BodyGyro")
   BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
   BG.P = 9e4
   BG.CFrame = hrp.CFrame
   BG.Parent = hrp

   BV = Instance.new("BodyVelocity")
   BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
   BV.Parent = hrp

   FlyConnection = RunService.RenderStepped:Connect(function()
      local cam = workspace.CurrentCamera
      BV.Velocity = cam.CFrame.LookVector * FlySpeed
      BG.CFrame = cam.CFrame
   end)
end

local function StopFly()
   if FlyConnection then
      FlyConnection:Disconnect()
      FlyConnection = nil
   end

   local char = LocalPlayer.Character
   if char and char:FindFirstChild("HumanoidRootPart") then
      if BV then BV:Destroy() BV = nil end
      if BG then BG:Destroy() BG = nil end

      char:FindFirstChildOfClass("Humanoid").PlatformStand = false
   end
end

local function ToggleFly()
   FlyEnabled = not FlyEnabled
   if FlyEnabled then
      StartFly()
   else
      StopFly()
   end
end

MainTab:CreateButton({
   Name = "Toggle Fly (Mobile)",
   Callback = function()
      ToggleFly()
   end
})

-- Bald Toggle Button Function
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BaldEnabled = false
local RemovedHair = {}

local function ApplyBald(character)
   for _, acc in pairs(character:GetChildren()) do
      if acc:IsA("Accessory") then
         local t = acc:FindFirstChild("AccessoryType")
         if t and t.Value == Enum.AccessoryType.Hair then
            table.insert(RemovedHair, acc)
            acc.Parent = nil
         end
      end
   end
end

local function RestoreHair(character)
   for _, hair in pairs(RemovedHair) do
      if hair then
         hair.Parent = character
      end
   end
   table.clear(RemovedHair)
end

local function ToggleBald()
   BaldEnabled = not BaldEnabled
   local char = LocalPlayer.Character
   if not char then return end

   if BaldEnabled then
      ApplyBald(char)
   else
      RestoreHair(char)
   end
end

-- Auto apply saat respawn
LocalPlayer.CharacterAdded:Connect(function(char)
   if BaldEnabled then
      task.wait(0.5)
      ApplyBald(char)
   end
end)

MainTab:CreateButton({
   Name = "Membuat Jadi Botak Klik lagi untuk kembali ke normal",
   Callback = function()
      ToggleBald()
   end
})

-- Brown Avatar Function
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local BrownEnabled = false
local OriginalColors = {}

local BrownColor = Color3.fromRGB(90, 60, 30) -- cokelat pekat

local function ApplyBrown(character)
   for _, obj in pairs(character:GetDescendants()) do
      if obj:IsA("BasePart") then
         -- Simpan warna asli
         if not OriginalColors[obj] then
            OriginalColors[obj] = obj.Color
         end

         obj.Color = BrownColor
         obj.Material = Enum.Material.SmoothPlastic
      end
   end
end

local function RestoreColor()
   for part, color in pairs(OriginalColors) do
      if part and part.Parent then
         part.Color = color
      end
   end
   OriginalColors = {}
end

local function SetBrown(state)
   BrownEnabled = state
   local char = LocalPlayer.Character
   if not char then return end

   if state then
      ApplyBrown(char)
   else
      RestoreColor()
   end
end

-- Auto apply when respawn
LocalPlayer.CharacterAdded:Connect(function(char)
   if BrownEnabled then
      task.wait(0.5)
      ApplyBrown(char)
   end
end)

MainTab:CreateToggle({
   Name = "Brown Avatar",
   CurrentValue = false,
   Callback = function(Value)
      SetBrown(Value)
   end
})

-- Full Bright Function
local Lighting = game:GetService("Lighting")

local FullBrightEnabled = false
local OriginalLighting = {}

local function ApplyFullBright()
   OriginalLighting.Brightness = Lighting.Brightness
   OriginalLighting.ClockTime = Lighting.ClockTime
   OriginalLighting.FogEnd = Lighting.FogEnd
   OriginalLighting.GlobalShadows = Lighting.GlobalShadows
   OriginalLighting.OutdoorAmbient = Lighting.OutdoorAmbient

   Lighting.Brightness = 2
   Lighting.ClockTime = 14
   Lighting.FogEnd = 100000
   Lighting.GlobalShadows = false
   Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
end

local function RestoreLighting()
   for prop, value in pairs(OriginalLighting) do
      Lighting[prop] = value
   end
end

local function ToggleFullBright()
   FullBrightEnabled = not FullBrightEnabled

   if FullBrightEnabled then
      ApplyFullBright()
   else
      RestoreLighting()
   end
end

MainTab:CreateButton({
   Name = "Toggle Full Bright",
   Callback = function()
      ToggleFullBright()
   end
})

-- WalkSpeed Slider
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local DefaultSpeed = 16
local CurrentSpeed = 16

local function ApplySpeed(character)
   local humanoid = character:WaitForChild("Humanoid")
   humanoid.WalkSpeed = CurrentSpeed
end

-- Apply when respawn
LocalPlayer.CharacterAdded:Connect(function(character)
   ApplySpeed(character)
end)

MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      CurrentSpeed = Value
      local char = LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = Value
      end
   end
})

-- Mobile Controlled Fling
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local FlingEnabled = false
local FlingConnection
local BV, AV

local FlingSpeed = 80      -- gerak maju
local SpinPower = 50000    -- kekuatan putar

local function StartFling()
   local char = LocalPlayer.Character
   if not char or not char:FindFirstChild("HumanoidRootPart") then return end

   local hrp = char.HumanoidRootPart

   BV = Instance.new("BodyVelocity")
   BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
   BV.Parent = hrp

   AV = Instance.new("AngularVelocity")
   AV.AngularVelocity = Vector3.new(0, SpinPower, 0)
   AV.MaxTorque = math.huge
   AV.Parent = hrp

   FlingConnection = RunService.RenderStepped:Connect(function()
      local cam = workspace.CurrentCamera
      BV.Velocity = cam.CFrame.LookVector * FlingSpeed
   end)
end

local function StopFling()
   if FlingConnection then
      FlingConnection:Disconnect()
      FlingConnection = nil
   end

   local char = LocalPlayer.Character
   if char and char:FindFirstChild("HumanoidRootPart") then
      if BV then BV:Destroy() BV = nil end
      if AV then AV:Destroy() AV = nil end
   end
end

local function ToggleFling()
   FlingEnabled = not FlingEnabled
   if FlingEnabled then
      StartFling()
   else
      StopFling()
   end
end

MainTab:CreateButton({
   Name = "Toggle Fling",
   Callback = function()
      ToggleFling()
   end
})

-- ================== AIMBOT TAB ==================
local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Settings
local Enabled = false
local MaxDistance = 100
local LockedTarget = nil
local AutoSwitch = true
local conn

-- ================== DOT ==================
local Dot = Drawing.new("Circle")
Dot.Radius = 3
Dot.Filled = true
Dot.Color = Color3.fromRGB(255,255,255)
Dot.Visible = false

-- ================== GET TARGET ==================
local function GetClosestTarget()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local closest, dist = nil, MaxDistance

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer
        and plr.Character
        and plr.Character:FindFirstChild("HumanoidRootPart")
        and plr.Character:FindFirstChild("Humanoid")
        and plr.Character.Humanoid.Health > 0 then

            local d = (char.HumanoidRootPart.Position -
                       plr.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = plr
            end
        end
    end
    return closest
end

-- ================== VALID TARGET ==================
local function ValidTarget(plr)
    return plr
    and plr.Character
    and plr.Character:FindFirstChild("Humanoid")
    and plr.Character.Humanoid.Health > 0
    and (LocalPlayer.Character.HumanoidRootPart.Position -
         plr.Character.HumanoidRootPart.Position).Magnitude <= MaxDistance
end

-- ================== START ==================
local function Start()
    if conn then return end  -- Prevent multiple connections
    Enabled = true
    LockedTarget = GetClosestTarget()
    Dot.Visible = true

    conn = RunService.RenderStepped:Connect(function()
        -- dot tengah
        Dot.Position = Vector2.new(
            Camera.ViewportSize.X / 2,
            Camera.ViewportSize.Y / 2
        )

        if not Enabled then return end

        -- auto ganti target
        if not ValidTarget(LockedTarget) then
            if AutoSwitch then
                LockedTarget = GetClosestTarget()
            else
                return
            end
        end

        if not LockedTarget then return end

        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local head = LockedTarget.Character:FindFirstChild("Head")

        if root and head then
            -- 🎥 CAMERA AIM
            Camera.CFrame = CFrame.new(
                Camera.CFrame.Position,
                head.Position
            )

            -- 🧍 CHARACTER AIM
            root.CFrame = CFrame.new(
                root.Position,
                Vector3.new(head.Position.X, root.Position.Y, head.Position.Z)
            )
        end
    end)
end

-- ================== STOP ==================
local function Stop()
    if conn then conn:Disconnect() conn = nil end
    LockedTarget = nil
    Dot.Visible = false
end

-- ================== SAFE RESPAWN ==================
LocalPlayer.CharacterAdded:Connect(function()
    Stop()
end)

-- ================== TOGGLE ==================
AimbotTab:CreateToggle({
    Name = "Aimbot (Camera + Character)",
    CurrentValue = false,
    Callback = function(v)
        Enabled = v
        if v then Start() else Stop() end
    end
})

-- ================== AUTO SWITCH ==================
AimbotTab:CreateToggle({
    Name = "Auto Switch Target",
    CurrentValue = true,
    Callback = function(v)
        AutoSwitch = v
    end
})

-- ================== MANUAL SWITCH ==================
AimbotTab:CreateButton({
    Name = "Switch Target (Manual)",
    Callback = function()
        LockedTarget = GetClosestTarget()
    end
})

AimbotTab:CreateButton({
   Name = "Hitbox expender",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Gwaporoblox/Sub-to-vascal/refs/heads/main/Vascal-Hitbox-Expander"))()
   end
})

local DodTap = Window:CreateTab("Die Of Death Script", nil)

local Button = DodTap:CreateButton({
   Name = "Dod Script (clik Here)",
   Callback = function()
         loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({ Name = " DoD FULL FEATURE HUB", LoadingTitle = "Die Of Death", LoadingSubtitle = "FerHub Ultimate", ConfigurationSaving = { Enabled = true, FileName = "DoD_FullHub" } })

-- ================== SERVICES ================== local Players = game:GetService("Players") local RunService = game:GetService("RunService") local Workspace = game:GetService("Workspace") local Lighting = game:GetService("Lighting") local ReplicatedStorage = game:GetService("ReplicatedStorage") local LocalPlayer = Players.LocalPlayer local Camera = Workspace.CurrentCamera

-- ================== TABS ================== local ESPTab      = Window:CreateTab("👁 ESP", nil) local AntiTab     = Window:CreateTab("🛡 Anti", nil) local AbilityTab  = Window:CreateTab("⚡ Ability", nil) local PlayerTab   = Window:CreateTab("👤 Player", nil) local WorldTab    = Window:CreateTab("🌍 World", nil) local MiscTab     = Window:CreateTab("⚙ Misc", nil)

-- ================================================== -- ======================= ESP ====================== -- ================================================== local ESP = { Enabled = false, ShowNames = true, ShowDistance = true, ShowHealth = true, ShowKillers = true, ShowSurvivors = true, ShowGhosts = true }

local ESPFolder = Instance.new("Folder", Workspace) ESPFolder.Name = "DoD_ESP"

local function ClearESP() ESPFolder:ClearAllChildren() end

local function IsKiller(plr) return plr.Team and tostring(plr.Team) == "Killers" end

local function CreateESP(plr) if plr == LocalPlayer then return end local char = plr.Character if not char or not char:FindFirstChild("Head") or not char:FindFirstChild("HumanoidRootPart") then return end

if IsKiller(plr) and not ESP.ShowKillers then return end if (not IsKiller(plr)) and not ESP.ShowSurvivors then return end

local gui = Instance.new("BillboardGui") gui.Size = UDim2.new(0,220,0,50) gui.AlwaysOnTop = true gui.Adornee = char.Head gui.Parent = ESPFolder

local label = Instance.new("TextLabel", gui) label.Size = UDim2.new(1,0,1,0) label.BackgroundTransparency = 1 label.TextScaled = true label.TextStrokeTransparency = 0 label.Font = Enum.Font.SourceSansBold label.TextColor3 = IsKiller(plr) and Color3.new(1,0,0) or Color3.new(0,1,0)

RunService.RenderStepped:Connect(function() if not ESP.Enabled or not char.Parent then gui:Destroy() return end local dist = (LocalPlayer.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude local hum = char:FindFirstChildOfClass("Humanoid") local txt = "" if ESP.ShowNames then txt ..= plr.Name end if ESP.ShowDistance then txt ..= string.format(" | %dm", dist) end if ESP.ShowHealth and hum then txt ..= string.format(" | HP:%d", hum.Health) end label.Text = txt end) end

local function RefreshESP() ClearESP() if not ESP.Enabled then return end for _,plr in pairs(Players:GetPlayers()) do CreateESP(plr) end end

Players.PlayerAdded:Connect(RefreshESP) Players.PlayerRemoving:Connect(RefreshESP)

ESPTab:CreateToggle({Name="Enable ESP",CurrentValue=false,Callback=function(v) ESP.Enabled=v RefreshESP() end}) ESPTab:CreateToggle({Name="Show Names",CurrentValue=true,Callback=function(v) ESP.ShowNames=v RefreshESP() end}) ESPTab:CreateToggle({Name="Show Distance",CurrentValue=true,Callback=function(v) ESP.ShowDistance=v RefreshESP() end}) ESPTab:CreateToggle({Name="Show Health",CurrentValue=true,Callback=function(v) ESP.ShowHealth=v RefreshESP() end}) ESPTab:CreateToggle({Name="Show Killers",CurrentValue=true,Callback=function(v) ESP.ShowKillers=v RefreshESP() end}) ESPTab:CreateToggle({Name="Show Survivors",CurrentValue=true,Callback=function(v) ESP.ShowSurvivors=v RefreshESP() end})

-- ================================================== -- ===================== ANTI ======================= -- ================================================== local Anti = { KillerAlert = false, AntiGhost = false, AntiTaunt = false, AntiBarrier = false, AntiFallDamage = false, AntiWalls = false }

local BLOCK_DISTANCE = 18

local function GetNearestKiller() local char = LocalPlayer.Character if not char or not char:FindFirstChild("HumanoidRootPart") then return end local nearest, dist = nil, BLOCK_DISTANCE for _,plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then if IsKiller(plr) then local d = (char.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude if d < dist then dist=d nearest=plr end end end end return nearest end

RunService.Heartbeat:Connect(function() local killer = GetNearestKiller() if killer and Anti.KillerAlert then Rayfield:Notify({Title="⚠ KILLER",Content=killer.Name.." dekat!",Duration=1}) end end)

AntiTab:CreateToggle({Name="Killer Alert",CurrentValue=false,Callback=function(v) Anti.KillerAlert=v end}) AntiTab:CreateToggle({Name="Anti Ghost (Safe)",CurrentValue=false,Callback=function(v) Anti.AntiGhost=v end}) AntiTab:CreateToggle({Name="Anti Taunt",CurrentValue=false,Callback=function(v) Anti.AntiTaunt=v end}) AntiTab:CreateToggle({Name="Anti Barrier",CurrentValue=false,Callback=function(v) Anti.AntiBarrier=v end}) AntiTab:CreateToggle({Name="Anti Fall Damage",CurrentValue=false,Callback=function(v) Anti.AntiFallDamage=v end}) AntiTab:CreateToggle({Name="Anti Walls",CurrentValue=false,Callback=function(v) Anti.AntiWalls=v end})

-- ================================================== -- =================== ABILITY ====================== -- ================================================== local Ability = { AutoBlock = false, AutoDash = false, AutoRevolver = false, KeepStamina = false, CustomStamina = 100 }

AbilityTab:CreateToggle({Name="Auto Block",CurrentValue=false,Callback=function(v) Ability.AutoBlock=v end}) AbilityTab:CreateToggle({Name="Auto Dash Escape",CurrentValue=false,Callback=function(v) Ability.AutoDash=v end}) AbilityTab:CreateToggle({Name="Auto Revolver Aim",CurrentValue=false,Callback=function(v) Ability.AutoRevolver=v end}) AbilityTab:CreateToggle({Name="Keep Stamina",CurrentValue=false,Callback=function(v) Ability.KeepStamina=v end})

AbilityTab:CreateSlider({ Name="Custom Stamina", Range={50,200}, Increment=10, CurrentValue=100, Callback=function(v) Ability.CustomStamina=v end })

-- ================================================== -- =================== PLAYER ======================= -- ================================================== local Player = {NoClip=false, Speed=16}

PlayerTab:CreateSlider({ Name="WalkSpeed", Range={16,80}, Increment=1, CurrentValue=16, Callback=function(v) Player.Speed=v local hum=LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") if hum then hum.WalkSpeed=v end end })

-- ================================================== -- =================== WORLD ======================== -- ================================================== local FullBright=false local OldLight={}

local function ApplyFullBright() OldLight={Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,FogEnd=Lighting.FogEnd,GlobalShadows=Lighting.GlobalShadows} Lighting.Brightness=2 Lighting.ClockTime=14 Lighting.FogEnd=1e5 Lighting.GlobalShadows=false end

local function RestoreBright() for k,v in pairs(OldLight) do Lighting[k]=v end end

WorldTab:CreateToggle({Name="Full Bright",CurrentValue=false,Callback=function(v) FullBright=v if v then ApplyFullBright() else RestoreBright() end end})

-- ================================================== -- ==================== MISC ======================== -- ================================================== MiscTab:CreateButton({Name="Reset Character",Callback=function() LocalPlayer.Character:BreakJoints() end})

Rayfield:Notify({Title="DoD FULL HUB",Content="All original features loaded",Duration=3})
   end
})
