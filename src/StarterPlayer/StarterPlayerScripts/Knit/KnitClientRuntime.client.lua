--------------- ╭──────────╮ ---------------
--------------- │ SERVICES │ ---------------
--------------- ╰──────────╯ ---------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--------------- ╭──────────╮ ---------------
--------------- │ PACKAGES │ ---------------
--------------- ╰──────────╯ ---------------
local Knit = require(ReplicatedStorage.Packages.Knit)
local Waiter = require(ReplicatedStorage.Packages.Waiter)

-------------- ╭───────────╮ ---------------
-------------- │ FUNCTIONS │ ---------------
-------------- ╰───────────╯ ---------------
function SetUpKnit()
    Knit.AddControllers(script.Parent.Controllers)
    Knit.Start()
    :andThen(function()
        local playerScripts = Waiter.GetAncestor(script, { ClassName = "PlayerScripts" })
        local componentFolder = Waiter.WaitForChild(1, playerScripts, { Name = "Component" })
        for _, component in Waiter.GetDescendants(componentFolder, { ClassName = "ModuleScript" }) do
            require(component)
        end
    end)
    :andThenCall(print, "Knit has successfully started on the client!")
    :catch(function() error("Unable to start Knit on the client!") end)
end

------------ ╭────────────────╮ ------------
------------ │ INITIALISATION │ ------------
------------ ╰────────────────╯ ------------
SetUpKnit()