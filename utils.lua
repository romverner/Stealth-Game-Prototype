local function merge_obj_to_obj(receivingObj, toMergeObj)
    -- function that copies obj functions and properties to given obj
    --[[
        receivingObj: the table receiving properties and functions
        toMergeObj: table who's properties and functions to copy
    ]]
    for k, v in pairs(toMergeObj.__index) do
        if k ~= '__gc' and k ~= '__eq' and k ~= '__index' and k ~= 'typeOf'
            and k ~= 'destroy' and k ~= 'type' and k ~= 'getUserData'
            and k ~= 'setUserData' and k ~= '__tostring' then
            receivingObj[k] = v
        end
    end
end

return {merge_obj_to_obj}