--- @class Utils
--- @field positive_number fun(value: number): nil
--- @field number fun(value: number): nil
--- @field positive_integer fun(value: number): nil
--- @field integer fun(value: number): nil
--- @field in_table fun(value: any, table: table): boolean
--- @field serialize_table fun(tbl: table, seen: table): string

-- todo: update all error messages...

Utils = {}

---------------------------------------------------------------------------------
--- Check if a value is a positive number.
---
--- @param value number
---
--- @return nil
---
--- @raise error if value is not a positive number
---------------------------------------------------------------------------------
function Utils.assert_positive_number(value, message)
  local _message = message or ""
  assert(type(value) == "number", "TYPECHECK: [value must be a number] " .. _message)
  if value < 0 then
    error("TYPECHECK: [value must be positive] " .. _message)
  end
end

---------------------------------------------------------------------------------
--- Check if a value is a number.
---
--- @param value number
---
--- @return nil
---
--- @raise error if value is not a number
---------------------------------------------------------------------------------
function Utils.assert_number(value)
  assert(type(value) == "number", "value must be a number")
end

function Utils.assert_positive_integer(value)
  assert(type(value) == "number", "value must be a number")
  if value < 0 then
    error("value must be positive")
  end
  if value ~= math.floor(value) then
    error("value must be an integer")
  end
end

function Utils.assert_integer(value)
  assert(type(value) == "number", "value must be a number")
  if value ~= math.floor(value) then
    error("value must be an integer")
  end
end

function Utils.assert_in_table(value, table)
  assert(type(table) == "table", "table must be a table")
  local found = false
  for _, v in ipairs(table) do
    -- list like tables
    if v == value then
      found = true
      break
    end
  end
  for _, v in pairs(table) do
    -- map like tables
    if v == value then
      found = true
      break
    end
  end
  if not found then
    error("value must be in table, but is " .. tostring(value))
  end
end

function Utils.assert_serialize_table(tbl, seen)
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