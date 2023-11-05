--------------- ╭──────────╮ ---------------
--------------- │ SERVICES │ ---------------
--------------- ╰──────────╯ ---------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--------------- ╭──────────╮ ---------------
--------------- │ PACKAGES │ ---------------
--------------- ╰──────────╯ ---------------
local Knit = require(ReplicatedStorage.Packages.Knit)
local Observers = require(ReplicatedStorage.Packages.Observers)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

-------------- ╭───────────╮ ---------------
-------------- │ FUNCTIONS │ ---------------
-------------- ╰───────────╯ ---------------
function _onCharacterSpawn(_, character)
    local humanoid = Waiter.WaitForChild(1, character, { Name = "Humanoid" }) :: Humanoid
    local humanoidRoot = character.HumanoidRootPart :: BasePart
    local angular = humanoidRoot.AngularVelocity
    local camera = workspace.CurrentCamera
    character:WaitForChild("Animate", 2)
    if character:FindFirstChild("Animate") then
        character.Animate:Destroy()
    end
    local jumpCooldown = 0

    humanoid.PlatformStand = true
    humanoid.CameraOffset = Vector3.new(0, -1.5, 0)

    local connection = RunService.Stepped:Connect(function(_, dt)
        -- Move character
        local moveVector = humanoid.MoveDirection
        moveVector = moveVector:Cross(-camera.CFrame.UpVector)
        angular.AngularVelocity = moveVector * script:GetAttribute("MoveSpeed")
        -- Jump character
        jumpCooldown = math.clamp(jumpCooldown - dt, 0, math.huge)
        if jumpCooldown > 0 then return end
        if not humanoid.Jump then return end
        humanoid.Jump = false
        jumpCooldown = 5
        humanoidRoot.AssemblyLinearVelocity += Vector3.new(0, script:GetAttribute("JumpVerticalPower"), 0)
        local boostVector = camera.CFrame.LookVector
        humanoidRoot.AssemblyLinearVelocity += boostVector * script:GetAttribute("JumpHorizontalPower")
    end)

    return function()
        connection:Disconnect()
    end
end

function _start(self)
    Observers.observeCharacter(_onCharacterSpawn)
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
local controller = Knit.CreateController {
    Name      = "Character",
    KnitStart = _start,
}

return controller