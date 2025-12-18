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

if game.CoreGui:FindFirstChild("AimbotStatusGui") then
    game.CoreGui.AimbotStatusGui:Destroy()
end

local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ================== STATUS GUI ==================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AimbotStatusGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local StatusButton = Instance.new("TextButton")
StatusButton.Parent = ScreenGui
StatusButton.Size = UDim2.new(0, 190, 0, 45)
StatusButton.Position = UDim2.new(0, 20, 0.5, -25)
StatusButton.BackgroundColor3 = Color3.fromRGB(25,25,25)
StatusButton.BackgroundTransparency = 0.15
StatusButton.BorderSizePixel = 0
StatusButton.TextScaled = true
StatusButton.Font = Enum.Font.GothamBold
StatusButton.AutoButtonColor = false

local UICorner = Instance.new("UICorner", StatusButton)
UICorner.CornerRadius = UDim.new(0, 12)

-- ================== STATUS FUNCTION ==================
local Enabled = false

local function UpdateStatus(state)
    if state then
        StatusButton.Text = "🎯 AIMBOT : ON"
        StatusButton.TextColor3 = Color3.fromRGB(80,255,80)
    else
        StatusButton.Text = "🎯 AIMBOT : OFF"
        StatusButton.TextColor3 = Color3.fromRGB(255,80,80)
    end
end

UpdateStatus(false)

-- ================== DRAG ==================
local dragging, dragStart, startPos

StatusButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = StatusButton.Position
    end
end)

StatusButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        StatusButton.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- ================== AIMBOT LOGIC (ringkas) ==================
local conn
local function Start()
    if conn then return end
    conn = RunService.RenderStepped:Connect(function()
         local MaxDistance = 100
local AutoSwitch = true
local LockedTarget = nil
local AimConnection

local function StartAimbot()
    if AimConnection then return end

    LockedTarget = GetClosestTarget(MaxDistance)

    AimConnection = RunService.RenderStepped:Connect(function()
        if not Enabled then return end

        -- ganti target kalau mati / jauh
        if not IsValidTarget(LockedTarget, MaxDistance) then
            if AutoSwitch then
                LockedTarget = GetClosestTarget(MaxDistance)
            else
                return
            end
        end

        if not LockedTarget then return end

        local myChar = LocalPlayer.Character
        local targetChar = LockedTarget.Character
        if not myChar or not targetChar then return end

        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local targetHead = targetChar:FindFirstChild("Head")

        if myRoot and targetHead then
            -- 🎥 CAMERA AIM
            Camera.CFrame = CFrame.new(
                Camera.CFrame.Position,
                targetHead.Position
            )

            -- 🧍 CHARACTER AIM (tidak miring)
            myRoot.CFrame = CFrame.new(
                myRoot.Position,
                Vector3.new(
                    targetHead.Position.X,
                    myRoot.Position.Y,
                    targetHead.Position.Z
                )
            )
        end
    end)
         end
    end)
end

local function Stop()
    if conn then conn:Disconnect() conn = nil end
end

StatusButton.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    UpdateStatus(Enabled)
    if Enabled then Start() else Stop() end
end)

AimbotTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(v)
        Enabled = v
        UpdateStatus(v)
        if v then Start() else Stop() end
    end
})

AimbotTab:CreateButton({
   Name = "Hitbox expender",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Gwaporoblox/Sub-to-vascal/refs/heads/main/Vascal-Hitbox-Expander"))()
   end
})

local LokTap = Window:CreateTab("Universal script", nil)

local Button = LokTap:CreateButton({
   Name = "Die of death (clik Hare)",
   Callback = function()
     loadstring(game:HttpGet("https://pastebin.com/raw/6N2Bm9Z0"))()
   end,
})
