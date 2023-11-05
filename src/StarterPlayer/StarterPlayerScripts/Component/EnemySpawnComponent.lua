--[[
    Enemy spawns are used to represent locations at which enemies may be spawned.
    The `spawn()` function may be called to create an enemy.
]]--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Component = require(ReplicatedStorage.Packages.Component)
local Components = script.Parent
local EnemyComponent = require(Components.EnemyComponent)

local component = Component.new {
    Tag = "EnemySpawn",
    Ancestors = { workspace }
}

--[[
    Spawns a new enemy at this spawn location.
]]--
function component:spawn()
    EnemyComponent.new()
    :andThen(function(enemy)
        local instances = enemy:getInstances()
        local hipHeight = instances.humanoid.HipHeight
        local pivotCFrame = self.Instance:GetPivot()
        local spawnPosition = pivotCFrame.Position + (Vector3.yAxis * hipHeight)
        instances.humanoidRootPart.Position = spawnPosition
        enemy.Instance.Parent = workspace
    end)
end

function component:getPivot()
    return self.Instance:GetPivot()
end

-- This is temporary! It should be controlled by an event that is fired when a
-- player enters the region.
function component:Start()
    warn("TODO: Enemy spawn event logic")
    self:spawn()
end

return component