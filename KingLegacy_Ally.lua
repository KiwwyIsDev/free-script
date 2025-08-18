repeat task.wait(1) until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer:FindFirstChild("DataLoaded")

local AlliesFolder = LocalPlayer:WaitForChild("Allies")
local Chest = ReplicatedStorage:WaitForChild("Chest")
local AllyRemote = Chest.Remotes.Functions.Ally

local function AcceptAll()
    local pending = AllyRemote:InvokeServer({ Action = "Get" })
    if typeof(pending) == "table" then
        for name, _ in pairs(pending) do
            task.defer(function()
                AllyRemote:InvokeServer({ Action = "Accept", Target = name })
            end)
        end
    end
end

local function InviteAll()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and not AlliesFolder:FindFirstChild(plr.Name) then
            task.defer(function()
                AllyRemote:InvokeServer({ Action = "Invite", Target = plr.Name })
            end)
        end
    end
end

-- AcceptAll()

-- auto accept 
ReplicatedStorage.Chest.Remotes.Events.AllyUpdater.OnClientEvent:Connect(AcceptAll)

task.spawn(function()
    while task.wait(60) do
        InviteAll()
    end
end)