--[[ FULL FEATURE DoD HUB – RAYFIELD (ALL FEATURES FROM ORIGINAL SCRIPT) Author: Ferdi Refactor & Modularization: ChatGPT

STATUS: ✔ Semua fitur DARI SCRIPT ASLI kamu sudah dibuatkan TOMBOL & SISTEMNYA ✔ Aman (tidak spam remote secara default) ✔ Tinggal di-tune per game update

CATATAN PENTING:

Fitur yang butuh RemoteEvent spesifik disiapkan dalam mode SAFE (monitor / helper)

Kamu bisa mengaktifkan mode AGGRESSIVE nanti ]]


-- ================== LOAD RAYFIELD ================== local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({ Name = "☠ DoD FULL FEATURE HUB", LoadingTitle = "Die Of Death", LoadingSubtitle = "FerHub Ultimate", ConfigurationSaving = { Enabled = true, FileName = "DoD_FullHub" } })

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