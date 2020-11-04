import staticglfw
import opengl
import platform
import player as plyr
import util
import controller as ctrl
import json
import times

var player: Player = Player(x: 300, y: 300, w: 32, h: 32)
var controller: Controller = Controller(up: false, down: false, left: false, right: false)
var platforms: seq[Platform]

var data = parseFile("level.json")
for p in data["platforms"]:
    var plat: Platform = Platform(
        x: Glfloat(p["x"].getFloat()),
        y: Glfloat(p["y"].getFloat()),
        w: Glfloat(p["w"].getFloat()),
        h: Glfloat(p["h"].getFloat()),
        color: Color(
            r: p["fill"][0].getFloat(),
            g: p["fill"][1].getFloat(),
            b: p["fill"][2].getFloat()
        )
    )
    platforms.add(plat)


proc rectcollide(player: Player, rect: Platform): bool =
      (player.x + player.w) < rect.x or
      player.x > (rect.x + rect.w) or 
      (player.y + player.h) < rect.y or
      player.y > (rect.y + rect.h)

proc smallestIndex(arr: openArray[int]): int =
  if arr.len < 1:
    return -1

  for i in countdown(arr.len - 1, 0):
    if arr[i] < arr[result]:
      result = i

proc align(player: Player, rect: Platform) =
  var pos = [
    int(abs(player.y + player.h - rect.y)),
    int(abs(rect.x + rect.w - player.x)),
    int(abs(rect.y + rect.h - player.y)),
    int(abs(player.x + player.w - rect.x))
  ]

  case smallestIndex(pos)
    of 0:
      player.y = rect.y - player.h
      player.vY = 0
    of 1:
      player.x = rect.x + rect.w
      player.vX = 0
    of 2:
      player.y = rect.y + rect.h
      player.vY = 0
    of 3:
      player.x = rect.x - player.w;
      player.vX = 0
    else:
      return

proc physics() =
  if controller.right:
    player.vX = player.vX + 1
  
  if controller.left:
    player.vX = player.vX - 1

  if controller.up:
    player.vY = player.vY - 1
  
  if controller.down:
    player.vY = player.vY + 1

  player.vX *= 0.8
  player.vY *= 0.8

  player.x += Glfloat(player.vX)
  player.y += Glfloat(player.vY)

proc blockLogic() =
  for i in countdown(platforms.len - 1, 0):
    if (rectcollide(player, platforms[i]) == false):
      align(player, platforms[i])

# Init GLFW
if init() == 0:
  raise newException(Exception, "Failed to Initialize GLFW")

# Open window
var window = createWindow(640, 480, "GLFW3 WINDOW", nil, nil)
# Connect the GL context
window.makeContextCurrent()
# This must be called to make any GL function work
loadExtensions()

proc resize (window: Window, width: cint, height: cint) {.cdecl.} =
    echo "RESIZE"

var
  startTime = epochTime()
  lastTick = 0

# Run while window is open
while windowShouldClose(window) == 0:

  controller.update(
    window.getKey(KEY_W) == 1,
    window.getKey(KEY_S) == 1,
    window.getKey(KEY_A) == 1,
    window.getKey(KEY_D) == 1
  )

  let newTick = int((epochTime() - startTime) * 50)
  for tick in lastTick+1 .. newTick:
    physics()
    blockLogic()
  lastTick = newTick

  # Clear render
  glClearColor(0, 0, 0, 0)
  glClear(GL_COLOR_BUFFER_BIT)

  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()
  # Set ortho camera to viewport
  glOrtho(0, 640, 480, 0, -1, 1)
  
  # Draw platforms
  for p in platforms:
      p.draw()

  # Draw player
  player.draw()



  # Swap buffers (this will display the red color)
  window.swapBuffers()

  # Check for events
  pollEvents()
  # Quit
  if window.getKey(KEY_ESCAPE) == 1:
    window.setWindowShouldClose(1)

  discard setWindowSizeCallback(window, resize)

# Destroy the window
window.destroyWindow()
# Exit GLFW
terminate()