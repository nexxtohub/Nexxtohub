
-- NexxtoHub | Steal a Brainrot (Rayfield UI)
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "NexxtoHub | Steal a Brainrot",
    LoadingTitle = "Loading NexxtoHub...",
    LoadingSubtitle = "by Ian/Nexxto",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = { Enabled = false },
    KeySystem = false
})

local MainTab = Window:CreateTab("Main", 4483362458)

-- Anti Kick
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    if getnamecallmethod() == "Kick" then return end
    return old(self, ...)
end)

-- ESP Toggle
MainTab:CreateToggle({
    Name = "ESP (Red Highlight)",
    CurrentValue = false,
    Callback = function(v)
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("ESP_HL")
                if v and not hl then
                    hl = Instance.new("Highlight", p.Character)
                    hl.Name = "ESP_HL"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                    hl.FillTransparency = 0.4
                elseif not v and hl then
                    hl:Destroy()
                end
            end
        end
    end
})

-- Speed
local speed = 2
local speedOn = false

MainTab:CreateInput({
    Name = "Speed Value",
    PlaceholderText = "2",
    RemoveTextAfterFocusLost = false,
    Callback = function(txt)
        local val = tonumber(txt)
        if val then speed = math.clamp(val, 1, 100) end
    end
})

MainTab:CreateToggle({
    Name = "Speed Boost",
    CurrentValue = false,
    Callback = function(state)
        speedOn = state
    end
})

game:GetService("RunService").Heartbeat:Connect(function()
    if speedOn then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local root = char.HumanoidRootPart
            local dir = char.Humanoid.MoveDirection
            root.Velocity = dir * speed
        end
    end
end)

-- Multi Jump
MainTab:CreateToggle({
    Name = "Multi Jump",
    CurrentValue = false,
    Callback = function(state)
        _G.MultiJump = state
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.MultiJump then
        local h = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if h then h:ChangeState("Jumping") end
    end
end)

-- Godmode
MainTab:CreateToggle({
    Name = "Godmode",
    CurrentValue = false,
    Callback = function(state)
        _G.God = state
        local h = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if h then
            h:GetPropertyChangedSignal("Health"):Connect(function()
                if _G.God then h.Health = h.MaxHealth end
            end)
        end
    end
})

-- Anti Ragdoll
game:GetService("RunService").Stepped:Connect(function()
    local c = game.Players.LocalPlayer.Character
    if c then
        for _, v in pairs(c:GetDescendants()) do
            if v:IsA("BallSocketConstraint") or v.Name:lower():find("ragdoll") then
                v:Destroy()
            end
        end
    end
end)

-- AUTO BUY TAB
local AutoTab = Window:CreateTab("Auto Buy", 4483345998)

local brainrots = {
    "Burbaloni Loliloli", "Chimpanzini Bananini", "Ballerina Cappuccina",
    "Chef Crabracadabra", "Glorbo Fruttodrillo", "Blueberrinni Octopusini",
    "Frigo Camelo", "Orangutini Ananassini", "Rhino Toasterino",
    "Bombardiro Crocodilo", "Bombombini Gusini", "Cavallo Virtuoso",
    "Cocofanto Elefanto", "Girafa Celestre", "Matteo", "Tralalero Tralala",
    "Odin Din Din Dun", "Unclito Samito", "Trenostruzzo Turbo 3000",
    "La Vacca Saturno Saturnita", "Sammyni Spiderini", "Los Tralaleritos",
    "Graipuss Medussi", "La Grande Combinazione", "Garama and Madundung"
}

local mutations = {
    "Gold Mutation", "Diamond Mutation", "Blood Mutation",
    "Rainbow Mutation", "Celestial Mutation"
}

local selectedBrainrot = brainrots[1]
local selectedMutation = mutations[1]

AutoTab:CreateDropdown({
    Name = "Select Brainrot",
    Options = brainrots,
    CurrentOption = selectedBrainrot,
    Callback = function(v)
        selectedBrainrot = v
    end
})

AutoTab:CreateDropdown({
    Name = "Select Mutation",
    Options = mutations,
    CurrentOption = selectedMutation,
    Callback = function(v)
        selectedMutation = v
    end
})

AutoTab:CreateButton({
    Name = "Buy Selected Brainrot",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") and v.Name:lower():find(selectedBrainrot:lower()) then
                fireproximityprompt(v)
            end
        end
    end
})
