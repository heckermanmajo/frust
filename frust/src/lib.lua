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

-- TODO: test this function
-- tostring of table
function serializeTable(tbl, seen)
    seen = seen or {}  -- Table to keep track of visited tables
    if type(tbl) == "table" then
        if seen[tbl] then
            return "recursion"
        end
        seen[tbl] = true
        local result = "{"
        local first = true
        for k, v in pairs(tbl) do
            if not first then
                result = result .. ", "
            end
            result = result .. "[" .. serialize(k, seen) .. "]=" .. serialize(v, seen)
            first = false
        end
        result = result .. "}"
        return result
    elseif type(tbl) == "string" then
        return string.format("%q", tbl)
    else
        return tostring(tbl)
    end
end
