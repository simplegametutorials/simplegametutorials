function love.load()
    http = require('socket.http')
    json = require('json')
    love.window.setMode(400, 400, {resizable = true})
    tumblr = 'nature-ally'
    image_urls = {}
    images = {}
    current_image = 1
    get_image()
end


function get_image()
    if not image_urls[current_image] then
        love.window.setTitle('Loading URLs...')
        local url = string.format('http://%s.tumblr.com/api/read/json?type=photo&start=%s&num=%s', tumblr, current_image - 1, 10)
        local json_file = http.request(url)
        local json_table = json:decode(string.match(json_file, '%b{}'))
        for _, post in ipairs(json_table['posts']) do
            table.insert(image_urls, post['photo-url-500'])
        end
    end
    love.window.setTitle('Loading image...')
    local data = http.request(image_urls[current_image])
    images[current_image] = love.graphics.newImage(love.filesystem.newFileData(data, ''))
    love.window.setTitle('')
end


function love.keypressed(key)
    if key == 'right' then
        current_image = current_image + 1
        if not images[current_image] then
            get_image()
        end
    elseif key == 'left' then
        if current_image ~= 1 then
            current_image = current_image - 1
        end
    end
end


function love.draw()
    local image = images[current_image]
    local scale = math.min(
        love.graphics.getWidth()/image:getWidth(),
        love.graphics.getHeight()/image:getHeight(),
        1)
    local x = love.graphics.getWidth()/2 - image:getWidth()*scale/2
    local y = love.graphics.getHeight()/2 - image:getHeight()*scale/2
    love.graphics.draw(image, x, y, 0, scale)
end
