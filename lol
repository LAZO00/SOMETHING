local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "Title of the library", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

local Tab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddBind({
    Name = "Auto Pickup",
    Default = Enum.KeyCode.X,
    Hold = false,
    Callback = function()
        local function autoPickupNearbyItems()
            local function getNearbyItems()
                local player = game:GetService("Players").LocalPlayer
                local character = player.Character
                local items = {}

                if character then
                    local playerPosition = character.PrimaryPart.Position

                    for _, item in ipairs(game:GetService("Workspace"):GetDescendants()) do
                        if item:IsA("Model") and item.PrimaryPart then
                            local itemPosition = item.PrimaryPart.Position
                            local distance = (playerPosition - itemPosition).Magnitude

                            if distance <= 5 then -- Adjust the distance as needed
                                table.insert(items, item)
                            end
                        end
                    end
                end

                return items
            end

            local itemInteractedEvent = game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted

            local items = getNearbyItems()
            for i = 1, #items do
                local item = items[i]
                local success = pcall(function()
                    itemInteractedEvent:FireServer(item, "Pickup")
                end)
                if not success then
                    warn("Failed to pick up item:", item.Name)
                end
                wait() -- Wait a short time before moving on to the next item
            end
        end

        autoPickupNearbyItems()
    end
})



local Tab = Window:MakeTab({
	Name = "Combat",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})



--[[
Name = <string> - The name of the bind.
Default = <keycode> - The default value of the bind.
Hold = <bool> - Makes the bind work like: Holding the key > The bind returns true, Not holding the key > Bind returns false.
Callback = <function> - The function of the bind.
]]

--//Global Variables
getgenv().MaxDistance = 50
_G.KillAura = true

getgenv().MaxDistance = 50
_G.SilentAim = true


--//Functions
function GetClosestTorso()
    local closest
    local plrtorso = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _,v in pairs(game:GetService("Players"):GetPlayers()) do
        if v.Character and v ~= game:GetService("Players").LocalPlayer then
            local torso = v.Character:FindFirstChild("HumanoidRootPart")
            if torso and (closest == nil or (torso.Position - plrtorso.Position).magnitude < (closest.Position - plrtorso.Position).magnitude) then
                if (torso.Position - plrtorso.Position).magnitude <= getgenv().MaxDistance then
                    closest = torso
                end
            end
        end
    end
    wait()
    return closest
end

function BreakJoints()
    Player.CharacterAdded:Wait()
    for i = 1, 20 do
        RunService.Heartbeat:Wait()
        if Player.Character:FindFirstChild("HumanoidRootPart") then
            Player.Character:FindFirstChild("HumanoidRootPart").CFrame = Old
        end
    end
end

Tab:AddButton({
	Name = "Hidden Aimbot Script Made by myself F1 to hide",
	Callback = function()
      		local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Holding = false
local TargetSelected = false
local SelectedPlayer = nil

local AimbotEnabled = true
local AimPart = "Head"
local Sensitivity = 0

-- GUI Setup
local AimbotGui = Instance.new("ScreenGui")
AimbotGui.Name = "AimbotGui"
AimbotGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Name = "AimbotFrame"
Frame.Size = UDim2.new(0, 230, 0, 120) -- Increased height to accommodate additional text
Frame.Position = UDim2.new(0.5, -100, 0.5, -60) -- Center position
Frame.BorderSizePixel = 0
Frame.Visible = true
Frame.BackgroundColor3 = Color3.fromRGB(72, 119, 200) -- Set the background color to a nice blue
Frame.Parent = AimbotGui

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Name = "TargetLabel"
TargetLabel.Size = UDim2.new(0, 180, 0, 20)
TargetLabel.Position = UDim2.new(0, 10, 0, 30)
TargetLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.BackgroundTransparency = 1
TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetLabel.TextSize = 14
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = Frame

local DiscordLabel = Instance.new("TextLabel")
DiscordLabel.Name = "DiscordLabel"
DiscordLabel.Size = UDim2.new(0, 180, 0, 20)
DiscordLabel.Position = UDim2.new(0, 10, 0, 60)
DiscordLabel.BackgroundColor3 = Color3.fromRGB(102, 255, 204)
DiscordLabel.BackgroundTransparency = 1
DiscordLabel.TextColor3 = Color3.fromRGB(102, 255, 204)
DiscordLabel.TextSize = 14
DiscordLabel.TextXAlignment = Enum.TextXAlignment.Left
DiscordLabel.Text = "discord.gg/87dGbU9t5W"
DiscordLabel.Parent = Frame

local ControlLabel = Instance.new("TextLabel")
ControlLabel.Name = "ControlLabel"
ControlLabel.Size = UDim2.new(0, 180, 0, 20)
ControlLabel.Position = UDim2.new(0, 10, 0, 90)
ControlLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ControlLabel.BackgroundTransparency = 1
ControlLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
ControlLabel.TextSize = 14
ControlLabel.TextXAlignment = Enum.TextXAlignment.Left
ControlLabel.Text = "CTRL to target"
ControlLabel.Parent = Frame

-- Dragging Variables
local dragToggle = nil
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragToggle then
            updateDrag(input)
        end
    end
end)

local function GetClosestPlayer()
    local MaximumDistance = math.huge
    local Target = nil

    for _, v in ipairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local Character = v.Character
            if Character and Character:FindFirstChild("HumanoidRootPart") then
                local ScreenPoint = workspace.CurrentCamera:WorldToScreenPoint(Character.HumanoidRootPart.Position)
                local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude

                if VectorDistance < MaximumDistance then
                    Target = v
                    MaximumDistance = VectorDistance
                end
            end
        end
    end

    return Target
end

local Hidden = false

local function UpdateTargetLabel()
    if TargetSelected then
        TargetLabel.Text = "Target: " .. SelectedPlayer.Name
        TargetLabel.TextColor3 = Color3.fromRGB(0, 0, 255) -- Set the color to blue
    else
        TargetLabel.Text = "Target: None"
        TargetLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- Set the color to white
    end
end

local function ShowFrame()
    Frame.Visible = true
    Hidden = false
end

local function HideFrame()
    Frame.Visible = false
    Hidden = true
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftControl then
        if AimbotEnabled then
            if not Holding then
                if not TargetSelected then
                    SelectedPlayer = GetClosestPlayer()
                    if SelectedPlayer then
                        TargetSelected = true
                        UpdateTargetLabel()
                        
                    end
                else
                    SelectedPlayer = nil
                    TargetSelected = false
                    UpdateTargetLabel()
                    
                end
            end
        end
    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    elseif input.KeyCode == Enum.KeyCode.F1 then
        Hidden = not Hidden
        if Hidden then
            HideFrame()
        else
            ShowFrame()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if Holding and AimbotEnabled and TargetSelected then
        local Character = SelectedPlayer.Character
        if Character and Character:FindFirstChild(AimPart) then
            local AimPartPosition = Character[AimPart].Position
            TweenService:Create(workspace.CurrentCamera, TweenInfo.new(Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, AimPartPosition)}):Play()
        end
    end
end)

UpdateTargetLabel()



-- Loop to print the Discord server link every 3 minutes
while true do
    wait(180) -- 3 minutes in seconds
    PrintDiscordLink()
end



-- Rainbow color effect
local hue = 0
local saturation = 1
local value = 1
local animationSpeed = 0.005 -- Adjust the speed here (smaller values make it slower)

local function UpdateFrameColor()
    Frame.BackgroundColor3 = Color3.fromHSV(hue, saturation, value)
end

while true do
    if LocalPlayer.Character then
        break
    end
    wait()
end

while LocalPlayer.Character do
    hue = (hue + animationSpeed) % 1
    UpdateFrameColor()
    wait()
end
  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddToggle({
	Name = "Kill Aura",
	Default = false,
	Callback = function(Value)
		--// Execution
if _G.KillAura == false then
    _G.KillAura = true
    game:GetService("RunService").Stepped:connect(function()
        if _G.KillAura then
            local Closest = GetClosestTorso()
            if Closest ~= nil then
                local Player = game:GetService("Players"):GetPlayerFromCharacter(Closest.Parent)
            
                -- I took this from dev forum lol
                local args = {
                    [1] = Player.Character
                }
                game:GetService("ReplicatedStorage").References.Comm.Events.ToolAction:FireServer(unpack(args))
            end
        end
    end)
else
    _G.KillAura = false
end
	end    
})

Tab:AddToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(Value)
        --// Execution
        if _G.SilentAim == false then
            _G.SilentAim = true
            local delay = 0.7 -- Set the desired delay time (in seconds)
            while _G.SilentAim do
                local Closest = GetClosestTorso()
                if Closest ~= nil then
                    local Player = game:GetService("Players"):GetPlayerFromCharacter(Closest.Parent)
                    -- I took this from dev forum lol
                    local args = {
                        [1] = Player.Character
                    }
                    game:GetService("ReplicatedStorage").References.Comm.Events.ToolAction:FireServer(unpack(args))



                end
                wait(delay)
            end
        else
            _G.SilentAim = false
        end
    end
})
Tab:AddButton({
	Name = "ESP 1",
	Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FishExploitsYT/ESP/53c5835d974487dad9297200f630e58e45d69427/Good%20ESP.lua"))()
  	end    
})


Tab:AddButton({
	Name = "ESP 2",
	Callback = function()
      		local FillColor = Color3.fromRGB(175,25,255)
local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineColor = Color3.fromRGB(255,255,255)
local OutlineTransparency = 0

local CoreGui = game:FindService("CoreGui")
local Players = game:FindService("Players")
local lp = Players.LocalPlayer
local connections = {}

local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

local function Highlight(plr)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.FillColor = FillColor
    Highlight.DepthMode = DepthMode
    Highlight.FillTransparency = FillTransparency
    Highlight.OutlineColor = OutlineColor
    Highlight.OutlineTransparency = 0
    Highlight.Parent = Storage
    
    local plrchar = plr.Character
    if plrchar then
        Highlight.Adornee = plrchar
    end

    connections[plr] = plr.CharacterAdded:Connect(function(char)
        Highlight.Adornee = char
    end)
end

Players.PlayerAdded:Connect(Highlight)
for i,v in next, Players:GetPlayers() do
    Highlight(v)
end

Players.PlayerRemoving:Connect(function(plr)
    local plrname = plr.Name
    if Storage[plrname] then
        Storage[plrname]:Destroy()
    end
    if connections[plr] then
        connections[plr]:Disconnect()
    end
end)
  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

--[[
Name = <string> - The name of the toggle.
Default = <bool> - The default value of the toggle.
Callback = <function> - The function of the toggle.
]]

Tab:AddButton({
	Name = "Infinite-Yield",
	Default = false,
	Callback = function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end    
})

local Tab = Window:MakeTab({
	Name = "Instant Repair",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddLabel("YOU NEED TO HAVE A WOOD CHEST PLACED!!")

    local selectedScript = ""

Tab:AddDropdown({
	Name = "Armors",
	Default = "Moonstone Set with Moonstone Sword and Moonstone Sheild",
	Options = {"Moonstone Set with Moonstone Sword and Moonstone Sheild", "Obsidian Set with Obsidian Sword and Obsidian Sheild", "Lucky Sword and Lucky Shield", "All of the Wands", "All of the CrossBows", "All of the Sheilds"},
	Callback = function(Value)
		selectedScript = Value
	end
})

Tab:AddButton({
	Name = "Repair",
	Callback = function()
		if selectedScript == "Moonstone Set with Moonstone Sword and Moonstone Sheild" then
            OrionLib:MakeNotification({
                Name = "",
                Content = "successfully Repaired a moonstone set with a moonstone Sword and moonstone shield.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            
            --[[
            Title = <string> - The title of the notification.
            Content = <string> - The content of the notification.
            Image = <string> - The icon of the notification.
            Time = <number> - The duration of the notfication.
            ]]
			local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"] -- change the chest to what chest it is
local A_2 = true -- if true it puts in
local A_3 = 369  -- ID of the item, NOTE: ( NOT SOUL ) ( ID OF THE ITEMS,BOOKS CAN BE PURCHASED VIA WHATEVER DISCORD SERVER)
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)





 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = true -- if true it puts in
local A_3 = 366  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)




 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = true -- if true it puts in
local A_3 = 365  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)



 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = true -- if true it puts in
local A_3 = 363  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)



 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = true -- if true it puts in
local A_3 = 364  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = true -- if true it puts in
local A_3 = 367  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"] -- change the chest to what chest it is
local A_2 = false -- if true it puts in
local A_3 = 369  -- ID of the item, NOTE: ( NOT SOUL ) ( ID OF THE ITEMS,BOOKS CAN BE PURCHASED VIA WHATEVER DISCORD SERVER)
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)





 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 366  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)




 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 365  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)



 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 363  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)



 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 364  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 367  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)


			-- Add your code for executing Script 1 here
		elseif selectedScript == "Obsidian Set with Obsidian Sword and Obsidian Sheild" then
			OrionLib:MakeNotification({
                Name = "",
                Content = "successfully Repaired an Obsidan set with an Obsidan Sword and Obsidan shield.",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            
            --[[
            Title = <string> - The title of the notification.
            Content = <string> - The content of the notification.
            Image = <string> - The icon of the notification.
            Time = <number> - The duration of the notfication.
            ]]
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true
            local A_3 = 227
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
        
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true
            local A_3 = 228
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
        
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true
            local A_3 = 226
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
        
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true
            local A_3 = 225
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
        
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true
            local A_3 = 230
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true
            local A_3 = 235
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false
            local A_3 = 227
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
        
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false
            local A_3 = 228
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
        
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false
            local A_3 = 226
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
        
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false
            local A_3 = 225
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
        
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false
            local A_3 = 230
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false
            local A_3 = 235
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

        elseif selectedScript == "Lucky Sword and Lucky Shield" then

            OrionLib:MakeNotification({
                Name = "",
                Content = "successfully repaired the Lucky Sword and Lucky Shield",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
            
            --[[
            Title = <string> - The title of the notification.
            Content = <string> - The content of the notification.
            Image = <string> - The icon of the notification.
            Time = <number> - The duration of the notfication.
            ]]
            
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 173  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 173  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 219  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 219  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

        elseif selectedScript == "All of the Wands" then

            OrionLib:MakeNotification({
                Name = "",
                Content = "successfully repaired all of your wands",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 162  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 162  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 289  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 289  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
            
            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 290  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 290  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 291  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 291  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 292  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 292  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 293  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 293  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

        elseif selectedScript == "All of the CrossBows" then

            OrionLib:MakeNotification({
                Name = "",
                Content = "successfully repaired all of your CrossBows",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 197  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 197  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 198  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 198  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 199  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 199  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 376  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 376  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

        elseif selectedScript == "All of the Sheilds" then

            OrionLib:MakeNotification({
                Name = "",
                Content = "successfully repaired all of your Sheilds",
                Image = "rbxassetid://4483345998",
                Time = 5
            })

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 379  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 379  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 209  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 209  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 210  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 210  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 219  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 219  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 211  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 211  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 235  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 235  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 367  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

            local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 367  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

		end
	end
})



--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]

local Tab = Window:MakeTab({
	Name = "Pets",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddBind({
	Name = "Small Pumpkin Dragon",
	Default = Enum.KeyCode.E,
	Hold = false,
	Callback = function()
		local args = {
    [1] = "Equip",
    [2] = "{1845964763293172200}"
}

game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("Pet"):FireServer(unpack(args))

	end    
})



--[[
Name = <string> - The name of the bind.
Default = <keycode> - The default value of the bind.
Hold = <bool> - Makes the bind work like: Holding the key > The bind returns true, Not holding the key > Bind returns false.
Callback = <function> - The function of the bind.
]]



--[[
Name = <string> - The name of the bind.
Default = <keycode> - The default value of the bind.
Hold = <bool> - Makes the bind work like: Holding the key > The bind returns true, Not holding the key > Bind returns false.
Callback = <function> - The function of the bind.
]]

local Tab = Window:MakeTab({
	Name = "Auto Eat",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local isFirstExecution = true
local isSpamming = false

local function executeScript()
    local args = {
        [1] = 378,
        [2] = "Eat"
    }
    
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("InventoryInteraction"):FireServer(unpack(args))
end

local function spamInventoryInteractionEvent()
    while isSpamming do
        local args = {
            [1] = 378,
            [2] = "Eat"
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("InventoryInteraction"):FireServer(unpack(args))
        wait()
    end
end

Tab:AddToggle({
    Name = "Spam Pumpkins",
    Default = false,
    Callback = function(Value)
        if isFirstExecution then
            isFirstExecution = false
            executeScript()
        else
            isSpamming = Value
            if isSpamming then
                spawn(spamInventoryInteractionEvent)
            end
        end
    end
})


Tab:AddBind({
	Name = "Eat Pumpkin",
	Default = Enum.KeyCode.E,
	Hold = false,
	Callback = function()
		local args = {
    [1] = 378,
    [2] = "Eat"
}

game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("InventoryInteraction"):FireServer(unpack(args))

	end    
})

--[[
Name = <string> - The name of the bind.
Default = <keycode> - The default value of the bind.
Hold = <bool> - Makes the bind work like: Holding the key > The bind returns true, Not holding the key > Bind returns false.
Callback = <function> - The function of the bind.
]]



--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]

local Tab = Window:MakeTab({
	Name = "Dupe",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})
Tab:AddLabel("SOUL CRAFT")

Tab:AddButton({
	Name = "Craft Soul Helmet",
	Callback = function()
      		local A_1 = 201 local Event = game:GetService("ReplicatedStorage").References.Comm.Events.CraftItem Event: FireServer(A_1)
  	end    
})

Tab:AddButton({
	Name = "Craft Soul Body",
	Callback = function()
      		local A_1 = 202 local Event = game:GetService("ReplicatedStorage").References.Comm.Events.CraftItem Event: FireServer(A_1)
  	end    
})

Tab:AddButton({
	Name = "Craft Soul Leg",
	Callback = function()
      		local A_1 = 203 local Event = game:GetService("ReplicatedStorage").References.Comm.Events.CraftItem Event: FireServer(A_1)
  	end    
})

Tab:AddButton({
	Name = "Craft Soul Boots",
	Callback = function()
      		local A_1 = 204 local Event = game:GetService("ReplicatedStorage").References.Comm.Events.CraftItem Event: FireServer(A_1)
  	end    
})

Tab:AddButton({
	Name = "Craft Soul Sheild",
	Callback = function()
      		local A_1 = 218 local Event = game:GetService("ReplicatedStorage").References.Comm.Events.CraftItem Event: FireServer(A_1)
  	end    
})
Tab:AddButton({
	Name = "Craft Soul Sword",
	Callback = function()
      		local A_1 = 216 local Event = game:GetService("ReplicatedStorage").References.Comm.Events.CraftItem Event: FireServer(A_1)
  	end    
})
--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddLabel("YOU NEED TO HAVE A WOOD CHEST PLAECD")
Tab:AddLabel("Chest Out")

Tab:AddButton({
	Name = "Soul Helmet In",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = true
    local A_3 = 201
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddButton({
	Name = "Soul Body In",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = true
    local A_3 = 202
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})

Tab:AddButton({
	Name = "Soul Leg In",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = true
    local A_3 = 203
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})


Tab:AddButton({
	Name = "Soul Boot In",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = true
    local A_3 = 204
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})

Tab:AddButton({
	Name = "Soul Sheild In",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = true
    local A_3 = 218
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})

Tab:AddButton({
	Name = "Soul Sword In",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = true
    local A_3 = 216
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})

Tab:AddLabel("Chest Out")

Tab:AddButton({
	Name = "Soul Helmet Out",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = false
    local A_3 = 201
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddButton({
	Name = "Soul Body Out",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = false
    local A_3 = 202
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})

Tab:AddButton({
	Name = "Soul Leg Out",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = false
    local A_3 = 203
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})


Tab:AddButton({
	Name = "Soul Boot Out",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = false
    local A_3 = 204
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})


Tab:AddButton({
	Name = "Soul Sheild Out",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = false
    local A_3 = 218
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})

Tab:AddButton({
	Name = "Soul Sword Out",
	Callback = function()
      		 local A_1 = game:GetService("Workspace").Replicators.NonPassive["Wood Storage Chest"]
    local A_2 = false
    local A_3 = 216
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)
  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]


local Tab = Window:MakeTab({
	Name = "Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local spamEnabled = false
local isSpamming = false

local function spamToolActionEvent()
    while isSpamming do
        local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Golem"]
        local Event = game:GetService("ReplicatedStorage").References.Comm.Events.ToolAction
        Event:FireServer(A_1)
        wait()
    end
end

Tab:AddToggle({
    Name = "Obsidian Golem",
    Default = false,
    Callback = function(Value)
        spamEnabled = Value
        if spamEnabled then
            if not isSpamming then
                isSpamming = true
                spawn(spamToolActionEvent)
            end
        else
            isSpamming = false
        end
    end
})


local spamEnabled = false
local isSpamming = false

local function spamToolActionEvent()
    while isSpamming do
        local A_1 = game:GetService("Workspace").Replicators.NonPassive["Mushroom Spirit"]
        local Event = game:GetService("ReplicatedStorage").References.Comm.Events.ToolAction
        Event:FireServer(A_1)
        wait()
    end
end

Tab:AddToggle({
    Name = "Mushrumm Spirit",
    Default = false,
    Callback = function(Value)
        spamEnabled = Value
        if spamEnabled then
            if not isSpamming then
                isSpamming = true
                spawn(spamToolActionEvent)
            end
        else
            isSpamming = false
        end
    end
})

--[[
Name = <string> - The name of the toggle.
Default = <bool> - The default value of the toggle.
Callback = <function> - The function of the toggle.
]]

local spamEnabled = false
local isSpamming = false

local function spamToolActionEvent()
    while isSpamming do
        local A_1 = game:GetService("Workspace").Replicators.NonPassive["Zenyte Golem"]
        local Event = game:GetService("ReplicatedStorage").References.Comm.Events.ToolAction
        Event:FireServer(A_1)
        wait()
    end
end

Tab:AddToggle({
    Name = "Zenyte Golem",
    Default = false,
    Callback = function(Value)
        spamEnabled = Value
        if spamEnabled then
            if not isSpamming then
                isSpamming = true
                spawn(spamToolActionEvent)
            end
        else
            isSpamming = false
        end
    end
})

local spamEnabled = false
local isSpamming = false

local function spamToolActionEvent()
    while isSpamming do
        local A_1 = game:GetService("Workspace").Replicators.Both["Orange Slime"]
        local Event = game:GetService("ReplicatedStorage").References.Comm.Events.ToolAction
        Event:FireServer(A_1)
        wait()
    end
end

Tab:AddToggle({
    Name = "Mob",
    Default = false,
    Callback = function(Value)
        spamEnabled = Value
        if spamEnabled then
            if not isSpamming then
                isSpamming = true
                spawn(spamToolActionEvent)
            end
        else
            isSpamming = false
        end
    end
})


local Tab = Window:MakeTab({
	Name = "Auto Sell",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})



Tab:AddLabel("Sheilds")


local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 27
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Ruby Shield",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 28
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Diamond Shield",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 29
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Zenyte Shield",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 30
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Obsidian Shield",
    Default = false,
    Callback = ToggleCallback
})

Tab:AddLabel("Armours")

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 31
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Ruby Helmet",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 32
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Ruby Body",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 33
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Ruby Legs",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 34
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Ruby Boots",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 35
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Diamond Helmet",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 36
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Diamond Body",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 37
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Diamond Leg",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 38
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Diamond Boots",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 39
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Zenyte Helmet",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 40
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Zenyte Body",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 41
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Zenyte Leg",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 42
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Zenyte Boot",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 43
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Obsidian Helmet",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 44
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Obsidian Body",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 45
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Obsidian Leg",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 46
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Obsidian boot",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 47
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Moonstone Helmet",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 48
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Moonstone Body",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 49
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Moonstone Leg",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 50
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Moonstone Boot",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Armour Trader",
        [2] = 51
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Soull Boot And Lucky boot for springy booots",
    Default = false,
    Callback = ToggleCallback
})

Tab:AddParagraph("Weapon Trader","")

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Weapon Trader",
        [2] = 10
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Silver Crossbow",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Weapon Trader",
        [2] = 11
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Silver Sword",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Weapon Trader",
        [2] = 12
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Golden Sword",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Weapon Trader",
        [2] = 13
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Golden Bow",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Weapon Trader",
        [2] = 14
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Ruby Sword",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Weapon Trader",
        [2] = 15
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Diamond Sword",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Weapon Trader",
        [2] = 16
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Diamond Crossbow",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Weapon Trader",
        [2] = 17
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Zenyte Sword",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Weapon Trader",
        [2] = 18
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "Zenyte Crossbow",
    Default = false,
    Callback = ToggleCallback
})


Tab:AddParagraph("Resource Trader","")

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 14
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "4 Silver = 1 Token",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 15
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "4 Slime Ball = 1 Token",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 16
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "2 Gold Bar = 1 Token",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 17
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "1 Ruby = 3 Token",
    Default = false,
    Callback = ToggleCallback
})



local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 18
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "1 Diamond = 4 Token",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 19
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "1 Zen = 6 Token",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 20
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "3 Pumpkin = 1 Token",
    Default = false,
    Callback = ToggleCallback
})
local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 21
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "5 Candy = 1 Token",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 22
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "1 Soul = 5 Token",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 23
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "1 Volcanic Ore = 15 Token",
    Default = false,
    Callback = ToggleCallback
})


local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 24
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "1 Obsidian = 20 Token",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 25
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "1 Lunar Ore = 25 Token",
    Default = false,
    Callback = ToggleCallback
})

local isExecuting = false

-- Function to execute the code
local function ExecuteCode()
    local args = {
        [1] = "Resource Trader",
        [2] = 26
    }
    
    -- Trigger the TradeTrader event
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("TradeTrader"):FireServer(unpack(args))
end

-- Callback function for the toggle
local function ToggleCallback(value)
    if value then
        -- Start executing the code
        isExecuting = true
        while isExecuting do
            ExecuteCode()
            wait()  -- Adjust the wait time between executions if needed
        end
    else
        -- Stop executing the code
        isExecuting = false
    end
end

-- Example usage with the toggle
Tab:AddToggle({
    Name = "1 Moonstone = 30 Token",
    Default = false,
    Callback = ToggleCallback
})

--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]
--[[
Name = <string> - The name of the toggle.
Default = <bool> - The default value of the toggle.
Callback = <function> - The function of the toggle.
]]




local Tab = Window:MakeTab({
	Name = "Finder",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddLabel("Events")

Tab:AddButton({
	Name = "Tp To Mega Candy Rock",
	Callback = function()
      		local chest = nil


local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Mega Candy Rock" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end


findTreasureChest(workspace)

if chest and chest:IsDescendantOf(workspace) then

    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)


    wait(0.5)


    local endTime = os.time() + 5
    while os.time() < endTime do

        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

     
        wait(0.1)
    end

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
else
    OrionLib:MakeNotification({
	Name = "",
	Content = "Mega Candy Rock Not Found :(",
	Image = "rbxassetid://4483345998",
	Time = 5
})

end
  	end    
})

Tab:AddButton({
	Name = "Asteroid",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Asteroid" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Asteroid successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "We can't find an Asteroid.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find an Asteroid.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddLabel("Items")

Tab:AddButton({
	Name = "Candy",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Candy" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Candy successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "We can't find an Candy.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Candy.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddButton({
	Name = "Pile of Candy",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Pile of Candy" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Pile Of Candy successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "We can't find a Pile Of Candy.",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Pile Of Candy.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddLabel("patches")

Tab:AddButton({
	Name = "Potato Patch",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Potato Patch" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Carrot Patch successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Potato Patch successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Carrot Patch.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]
--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]
--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddButton({
	Name = "Cabbage Patch",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Cabbage Patch" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Cabbage Patch successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Cabbage Patch successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Cabbage Patch.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddButton({
	Name = "Watermelon Patch",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Watermelon Patch" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Watermelon Patch successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Watermelon Patch successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Watermelon Patch.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]
--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]
Tab:AddButton({
	Name = "Carrot Patch",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Carrot Patch" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Carrot Patch successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Carrot Patch successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Carrot Patch.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddLabel("Boss")

Tab:AddButton({
	Name = "Obsidian Golem",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Obsidian Golem" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Obsidian Golem successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Obsidian Golem successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Obsidian Golem.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddButton({
	Name = "Ogre",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Ogre" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Ogre successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Ogre successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Ogre.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})


Tab:AddButton({
	Name = "Lucky Slime",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Lucky Slime" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Lucky Slime successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Lucky Slime successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Lucky Slime.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddLabel("Ores")



Tab:AddButton({
	Name = "Silver Rock",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Silver Rock" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Silver Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Silver Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Silver Rock.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})


Tab:AddButton({
	Name = "Gold Rock",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Gold Rock" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Gold Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Volcanic Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Gold Rock.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddButton({
	Name = "Ruby Rock",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Ruby Rock" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Volcanic Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Ruby Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Ruby Rock.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddButton({
	Name = "Diamond Rock",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Diamond Rock" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Diamond Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Diamond Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Diamond Rock.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddButton({
	Name = "Zenyte Rock",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Zenyte Rock" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Zenyte Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Zenyte Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Zenyte Rock.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddButton({
	Name = "Volcanic Rock",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Volcanic Rock" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Volcanic Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Volcanic Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Volcanic Rock.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

Tab:AddButton({
	Name = "Magic Rock",
	Callback = function()
      		local chest = nil

-- Function to recursively search for the treasure chest
local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Magic Rock" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end

-- Start the search from the workspace
findTreasureChest(workspace)

-- Confirming the existence and accessibility of the treasure chest
if chest and chest:IsDescendantOf(workspace) then
    -- Briefly acquiring the adventurer's physical presence
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    -- Teleport the character near the treasure chest
    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition + Vector3.new(0, 5, 0))

    -- Relishing the anticipation during a momentary pause
    wait(0.5)

    -- Loop to pick up the treasure chest for 5 seconds
    local endTime = os.time() + 5
    while os.time() < endTime do
        -- Initiating the pickup procedure to seize the treasure
        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

        -- Wait for a short interval before picking up again
        wait(0.1)
    end

    -- Ensuring the adventurer's safe return to their original abode
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)

    -- Check if the chest was successfully acquired
    if not chest:IsDescendantOf(game.Workspace) then
        -- Display the success notification with a mischievous twist
        OrionLib:MakeNotification({
            Name = "",
            Content = "Magic Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    else
        -- Display the failure notification with a rebellious touch
        OrionLib:MakeNotification({
            Name = "",
            Content = "Magic Rock successfully acquired",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
else
    -- Display the failure notification with a rebellious touch
    OrionLib:MakeNotification({
        Name = "",
        Content = "We can't find a Magic Rock.",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

  	end    
})

--[[
Name = <string> - The name of the tab.
Icon = <string> - The icon of the tab.
PremiumOnly = <bool> - Makes the tab accessible to Sirus Premium users only.
]]

local Tab = Window:MakeTab({
	Name = "Chest",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Buy Easy Chest",
	Callback = function()
      		local args = {
    [1] = 1
}

game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("BuyWorldEvent"):FireServer(unpack(args))

  	end    
})




Tab:AddButton({
	Name = "Buy Medium Chest",
	Callback = function()
      		local args = {
    [1] = 2
}

game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("BuyWorldEvent"):FireServer(unpack(args))

  	end    
})




Tab:AddButton({
	Name = "Buy Hard Chest",
	Callback = function()
      		local args = {
    [1] = 3
}

game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("BuyWorldEvent"):FireServer(unpack(args))

  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddButton({
	Name = "Open Easy Chest",
	Callback = function()
      		local args = {
    [1] = 166,
    [2] = "Open"
}

game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("InventoryInteraction"):FireServer(unpack(args))

  	end    
})


Tab:AddButton({
	Name = "Open Medium Chest",
	Callback = function()
      		local args = {
    [1] = 167,
    [2] = "Open"
}

game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("InventoryInteraction"):FireServer(unpack(args))

  	end    
})

Tab:AddButton({
	Name = "Open Hard Chest",
	Callback = function()
      		local args = {
    [1] = 168,
    [2] = "Open"
}

game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("InventoryInteraction"):FireServer(unpack(args))

  	end    
})

Tab:AddButton({
	Name = "POLPL!",
	Callback = function()
      		local function findTreasureChest(parent)
    local chest = nil
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Treasure Chest (Medium)" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            chest = findTreasureChest(child)
            if chest then
                break
            end
        end
    end
    return chest
end

local function interactWithChest(chest)
    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    while chest and chest:IsDescendantOf(workspace) do
        local teleportPosition = chest:GetBoundingBox().Position
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)
        wait(0.5)
        local endTime = os.time() + 5
        while os.time() < endTime do
            local args = {
                [1] = chest.PrimaryPart,
                [2] = "Pickup"
            }
            game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))
            wait(0.1)
        end
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
        wait(0.5) -- Wait for character to settle before auto pickup
        autoPickupNearbyItems()
        chest = findTreasureChest(workspace)
    end
end

local function hasMediumChests()
    local chest = findTreasureChest(workspace)
    return chest and chest:IsDescendantOf(workspace)
end

local function autoPickupNearbyItems()
    local function getNearbyItems()
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        local items = {}

        if character then
            local playerPosition = character.PrimaryPart.Position

            for _, item in ipairs(game:GetService("Workspace"):GetDescendants()) do
                if item:IsA("Model") and item.PrimaryPart then
                    local itemPosition = item.PrimaryPart.Position
                    local distance = (playerPosition - itemPosition).Magnitude

                    if distance <= 5 then -- Adjust the distance as needed
                        table.insert(items, item)
                    end
                end
            end
        end

        return items
    end

    local itemInteractedEvent = game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted

    local items = getNearbyItems()
    for i = 1, #items do
        local item = items[i]
        local success = pcall(function()
            itemInteractedEvent:FireServer(item, "Pickup")
        end)
        if not success then
            warn("Failed to pick up item:", item.Name)
        end
        wait() -- Wait a short time before moving on to the next item
    end
end

local function buyAndInteractWithChest()
    local args = {
        [1] = 2
    }
    game:GetService("ReplicatedStorage"):WaitForChild("References"):WaitForChild("Comm"):WaitForChild("Events"):WaitForChild("BuyWorldEvent"):FireServer(unpack(args))

    wait(0.5) -- Allow time for the purchase to take effect

    local chest = findTreasureChest(workspace)
    if chest and chest:IsDescendantOf(workspace) then
        interactWithChest(chest)
        return true
    end

    return false
end

local function performActions()
    while true do
        local success = buyAndInteractWithChest()
        if not success then
            break
        end
    end
end

performActions()

  	end    
})

--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddButton({
	Name = "Tp To Easy Chest",
	Callback = function()
      		local chest = nil


local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Treasure Chest (Easy)" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end


findTreasureChest(workspace)

if chest and chest:IsDescendantOf(workspace) then

    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)


    wait(0.5)


    local endTime = os.time() + 5
    while os.time() < endTime do

        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

     
        wait(0.1)
    end

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
else
    OrionLib:MakeNotification({
	Name = "",
	Content = "We can't find an Easy Chest.",
	Image = "rbxassetid://4483345998",
	Time = 5
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
end
  	end    
})

Tab:AddButton({
	Name = "Tp To Medium Chest",
	Callback = function()
      		local chest = nil


local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Treasure Chest (Medium)" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end


findTreasureChest(workspace)

if chest and chest:IsDescendantOf(workspace) then

    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)


    wait(0.5)


    local endTime = os.time() + 5
    while os.time() < endTime do

        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

     
        wait(0.1)
    end

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
else
    OrionLib:MakeNotification({
	Name = "",
	Content = "We can't find an Medium chest.",
	Image = "rbxassetid://4483345998",
	Time = 5
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
end
  	end    
})



Tab:AddButton({
	Name = "Tp To Hard Chest",
	Callback = function()
      		local chest = nil


local function findTreasureChest(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child.Name == "Treasure Chest (Hard)" then
            chest = child
            break
        elseif child:IsA("Model") or child:IsA("Folder") then
            findTreasureChest(child)
        end
    end
end


findTreasureChest(workspace)

if chest and chest:IsDescendantOf(workspace) then

    local originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position

    local teleportPosition = chest:GetBoundingBox().Position
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(teleportPosition)


    wait(0.5)


    local endTime = os.time() + 5
    while os.time() < endTime do

        local args = {
            [1] = chest.PrimaryPart,
            [2] = "Pickup"
        }
        game:GetService("ReplicatedStorage").References.Comm.Events.ItemInteracted:FireServer(unpack(args))

     
        wait(0.1)
    end

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
else
    OrionLib:MakeNotification({
	Name = "",
	Content = "We can't find an Hard Chest.",
	Image = "rbxassetid://4483345998",
	Time = 5
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
end
  	end    
})

local Tab = Window:MakeTab({
	Name = "Mic",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

Tab:AddButton({
	Name = "Equip / Unequip Obsidian Set",
	Callback = function()
-- ob helmet
local A_1 = 225
local A_2 = "Equip"
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.InventoryInteraction
Event:FireServer(A_1, A_2)

-- ob body
local A_1 = 226
local A_2 = "Equip"
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.InventoryInteraction
Event:FireServer(A_1, A_2)

-- ob leg 
local A_1 = 227
local A_2 = "Equip"
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.InventoryInteraction
Event:FireServer(A_1, A_2)

--ob boots
local A_1 = 228
local A_2 = "Equip"
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.InventoryInteraction
Event:FireServer(A_1, A_2)


  	end    
})

Tab:AddButton({
	Name = "Equip / Unequip Soul Set",
	Callback = function()
-- Soul helmet
local A_1 = 201
local A_2 = "Equip"
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.InventoryInteraction
Event:FireServer(A_1, A_2)

-- Soul body
local A_1 = 202
local A_2 = "Equip"
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.InventoryInteraction
Event:FireServer(A_1, A_2)

-- Soul leg 
local A_1 = 203
local A_2 = "Equip"
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.InventoryInteraction
Event:FireServer(A_1, A_2)

--Soul boots
local A_1 = 204
local A_2 = "Equip"
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.InventoryInteraction
Event:FireServer(A_1, A_2)


  	end    
})


--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]

Tab:AddButton({
	Name = "Anti-AFK script",
	Callback = function()
      		local success, error = pcall(function()
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end)

if success then
    OrionLib:MakeNotification({
	Name = "",
	Content = "Anti-AFK script executed successfully.",
	Image = "rbxassetid://4483345998",
	Time = 5
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
else
OrionLib:MakeNotification({
	Name = "Error",
	Content = "Error occurred while executing the anti-AFK script",
	Image = "rbxassetid://4483345998",
	Time = 5
})

--[[
Title = <string> - The title of the notification.
Content = <string> - The content of the notification.
Image = <string> - The icon of the notification.
Time = <number> - The duration of the notfication.
]]
end

  	end    
})



Tab:AddBind({
	Name = "ob to chest",
	Default = Enum.KeyCode.F2,
	Hold = false,
	Callback = function()
		      		
    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = true
    local A_3 = 227
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = true
    local A_3 = 228
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = true
    local A_3 = 226
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = true
    local A_3 = 225
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = true
    local A_3 = 369
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 219  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

    wait(10) -- Delay for 5 seconds before executing the next block of code

    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = false
    local A_3 = 227
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = false
    local A_3 = 228
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = false
    local A_3 = 226
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = false
    local A_3 = 225
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

    local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
    local A_2 = false
    local A_3 = 369
    local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
    Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 219  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

	end    
})

--[[
Name = <string> - The name of the bind.
Default = <keycode> - The default value of the bind.
Hold = <bool> - Makes the bind work like: Holding the key > The bind returns true, Not holding the key > Bind returns false.
Callback = <function> - The function of the bind.
]]



Tab:AddBind({
	Name = "moonitem to chest",
	Default = Enum.KeyCode.F2,
	Hold = false,
	Callback = function()
		local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"] -- change the chest to what chest it is
local A_2 = true -- if true it puts in
local A_3 = 369  -- ID of the item, NOTE: ( NOT SOUL ) ( ID OF THE ITEMS,BOOKS CAN BE PURCHASED VIA WHATEVER DISCORD SERVER)
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)





 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = true -- if true it puts in
local A_3 = 366  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)




 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = true -- if true it puts in
local A_3 = 365  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)



 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = true -- if true it puts in
local A_3 = 363  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)



 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = true -- if true it puts in
local A_3 = 364  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
            local A_2 = true -- if true it puts in
            local A_3 = 219  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)

wait(10) -- Delay for 5 seconds before executing the next block of code

 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"] -- change the chest to what chest it is
local A_2 = false -- if true it puts in
local A_3 = 369  -- ID of the item, NOTE: ( NOT SOUL ) ( ID OF THE ITEMS,BOOKS CAN BE PURCHASED VIA WHATEVER DISCORD SERVER)
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)





 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 366  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)




 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 365  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)



 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 363  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)



 
local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 364  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
            local A_2 = false -- if true it puts in
            local A_3 = 219  -- id of the item, NOTE: ( NOT SOUL )
            local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
            Event:FireServer(A_1, A_2, A_3)
	end    
})

Tab:AddButton({
	Name = "Get Candy From Chest",
	Callback = function()
      		local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 181  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Moonstone Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 181  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)
  	end    
})

Tab:AddButton({
	Name = "Get Volcanic Ore From Chest",
	Callback = function()
      		local A_1 = game:GetService("Workspace").Replicators.NonPassive["Obsidian Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 233  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)

local A_1 = game:GetService("Workspace").Replicators.NonPassive["Moonstone Storage Chest"]
local A_2 = false -- if true it puts in
local A_3 = 233  -- id of the item, NOTE: ( NOT SOUL )
local Event = game:GetService("ReplicatedStorage").References.Comm.Events.UpdateStorageChest
Event:FireServer(A_1, A_2, A_3)
  	end    
})


--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]
--[[
Name = <string> - The name of the button.
Callback = <function> - The function of the button.
]]