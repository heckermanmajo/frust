--- @class Utils
--- @field positive_number fun(value: number): nil
--- @field number fun(value: number): nil
--- @field positive_integer fun(value: number): nil
--- @field integer fun(value: number): nil
--- @field in_table fun(value: any, table: table): boolean
--- @field serialize_table fun(tbl: table, seen: table): string

Utils = {}

--- Check if a value is a positive number.
--- @param value number
--- @return nil
--- @raise error if value is not a positive number
function Utils.positive_number(value)
    assert(type(value) == "number", "value must be a number")
    if value < 0 then
        error("value must be positive")
    end
end

function Utils.number(value)
    assert(type(value) == "number", "value must be a number")
end

function Utils.positive_integer(value)
    assert(type(value) == "number", "value must be a number")
    if value < 0 then
        error("value must be positive")
    end
    if value ~= math.floor(value) then
        error("value must be an integer")
    end
end

function Utils.integer(value)
    assert(type(value) == "number", "value must be a number")
    if value ~= math.floor(value) then
        error("value must be an integer")
    end
end


function Utils.in_table(value, table)
    assert(type(table) == "table", "table must be a table")
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function Utils.serialize_table(tbl, seen)
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