function positiveNumber(value)
    assert(type(value) == "number", "value must be a number")
    if value < 0 then
        error("value must be positive")
    end
end

function positiveInteger(value)
    assert(type(value) == "number", "value must be a number")
    if value < 0 then
        error("value must be positive")
    end
    if value ~= math.floor(value) then
        error("value must be an integer")
    end
end


function inTable(value, table)
    assert(type(table) == "table", "table must be a table")
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

-- TODO: THIS IS NOT WORKING
-- tostring of table
function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 10

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end
