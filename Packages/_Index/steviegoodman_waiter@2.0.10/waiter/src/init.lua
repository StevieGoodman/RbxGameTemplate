--[=[
    @class Waiter
    Obtain instances in your game hierarchy with zero fuss!
]=]--

local TABLE_UTIL = require(script.Parent.TableUtil)

--[=[
    @within Waiter
    @interface FilterOptions
    .Tag string? -- Matches against instances with this tag
    .ClassName string? -- Matches against instances with this class name
    .Name string? -- Matches against instances with this name
    .Attributes {string: any?} -- Matches against instances with all of these attributes
]=]--
export type FilterOptions = {
    Tag: string?,
    ClassName: string?,
    Name: string?,
    Attributes: {string: any?}
}

function _Filter(instances: {Instance}, filter: FilterOptions?): {Instance}
    if not filter then
        return instances
    end
    instances = TABLE_UTIL.Filter(instances, function(instance)
        if filter.Tag and instance:HasTag(filter.Tag) then
            return true
        end
        if filter.ClassName and instance.ClassName == filter.ClassName then
            return true
        end
        if filter.Name and instance.Name == filter.Name then
            return true
        end
        if filter.Attributes then
            for attributeName, attributeValue in filter.Attributes do
                if instance:GetAttribute(attributeName) ~= attributeValue then continue end
                return true
            end
        end
        return false
    end)
    return instances
end

--[=[
    @within Waiter
    Returns the children of `origin` matching `filter`.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return {Instance?} -- The instances found (if any).
]=]--
function GetChildren(origin: Instance, filter: FilterOptions?): {Instance?}
    local children = origin:GetChildren()
    local result = _Filter(children, filter)
    return result
end

--[=[
    @within Waiter
    Returns the first child of `origin` matching `filter`.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function GetChild(origin: Instance, filter: FilterOptions?): Instance?
    local result = GetChildren(origin, filter)
    return result[1]
end

--[=[
    @within Waiter
    Collects children with different `FilterOptions` in a table for easy access.
    This is especially useful for collecting key instances in models or user interfaces.
    @param origin Instance -- The instance to use as origin for the search.
    @param filters {string: FilterOptions} -- Dictionary of `FilterOptions`. Results returned using the same indices.
    @return {string: Instance?} -- Dictionary of instances associated with their respective index in `filters`.
]=]--
function CollectChildren(origin: Instance, filters: {string: FilterOptions}): {string: Instance?}
    local result = {}
    for index, filter in filters do
        result[index] = GetChild(origin, filter)
    end
    return result
end

--[=[
    @within Waiter
    Returns the descendants of `origin` matching `filter`.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return {Instance?} -- The instances found (if any).
]=]--
function GetDescendants(origin: Instance, filter: FilterOptions?): {Instance?}
    local descendants = origin:GetDescendants()
    local result = _Filter(descendants, filter)
    return result
end

--[=[
    @within Waiter
    Returns the first descendant of `origin` matching `filter`.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function GetDescendant(origin: Instance, filter: FilterOptions?): Instance?
    local result = GetDescendants(origin, filter)
    return result[1]
end

--[=[
    @within Waiter
    Collects descendants with different `FilterOptions` in a table for easy access.
    This is especially useful for collecting key instances in models or user interfaces.
    @param origin Instance -- The instance to use as origin for the search.
    @param filters {string: FilterOptions} -- Dictionary of `FilterOptions`. Results returned using the same indices.
    @return {string: Instance?} -- Dictionary of instances associated with their respective index in `filters`.
]=]--
function CollectDescendants(origin: Instance, filters: {string: FilterOptions}): {string: Instance?}
    local result = {}
    for index, filter in filters do
        result[index] = GetDescendant(origin, filter)
    end
    return result
end

--[=[
    @within Waiter
    Returns the ancestors of `origin` matching `filter`.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return {Instance?} -- The instances found (if any).
]=]--
function GetAncestors(origin: Instance, filter: FilterOptions?): {Instance?}
    local ancestors = {}
    local current = origin
    repeat
        current = current.Parent
        table.insert(ancestors, current)
    until current.Parent == game
    local result = _Filter(ancestors, filter)
    return result
end

--[=[
    @within Waiter
    Returns the first ancestor of `origin` matching `filter`.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function GetAncestor(origin: Instance, filter: FilterOptions?): Instance?
    local result = GetAncestors(origin, filter)
    return result[1]
end

--[=[
    @within Waiter
    Collects ancestors with different `FilterOptions` in a table for easy access.
    This is especially useful for collecting key instances in models or user interfaces.
    @param origin Instance -- The instance to use as origin for the search.
    @param filters {string: FilterOptions} -- Dictionary of `FilterOptions`. Results returned using the same indices.
    @return {string: Instance?} -- Dictionary of instances associated with their respective index in `filters`.
]=]--
function CollectAncestors(origin: Instance, filters: {string: FilterOptions}): {string: Instance?}
    local result = {}
    for index, filter in filters do
        result[index] = GetAncestor(origin, filter)
    end
    return result
end

--[=[
    @within Waiter
    Returns the siblings of `origin` matching `filter`.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return {Instance?} -- The instances found (if any).
]=]--
function GetSiblings(origin: Instance, filter: FilterOptions?): {Instance?}
    local siblings = GetChildren(origin.Parent, filter)
    return siblings
end

--[=[
    @within Waiter
    Returns the first sibling of `origin` matching `filter`.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function GetSibling(origin: Instance, filter: FilterOptions?): Instance?
    local result = GetSiblings(origin, filter)
    return result[1]
end

--[=[
    @within Waiter
    Collects siblings with different `FilterOptions` in a table for easy access.
    This is especially useful for collecting key instances in models or user interfaces.
    @param origin Instance -- The instance to use as origin for the search.
    @param filters {string: FilterOptions} -- Dictionary of `FilterOptions`. Results returned using the same indices.
    @return {string: Instance?} -- Dictionary of instances associated with their respective index in `filters`.
]=]--
function CollectSiblings(origin: Instance, filters: {string: FilterOptions}): {string: Instance?}
    local result = {}
    for index, filter in filters do
        result[index] = GetSibling(origin, filter)
    end
    return result
end

--[=[
    @within Waiter
    Returns the first child of `origin` matching `filter` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instance being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function WaitForChild(duration: number, origin: Instance, filter: FilterOptions?): Instance?
    local startTime = os.time()
    local result = nil
    repeat
        result = GetChild(origin, filter)
        task.wait()
    until os.time() - startTime > duration or result ~= nil
    return result
end

--[=[
    @within Waiter
    Returns the first children of `origin` matching `filters` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instances being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param filters {string: FilterOptions} -- Dictionary of `FilterOptions`. Results returned using the same indices.
    @return {string: Instance?} -- Dictionary of instances associated with their respective index in `filters`.
]=]--
function WaitCollectChildren(duration: number, origin: Instance, filters: {string: FilterOptions}): {string: Instance?}
    local result = {}
    for index, filter in filters do
        result[index] = WaitForChild(duration, origin, filter)
    end
    return result
end

--[=[
    @within Waiter
    Returns the first descendant of `origin` matching `filter` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instance being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function WaitForDescendant(duration: number, origin: Instance, filter: FilterOptions?): Instance?
    local startTime = os.time()
    local result = nil
    repeat
        result = GetDescendant(origin, filter)
        task.wait()
    until os.time() - startTime > duration or result ~= nil
    return result
end

--[=[
    @within Waiter
    Returns the first descendants of `origin` matching `filters` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instances being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param filters {string: FilterOptions} -- Dictionary of `FilterOptions`. Results returned using the same indices.
    @return {string: Instance?} -- Dictionary of instances associated with their respective index in `filters`.
]=]--
function WaitCollectDescendants(duration: number, origin: Instance, filters: {string: FilterOptions}): {string: Instance?}
    local result = {}
    for index, filter in filters do
        result[index] = WaitForDescendant(duration, origin, filter)
    end
    return result
end

--[=[
    @within Waiter
    Returns the first sibling of `origin` matching `filter` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instance being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param filter FilterOptions? -- If present, only instances that satisfy this filter will be considered.
    @return Instance? -- The instance found (if any).
]=]--
function WaitForSibling(duration: number, origin: Instance, filter: FilterOptions?): Instance?
    local startTime = os.time()
    local result = nil
    repeat
        result = GetSibling(origin, filter)
        task.wait()
    until os.time() - startTime > duration or result ~= nil
    return result
end

--[=[
    @within Waiter
    Returns the first siblings of `origin` matching `filters` found within `duration`.
    @param duration number -- The amount of seconds to wait for the instances being searched for.
    @param origin Instance -- The instance to use as origin for the search.
    @param filters {string: FilterOptions} -- Dictionary of `FilterOptions`. Results returned using the same indices.
    @return {string: Instance?} -- Dictionary of instances associated with their respective index in `filters`.
]=]--
function WaitCollectSiblings(duration: number, origin: Instance, filters: {string: FilterOptions}): {string: Instance?}
    local result = {}
    for index, filter in filters do
        result[index] = WaitForSibling(duration, origin, filter)
    end
    return result
end

local module = {
    GetChild               = GetChild,
    GetChildren            = GetChildren,
    CollectChildren        = CollectChildren,
    GetDescendant          = GetDescendant,
    GetDescendants         = GetDescendants,
    CollectDescendants     = CollectDescendants,
    GetAncestor            = GetAncestor,
    GetAncestors           = GetAncestors,
    CollectAncestors       = CollectAncestors,
    GetSibling             = GetSibling,
    GetSiblings            = GetSiblings,
    CollectSiblings        = CollectSiblings,
    WaitForChild           = WaitForChild,
    WaitCollectChildren    = WaitCollectChildren,
    WaitForDescendant      = WaitForDescendant,
    WaitCollectDescendants = WaitCollectDescendants,
    WaitCollectSiblings    = WaitCollectSiblings,
}

return module