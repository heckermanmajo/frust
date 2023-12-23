-- Coroutines Test
-- wrap ist kacke -> use create

local myCoroutine = coroutine.create(function()
  print("Hello")
  coroutine.yield()
  print("World")
end)

print(coroutine.status(myCoroutine))
coroutine.resume(myCoroutine)
print(coroutine.status(myCoroutine))
coroutine.resume(myCoroutine)
print(coroutine.status(myCoroutine))
coroutine.resume(myCoroutine)


local myCoroutine2 = coroutine.create(function()
  print("Hello")
  coroutine.yield()
  print("World")
end)

-- do a coroutine until it is dead
repeat coroutine.resume(myCoroutine2)
until coroutine.status(myCoroutine2) == "dead"






