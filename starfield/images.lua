function f(image)
    return function()
        love.graphics.draw(love.graphics.newImage('starfield/'..image..'.png'))
    end
end
local t
t = {
    f('asteroid'),
    f('ship'),
    f('asteroid-screen'),
    f('vector'),
    f('ship collision'),
}
return t
