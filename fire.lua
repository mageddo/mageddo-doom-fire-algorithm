local fireColorsPalette = {
  {r=7,g=7,b=7},
  {r=31,g=7,b=7},
  {r=47,g=15,b=7},
  {r=71,g=15,b=7},
  {r=87,g=23,b=7},
  {r=103,g=31,b=7},
  {r=119,g=31,b=7},
  {r=143,g=39,b=7},
  {r=159,g=47,b=7},
  {r=175,g=63,b=7},
  {r=191,g=71,b=7},
  {r=199,g=71,b=7},
  {r=223,g=79,b=7},
  {r=223,g=87,b=7},
  {r=223,g=87,b=7},
  {r=215,g=95,b=7},
  {r=215,g=95,b=7},
  {r=215,g=103,b=15},
  {r=207,g=111,b=15},
  {r=207,g=119,b=15},
  {r=207,g=127,b=15},
  {r=207,g=135,b=23},
  {r=199,g=135,b=23},
  {r=199,g=143,b=23},
  {r=199,g=151,b=31},
  {r=191,g=159,b=31},
  {r=191,g=159,b=31},
  {r=191,g=167,b=39},
  {r=191,g=167,b=39},
  {r=191,g=175,b=47},
  {r=183,g=175,b=47},
  {r=183,g=183,b=47},
  {r=183,g=183,b=55},
  {r=207,g=207,b=111},
  {r=223,g=223,b=159},
  {r=239,g=239,b=199},
  {r=255,g=255,b=255}
}

function start(fireWidth, fireHeight, fireWay)

  _G.fireWidth = fireWidth or 3
  _G.fireHeight = fireHeight or 3
  _G.fireWay = fireWay or 1
  firePixelsArray = {}
  pixelsQuantity = fireWidth * fireHeight
  lastPixelIndex = (pixelsQuantity - 1)

  createFireDataStructure()
  createFireSource()

  --for i=0, 4 do
  --  calculateFirePropagation()
  --  renderFire()
  --  print("=============================================")
  --  print()
  --end

end

function renderFire()
  for i=0, lastPixelIndex do
    io.write(string.format("[%2d = %2d] ", i, firePixelsArray[i]))
    if((i + 1) % fireWidth == 0) then
      print("")
    end
  end
end

function createFireDataStructure()

  for i = 0, lastPixelIndex do
    firePixelsArray[i] = 0
  end

end

function createFireSource()
  for column = 0, fireWidth - 1 do
    local overflowPixelIndex = fireWidth * fireHeight
    local pixelIndex = (overflowPixelIndex - fireWidth) + column
    firePixelsArray[pixelIndex] = #fireColorsPalette - 1
  end
end

function calculateFirePropagation()
  for column = 0, (fireWidth - 1) do
    for row = 0, (fireHeight - 1) do
      local pixelIndex = column + ( fireWidth * row )
      updateFireIntensityPerPixel(pixelIndex)
    end
  end
end

function updateFireIntensityPerPixel(currentPixelIndex)

  local belowPixelIndex = currentPixelIndex + fireWidth

  -- below pixel index overflows canvas
  if (belowPixelIndex >= pixelsQuantity) then
    return
  end

  local decay = math.floor(math.random() * 3)
  local belowPixelFireIntensity = firePixelsArray[belowPixelIndex]
  local newFireIntensity = math.max(belowPixelFireIntensity - decay, 0)

  local wayOptions = {
    [0] = {
      description = "Wind comes from left",
      fn = function ()
        firePixelsArray[currentPixelIndex - decay] = newFireIntensity
      end
    },
    [1] = {
      description = "No wind",
      fn = function()
        firePixelsArray[currentPixelIndex] = newFireIntensity
      end
    },
    [2] = {
      description = "Wind comes to the right",
      fn = function()
        firePixelsArray[currentPixelIndex + decay] = newFireIntensity
      end
    }
  }

  wayOptions[fireWay].fn()

end

function getFirePixelsArray()
  return firePixelsArray
end

function update()
  calculateFirePropagation()
  return firePixelsArray
end

start(60, 40, 0)
