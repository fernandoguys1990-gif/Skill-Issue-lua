
-- Script for granting all abilities button in Die of Death + ESP + Invis GUI Creator
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local AbilityNames = {"Cloak", "Punch", "Taunt", "BonusPad", "Block", "Caretaker", "Dash", "Hotdog", "Revolver", "Adrenaline", "Banana"}

local AbilityDatas = {
    ["Adrenaline"] = {Name = "Adrenaline", InputShown = "", Tip = "Temporary speed boost for 6 seconds", Cooldown = 35, Icon = "rbxassetid://116399911657417", DisplayName = "Adrenaline"},
    ["Punch"] = {Name = "Punch", InputShown = "", Tip = "Punch forward, stunning killers for 3 seconds", Cooldown = 40, Icon = "rbxassetid://97428323453639", DisplayName = "Punch"},
    ["Caretaker"] = {Name = "Caretaker", InputShown = "", Tip = "Heals survivors for 20 HP", Cooldown = 30, Icon = "rbxassetid://90712805517714", DisplayName = "Caretaker"},
    ["Cloak"] = {Name = "Cloak", InputShown = "", Tip = "Become invisible for a short time", Cooldown = 50, Icon = "rbxassetid://90476367580326", DisplayName = "Cloak"},
    ["Block"] = {Name = "Block", InputShown = "", Tip = "Block damage and receive healing", Cooldown = 40, Icon = "rbxassetid://120929805037270", DisplayName = "Block"},
    ["Dash"] = {Name = "Dash", InputShown = "", Tip = "Dash forward followed by fatigue", Cooldown = 20, Icon = "rbxassetid://73777691791017", DisplayName = "Dash"},
    ["BonusPad"] = {Name = "BonusPad", InputShown = "", Tip = "Create a temporary speed boost pad", Cooldown = 70, Icon = "rbxassetid://86775625332300", DisplayName = "BonusPad"},
    ["Hotdog"] = {Name = "Hotdog", InputShown = "", Tip = "Eat a hotdog to heal 15 HP", Cooldown = 15, Icon = "rbxassetid://134322360499381", DisplayName = "Hotdog"},
    ["Revolver"] = {Name = "Revolver", InputShown = "", Tip = "Shoot and stun killer for 2 seconds", Cooldown = 15, Icon = "rbxassetid://107624957891469", DisplayName = "Revolver"},
    ["Taunt"] = {Name = "Taunt", InputShown = "", Tip = "Taunt the killer and gain a shield", Cooldown = 25, Icon = "rbxassetid://85436299122876", DisplayName = "Taunt"},
    ["Banana"] = {Name = "Banana", InputShown = "", Tip = "Throw a banana peel to stun", Cooldown = 20, Icon = "rbxassetid://96202444819611", DisplayName = "Banana Peel"}
}

local ESPEnabled = false
local ESPFolder = nil
local ESPConnectionsPerPlayer = {}
local ESPPlayers = {}
local ESPShowNames = true
local ESPShowDistance = true
local ESPShowHealth = true
local ESPShowKillers = true
local ESPShowSurvivors = true
local ESPShowGhosts = true
local globalPlayerAddedConn = nil
local globalPlayerRemovingConn = nil

local BLOCK_DISTANCE = 15
local watcherEnabled = true
local Logged = {}
local badwareState = {active = false, startTime = 0, lastWS = nil}

local KillerConfigs = {
    ["Pursuer"] = {enabled = true, check = function(_, ws) local valid = {4,6,7,8,10,12,14,16,20}; for _, v in ipairs(valid) do if ws == v then return true end end return false end},
    ["Artful"] = {enabled = true, check = function(_, ws) local valid = {4,7,8,12,16,20,9,13,17,21}; for _, v in ipairs(valid) do if ws == v then return true end end return false end},
    ["Harken"] = {enabled = true, check = function(playerFolder, ws) local enraged = playerFolder:GetAttribute("Enraged") local seq = enraged and {7.5,10,5,13.5,17.5,21.5,25.5} or {4,8,12,16,20} if playerFolder:GetAttribute("AgitationCooldown") then return true end for _, v in ipairs(seq) do if ws == v then return true end end return false end},
    ["Badware"] = {enabled = true, check = function(_, ws) local valid = {4,8,12,16,20} local function isValid(val) for _, v in ipairs(valid) do if val == v then return true end end return false end local now = tick() if isValid(ws) then if not badwareState.active then badwareState.startTime = now badwareState.active = true badwareState.lastWS = ws return false else badwareState.lastWS = ws return false end else if badwareState.active then local duration = now - badwareState.startTime badwareState.active = false badwareState.lastWS = nil badwareState.startTime = nil if duration < 0.3 then return true else return false end end end return false end},
    ["Killdroid"] = {enabled = true, check = function(_, ws) local valid = {-4,0,4,12,16,20}; for _, v in ipairs(valid) do if ws == v then return true end end return false end}
}

local lockWSM = true
local keepStaminaEnabled = true
local customStamina = 100
local defaultStamina = 100
local AntiWalls = false
local instantPPEnabled = true
local proximityPrompts = {}
local noM1Enabled = false
local DETECTION_RANGE = 18
local CHECK_INTERVAL = 0.5
local hideState = false
local blockerList = {}

local AntiWallsEnabled = false
local AntiComputerEnabled = false
local AntiEvilScaryEnabled = false
local AntiTauntEnabled = false
local AntiBarriersEnabled = false
local AntiFallDamageEnabled = false

local autoStretchEnabled = true
local isMinimized = false

local tauntMonitorActive = false

-- Function to create Invis GUI (from the second script, modified)
local function CreateInvisGUI()
    local player = LocalPlayer
    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.ResetOnSpawn = false
    local frame = Instance.new("Frame", screenGui)
    local toggleButton = Instance.new("TextButton", frame)
    local closeButton = Instance.new("TextButton", frame)

    frame.Size = UDim2.new(0, 100, 0, 60)
    frame.Position = UDim2.new(0.5, -50, 0.5, -35)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.Active = true
    frame.Draggable = true

    toggleButton.Size = UDim2.new(0, 80, 0, 30)
    toggleButton.Position = UDim2.new(0, 10, 0, 30)
    toggleButton.Text = "INVISIBLE"
    toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.Font = Enum.Font.SourceSans
    toggleButton.TextScaled = true

    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.Text = "X"
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 123, 0)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.SourceSans
    closeButton.TextSize = 18

    local invis_on = false

    local sound = Instance.new("Sound", player:WaitForChild("PlayerGui"))
    sound.SoundId = "rbxassetid://942127495"
    sound.Volume = 1

    local function setTransparency(character, transparency)
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("Decal") then
                part.Transparency = transparency
            end
        end
    end

    local function toggleInvisibility()
        local character = player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then return end
        invis_on = not invis_on
        sound:Play()
        if invis_on then
            local savedpos = character.HumanoidRootPart.CFrame
            task.wait()
            character:MoveTo(Vector3.new(-25.95, 84, 3537.55))
            task.wait(0.15)
            local Seat = Instance.new('Seat', Workspace)
            Seat.Anchored = false
            Seat.CanCollide = false
            Seat.Name = 'invischair'
            Seat.Transparency = 1
            Seat.Position = Vector3.new(-25.95, 84, 3537.55)
            local Weld = Instance.new("Weld", Seat)
            Weld.Part0 = Seat
            Weld.Part1 = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            task.wait()
            Seat.CFrame = savedpos
            setTransparency(character, 0.5)
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        else
            local invisChair = Workspace:FindFirstChild('invischair')
            if invisChair then
                invisChair:Destroy()
            end
            setTransparency(character, 0)
            toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        end
    end

    toggleButton.MouseButton1Click:Connect(toggleInvisibility)
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)

    player.CharacterAdded:Connect(function()
        invis_on = false
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AbilityButtonGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Enabled = true

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.Active = true
frame.Draggable = true
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(80, 80, 80)

local topPanel = Instance.new("Frame", frame)
topPanel.Size = UDim2.new(1, 0, 0, 30)
topPanel.Position = UDim2.new(0, 0, 0, 0)
topPanel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
topPanel.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", topPanel)
titleLabel.Text = "🎮 Die of Death"
titleLabel.Size = UDim2.new(0, 150, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local toggleButton = Instance.new("TextButton", topPanel)
toggleButton.Text = "-"
toggleButton.Size = UDim2.new(0, 20, 0, 20)
toggleButton.Position = UDim2.new(1, -45, 0, 5)
toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 14

local closeButton = Instance.new("TextButton", topPanel)
closeButton.Text = "×"
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -20, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 16

local sectionsPanel = Instance.new("Frame", frame)
sectionsPanel.Size = UDim2.new(1, 0, 0, 40)
sectionsPanel.Position = UDim2.new(0, 0, 0, 30)
sectionsPanel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sectionsPanel.BorderSizePixel = 0

local sectionsScrolling = Instance.new("ScrollingFrame", sectionsPanel)
sectionsScrolling.Size = UDim2.new(1, 0, 1, 0)
sectionsScrolling.Position = UDim2.new(0, 0, 0, 0)
sectionsScrolling.BackgroundTransparency = 1
sectionsScrolling.ScrollBarThickness = 6
sectionsScrolling.ScrollingDirection = Enum.ScrollingDirection.X
sectionsScrolling.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Left
sectionsScrolling.CanvasSize = UDim2.new(2, 0, 0, 0)

local sectionsContainer = Instance.new("Frame", sectionsScrolling)
sectionsContainer.Size = UDim2.new(0, 800, 1, 0)
sectionsContainer.BackgroundTransparency = 1

local contentContainer = Instance.new("Frame", frame)
contentContainer.Size = UDim2.new(1, 0, 0, 300)
contentContainer.Position = UDim2.new(0, 0, 0, 70)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true

local sections = {
    {"📜", "Abilities"},
    {"👁️", "ESP"},
    {"🛡️", "Auto Block"},
    {"⚙️", "Gameplay"},
    {"🛡️", "Anti"},
    {"👻", "Invis"}
}

local sectionButtons = {}
local sectionContainers = {}
local currentSection = nil

local sectionsLayout = Instance.new("UIListLayout", sectionsContainer)
sectionsLayout.FillDirection = Enum.FillDirection.Horizontal
sectionsLayout.Padding = UDim.new(0, 5)
sectionsLayout.SortOrder = Enum.SortOrder.LayoutOrder

for i, section in ipairs(sections) do
    local sectionButton = Instance.new("TextButton", sectionsContainer)
    sectionButton.Text = section[1] .. " " .. section[2]
    sectionButton.Size = UDim2.new(0, 100, 0, 30)
    sectionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    sectionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    sectionButton.Font = Enum.Font.GothamBold
    sectionButton.TextSize = 11
    sectionButton.AutoButtonColor = true
    sectionButton.LayoutOrder = i
    
    local sectionContainer = Instance.new("Frame", contentContainer)
    sectionContainer.Size = UDim2.new(1, 0, 1, 0)
    sectionContainer.Position = UDim2.new(0, 0, 0, 0)
    sectionContainer.BackgroundTransparency = 1
    sectionContainer.Visible = false
    
    table.insert(sectionButtons, sectionButton)
    table.insert(sectionContainers, sectionContainer)
end

sectionsScrolling.CanvasSize = UDim2.new(0, sectionsContainer.AbsoluteSize.X, 0, 0)

local function resizeFrame()
    if not currentSection or isMinimized then return end
    local maxY = 0
    for _, child in ipairs(currentSection:GetChildren()) do
        if child:IsA("GuiObject") and child.Visible then
            local y = child.Position.Y.Offset + child.Size.Y.Offset
            if y > maxY then maxY = y end
        end
    end
    contentContainer.Size = UDim2.new(1, 0, 0, maxY)
    frame.Size = UDim2.new(0, 300, 0, 70 + maxY + 10)
end

RunService.Heartbeat:Connect(function()
    if autoStretchEnabled and currentSection and not isMinimized then
        resizeFrame()
    end
end)

local abilitiesTab = sectionContainers[1]
abilitiesTab.Visible = true
currentSection = abilitiesTab

local mainButton = Instance.new("TextButton", abilitiesTab)
mainButton.Text = "📜 GRANT ALL ABILITIES"
mainButton.Size = UDim2.new(0, 280, 0, 35)
mainButton.Position = UDim2.new(0, 10, 0, 40)
mainButton.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.Font = Enum.Font.GothamBold
mainButton.TextSize = 12

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = mainButton

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2
UIStroke.Parent = mainButton

local statusLabel = Instance.new("TextLabel", abilitiesTab)
statusLabel.Text = "Status: Waiting..."
statusLabel.Size = UDim2.new(0, 280, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 80)
statusLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11

local infoLabel = Instance.new("TextLabel", abilitiesTab)
infoLabel.Text = "Abilities: 0/11"
infoLabel.Size = UDim2.new(0, 280, 0, 20)
infoLabel.Position = UDim2.new(0, 10, 0, 100)
infoLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 11

local divider1 = Instance.new("Frame", abilitiesTab)
divider1.Size = UDim2.new(0, 280, 0, 1)
divider1.Position = UDim2.new(0, 10, 0, 125)
divider1.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider1.BorderSizePixel = 0

local cardsLabel = Instance.new("TextLabel", abilitiesTab)
cardsLabel.Text = "🎴 GRANT CARDS"
cardsLabel.Size = UDim2.new(0, 280, 0, 20)
cardsLabel.Position = UDim2.new(0, 10, 0, 130)
cardsLabel.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
cardsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
cardsLabel.Font = Enum.Font.GothamBold
cardsLabel.TextSize = 12

local cardSettings = {
    [1] = {[1] = "Block", [2] = "Dash"},
    [2] = {[1] = "Hotdog", [2] = "Adrenaline"},
    [3] = {[1] = "Revolver", [2] = "Punch"}
}

local dropdowns = {}
local activeMenus = {}

local function CloseAllMenus()
    for _, menu in pairs(activeMenus) do
        if menu and menu.Parent then
            menu:Destroy()
        end
    end
    activeMenus = {}
end

for i = 1, 3 do
    local cardFrame = Instance.new("Frame", abilitiesTab)
    cardFrame.Size = UDim2.new(0, 280, 0, 25)
    cardFrame.Position = UDim2.new(0, 10, 0, 150 + (i-1)*30)
    cardFrame.BackgroundTransparency = 1
    
    local cardNumber = Instance.new("TextLabel", cardFrame)
    cardNumber.Text = "Card " .. i .. ":"
    cardNumber.Size = UDim2.new(0, 50, 1, 0)
    cardNumber.Position = UDim2.new(0, 0, 0, 0)
    cardNumber.BackgroundTransparency = 1
    cardNumber.TextColor3 = Color3.fromRGB(255, 255, 255)
    cardNumber.Font = Enum.Font.Gotham
    cardNumber.TextSize = 11
    cardNumber.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdown1 = Instance.new("TextButton", cardFrame)
    dropdown1.Text = cardSettings[i][1]
    dropdown1.Size = UDim2.new(0, 105, 1, 0)
    dropdown1.Position = UDim2.new(0, 55, 0, 0)
    dropdown1.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    dropdown1.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown1.Font = Enum.Font.Gotham
    dropdown1.TextSize = 10
    
    local dropdown2 = Instance.new("TextButton", cardFrame)
    dropdown2.Text = cardSettings[i][2]
    dropdown2.Size = UDim2.new(0, 105, 1, 0)
    dropdown2.Position = UDim2.new(0, 165, 0, 0)
    dropdown2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    dropdown2.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown2.Font = Enum.Font.Gotham
    dropdown2.TextSize = 10
    
    table.insert(dropdowns, {dropdown1, dropdown2})
    
    local function createDropdownHandler(dropdown, cardIndex, abilityIndex)
        local menu = nil
        local connection = nil
        
        local function closeMenu()
            if menu and menu.Parent then
                menu:Destroy()
                menu = nil
            end
            if connection then
                connection:Disconnect()
                connection = nil
            end
            for i, activeMenu in pairs(activeMenus) do
                if activeMenu == menu then
                    table.remove(activeMenus, i)
                    break
                end
            end
        end
        
        dropdown.MouseButton1Click:Connect(function()
            if menu and menu.Parent then
                closeMenu()
                return
            end
            
            CloseAllMenus()
            
            menu = Instance.new("Frame")
            menu.Size = UDim2.new(0, 100, 0, 200)
            menu.Position = UDim2.new(0, dropdown.AbsolutePosition.X - frame.AbsolutePosition.X, 0, dropdown.AbsolutePosition.Y - frame.AbsolutePosition.Y + 25)
            menu.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            menu.BorderSizePixel = 1
            menu.BorderColor3 = Color3.fromRGB(100, 100, 100)
            menu.ZIndex = 5
            menu.Parent = frame
            
            table.insert(activeMenus, menu)
            
            local scrollingFrame = Instance.new("ScrollingFrame", menu)
            scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
            scrollingFrame.BackgroundTransparency = 1
            scrollingFrame.BorderSizePixel = 0
            scrollingFrame.ScrollBarThickness = 6
            
            local uiListLayout = Instance.new("UIListLayout", scrollingFrame)
            uiListLayout.Padding = UDim.new(0, 1)
            
            for _, abilityName in pairs(AbilityNames) do
                local abilityButton = Instance.new("TextButton")
                abilityButton.Size = UDim2.new(1, -10, 0, 25)
                abilityButton.Position = UDim2.new(0, 5, 0, 0)
                abilityButton.Text = abilityName
                abilityButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                abilityButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                abilityButton.Font = Enum.Font.Gotham
                abilityButton.TextSize = 10
                abilityButton.Parent = scrollingFrame
                
                abilityButton.MouseButton1Click:Connect(function()
                    cardSettings[cardIndex][abilityIndex] = abilityName
         
