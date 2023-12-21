--- @class Collider
--- @field x number
--- @field y number
--- @field width number
--- @field height number


--- Check if a table implements the Collider protocol.
--- It crashes if the table does not implement the protocol.
--- @param object table
--- @return nil
function checkCollider(object)
  if object.__className ~= nil then
    assert(inTable("Collider", object.__protocols), "object must implement and allow Collider protocol")
  end
  positiveNumber(object.x)
  positiveNumber(object.y)
  positiveNumber(object.width)
  positiveNumber(object.height)
end

--- Check if two colliders are overlapping (colliding).
--- @param me Collider an table that implements the Collider protocol
--- @param other Collider an table that implements the Collider protocol
--- @return boolean true if the two colliders are overlapping, false otherwise
function collision(me, other)
  ---!debug:start
  checkCollider(me)
  checkCollider(other)
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

  me = {x=0, y=0, width=10, height=10}
  other = {x=0, y=0, width=10, height=10}
  assert(collision(me, other), "collision should be true")

  me = {x=0, y=0, width=10, height=10}
  other = {x=10, y=0, width=10, height=10}
  assert(not collision(me, other), "collision should be false")

  me = {x=0, y=0, width=10, height=10}
  other = {x=0, y=10, width=10, height=10}
  assert(not collision(me, other), "collision should be false")

  me = {x=0, y=0, width=10, height=10}
  other = {x=10, y=10, width=10, height=10}
  assert(not collision(me, other), "collision should be false")

  me = {x=0, y=0, width=10, height=10}
  other = {x=5, y=5, width=10, height=10}
  assert(collision(me, other), "collision should be true")

  -- p call width negative width
  me = {x=0, y=0, width=-10, height=10}
  other = {x=0, y=0, width=10, height=10}
  assert(not pcall(collision, me, other), "collision should crash")

  -- p call width negative height
  me = {x=0, y=0, width=10, height=-10}
  other = {x=0, y=0, width=10, height=10}
  assert(not pcall(collision, me, other), "collision should crash")

  -- pcall with non table
  me = 1
  other = {x=0, y=0, width=10, height=10}
  assert(not pcall(collision, me, other), "collision should crash")

  -- pcall with bad table
  me = {x=0, y=0, width=10, height=10}
  other = {x=0, y=0, width=10, foo="bar"}
  assert(not pcall(collision, me, other), "collision should crash")

end
---!debug:end
