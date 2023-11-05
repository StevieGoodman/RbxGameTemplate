local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Promise = require(ReplicatedStorage.Packages.Promise)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

local PLAYER = Players.LocalPlayer

local component = Component.new {
    Tag = "Enemy",
    Ancestors = { workspace }
}

function component._createHumanoidModel(userId: number)
    return Promise.new(function(resolve, reject)
        Promise.try(function()
            return Players:CreateHumanoidModelFromUserId(userId)
        end)
        :andThen(function(humanoidModel)
            humanoidModel:AddTag("Enemy")
            humanoidModel.Parent = workspace
            component:WaitForInstance(humanoidModel, 1)
            :andThen(resolve)
            :catch(reject)
        end)
    end)
end

function component.new()
    -- Promise.try(function()
    --     return Players:GetFriendsAsync(PLAYER.UserId)
    -- end)
    -- :andThen(function(friendPages: FriendPages)
    --     local friendIds = {}
    --     while not friendPages.IsFinished do
    --         table.insert(friendIds, friendPages:GetCurrentPage().Id)
    --         friendPages:AdvanceToNextPageAsync()
    --     end
    --     print(`{PLAYER} has {#friendIds} friends!`)
    -- end)
    -- :catch(function(error)
    --     error(`Unable to get friends for {PLAYER}: {error}`)
    -- end)
    return Promise.new(function(resolve, reject)
        component._createHumanoidModel(PLAYER.UserId)
        :andThen(resolve)
        :catch(reject)
    end)
end

function component:getInstances()
    local instances = Waiter.CollectDescendants(
        self.Instance,
        {
            humanoid = { ClassName = "Humanoid" },
            humanoidRootPart = { ClassName = "Part", Name = "HumanoidRootPart" },
        }
    )
    return instances
end

function component:Construct()
    
end

function component:Start()
    self.Instance.Name = "Enemy"
end

return component