--- @class ColliderProtocol
--- @field x number
--- @field y number
--- @field width number
--- @field height number

ColliderProtocol = {}

--- Check if a table implements the Collider protocol.
--- It crashes if the table does not implement the protocol.
--- @param object table
--- @return nil
function ColliderProtocol.check(object)
  if object.__className ~= nil then
    assert(inTable("Collider", object.__protocols), "object must implement and allow Collider protocol")
  end
  Utils.assert_positive_number(object.x)
  Utils.assert_positive_number(object.y)
  Utils.assert_positive_number(object.width)
  Utils.assert_positive_number(object.height)
end

--- Check if two colliders are overlapping (colliding).
--- @param me Collider an table that implements the Collider protocol
--- @param other Collider an table that implements the Collider protocol
--- @return boolean true if the two colliders are overlapping, false otherwise
function ColliderProtocol.collision(me, other)
  ---!debug:start
  ColliderProtocol.check(me)
  ColliderProtocol.check(other)
  ---!debug:end
  return (
    me.x < other.x + other.width
      and other.x < me.x + me.width
      and me.y < other.y + other.height
      and other.y < me.y + me.height
  )
end

---!debug:start
do

  local me
  local other

  me = { x = 0, y = 0, width = 10, height = 10 }
  other = { x = 0, y = 0, width = 10, height = 10 }
  assert(ColliderProtocol.collision(me, other), "collision should be true")

  me = { x = 0, y = 0, width = 10, height = 10 }
  other = { x = 10, y = 0, width = 10, height = 10 }
  assert(not ColliderProtocol.collision(me, other), "collision should be false")

  me = { x = 0, y = 0, width = 10, height = 10 }
  other = { x = 0, y = 10, width = 10, height = 10 }
  assert(not ColliderProtocol.collision(me, other), "collision should be false")

  me = { x = 0, y = 0, width = 10, height = 10 }
  other = { x = 10, y = 10, width = 10, height = 10 }
  assert(not ColliderProtocol.collision(me, other), "collision should be false")

  me = { x = 0, y = 0, width = 10, height = 10 }
  other = { x = 5, y = 5, width = 10, height = 10 }
  assert(ColliderProtocol.collision(me, other), "collision should be true")

  -- p call width negative width
  me = { x = 0, y = 0, width = -10, height = 10 }
  other = { x = 0, y = 0, width = 10, height = 10 }
  assert(not pcall(ColliderProtocol.collision, me, other), "collision should crash")

  -- p call width negative height
  me = { x = 0, y = 0, width = 10, height = -10 }
  other = { x = 0, y = 0, width = 10, height = 10 }
  assert(not pcall(ColliderProtocol.collision, me, other), "collision should crash")

  -- pcall with non table
  me = 1
  other = { x = 0, y = 0, width = 10, height = 10 }
  assert(not pcall(ColliderProtocol.collision, me, other), "collision should crash")

  -- pcall with bad table
  me = { x = 0, y = 0, width = 10, height = 10 }
  other = { x = 0, y = 0, width = 10, foo = "bar" }
  assert(not pcall(ColliderProtocol.collision, me, other), "collision should crash")

end
---!debug:end