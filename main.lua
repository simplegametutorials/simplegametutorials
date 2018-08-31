MAX_WIDTH = 1000
MAX_HEIGHT = 4000
BACKGROUND = {1, .9, .9}

if arg[#arg] == '-debug' then require('mobdebug').start() end
io.stdout:setvbuf('no')

love.filesystem.setIdentity('tutorials')
mode = arg[2]
name = arg[3]
title = arg[4]

realBackground = {0, 0, 0, 0}

ONCE = {}
ONCE.start = true

if mode == 'open' then
    love.system.openURL(love.filesystem.getSaveDirectory()..'/'..name..'/index.html')
    love.event.quit()
elseif mode == 'images' then
    function cropImageData(screenshot, background)
        local left = 0
        for x = left, screenshot:getWidth() - 1 do
            local isBackground = true
            for y = 0, screenshot:getHeight() - 1 do
                local r, g, b, a = screenshot:getPixel(x, y)
                if not (r == background[1] and b == background[2] and g == background[3] and a == background[4]) then
                    isBackground = false
                    break
                end
            end
            if isBackground then
                left = x + 1
            else
                break
            end
        end

        local right = screenshot:getWidth() - 1
        for x = right, 0, -1 do
            local isBackground = true
            for y = 0, screenshot:getHeight() - 1 do
                local r, g, b, a = screenshot:getPixel(x, y)
                if not (r == background[1] and g == background[2] and b == background[3] and a == background[4]) then
                    isBackground = false
                    break
                end
            end
            if isBackground then
                right = x
            else
                break
            end
        end

        local top = 0
        for y = top, screenshot:getHeight() - 1 do
            local isBackground = true
            for x = 0, screenshot:getWidth() - 1 do
                local r, g, b, a = screenshot:getPixel(x, y)
                if not (r == background[1] and g == background[2] and b == background[3] and a == background[4]) then
                    isBackground = false
                    break
                end
            end
            if isBackground then
                top = y + 1
            else
                break
            end
        end

        local bottom = screenshot:getHeight() - 1
        for y = bottom, 0, -1 do
            local isBackground = true
            for x = 0, screenshot:getWidth() - 1 do
                local r, g, b, a = screenshot:getPixel(x, y)
                if not (r == background[1] and g == background[2] and b == background[3] and a == background[4]) then
                    isBackground = false
                    break
                end
            end
            if isBackground then
                bottom = y
            else
                break
            end
        end

        local imagedata = love.image.newImageData(
            right - left,
            bottom - top
        )

        imagedata:paste(
            screenshot,
            0, 0,
            left, top,
            right - left,
            bottom - top
        )

        return imagedata
    end

    function love.load()
        index = 1
        imageCount = 0
        canvas = love.graphics.newCanvas(MAX_WIDTH, MAX_HEIGHT)
        love.graphics.setBackgroundColor(0, 0, 0, 0)
        love.window.setTitle(index)
    end

    function love.keypressed(key)
        ONCE[key] = true
        local function encode(i)
            love.window.setTitle('Saving image '..i)
            love.filesystem.createDirectory(name)
            local imagedata = cropImageData(canvas:newImageData(), realBackground)
            imagedata:encode('png', name..'/'..i..'.png')
        end
        if imageCount > 0 then
            if key == 'down' then
                index = index + 1
                if index > imageCount then
                    index = 1
                end
            elseif key == 'up' then
                index = index - 1
                if index < 1 then
                    index = imageCount
                end
            elseif key == 'space' then
                encode(index)

            elseif key == 'a' then
                for i = 1, imageCount do
                    index = i
                    love.draw()
                    encode(index)
                end
            elseif key == 'b' then
                if realBackground[1] == 1 then
                    realBackground = {0, 0, 0, 0}
                else
                    realBackground = {1, 1, 1, 0}
                end
            end
        end

        love.window.setTitle(index)
    end

    function love.draw()
        love.graphics.setBackgroundColor(0, 0, 0, 0)

        love.graphics.clear(BACKGROUND)
        local function printError(s)    
            local err = {}

            table.insert(err, "Error\n")
            table.insert(err, s.."\n\n")

            local trace = debug.traceback()
            for l in string.gmatch(trace, "(.-)\n") do
                if not string.match(l, "boot.lua") then
                    l = string.gsub(l, "stack traceback:", "Traceback\n")
                    table.insert(err, l)
                end
            end

            local p = table.concat(err, "\n")

            p = string.gsub(p, "\t", "")
            p = string.gsub(p, "%[string \"(.-)\"%]", "%1")

            love.graphics.push('all')
            love.graphics.reset()
            love.graphics.origin()
            love.graphics.clear(0, 0, 0)
            love.graphics.print(p)
            love.graphics.pop()
        end

        local imagesPath = name..'/images.lua'
        if not love.filesystem.getInfo(imagesPath) then
            printError("Couldn't find images.lua at "..imagesPath)
            return 
        end
        success, chunk = pcall(love.filesystem.load, imagesPath)
        if not success then
            printError(chunk)
            return
        end
        success, imageTable = pcall(chunk)
        if success then
            if imageTable then
                imageCount = #imageTable
            else
                printError('images.lua is not returning a table.')
                imageCount = 0
                return
            end
        else
            printError(imageTable)
            return
        end

        if index > imageCount then
            index = imageCount
        end

        love.graphics.push('all')
        love.graphics.setCanvas(canvas)
        love.graphics.clear(realBackground)
        if imageTable then
            success, chunk = pcall(imageTable[index])
        end
        love.graphics.setCanvas()
        love.graphics.pop()

        love.graphics.draw(canvas)

        if not success then
            printError(chunk)
            return
        end
    end
elseif mode == 'html' then
    s = [[<html><head><title>]]
    ..(title or (name:gsub("^%l", string.upper)..' Tutorial'))..
[[</title>
<link href="https://fonts.googleapis.com/css?family=Quicksand:500,700" rel="stylesheet">
<style>
body {
    font-family: Calibri, sans-serif;
    margin: 20px;
    background: #efefef;
}
p, li, td, h1, h2, h3, h4 {
    font-family: 'Quicksand';
    color: #333;
}
p, li, td, pre {
    font-weight: 500;
    font-size: 11pt;
}
a {
    color: #059dc5;
    text-decoration: none;
}
a:hover {
    text-decoration: underline;
}
p {
    max-width: 600px;
    line-height: 1.4;
}
td {
    padding-right:10px
}
pre {
    margin-top: 0;
    min-width: 600px;
}
.pre {
    display: table;
    margin: 20px 0;
}
img {
    display: block;
    margin: 14px 0;
}
.code {
    font-family: Consolas, Monaco, Inconsolata, monospace;
    border-radius: 8px;
    background: #fff;
    color: #555;
    padding: 12px;
}
.inlinecode {
    font-family: Consolas, Monaco, Inconsolata, monospace;
    color: #555;
}
.console {
    font-family: Consolas, Monaco, Inconsolata, monospace;
    padding: 16px;
    background: #555;
    border-radius: 8px;
    color: #eee;
}
.name {color:#e824b7;}
.call {color:#ab22d0;}
.literal {color:#01afa5; color:#ea9b4c;}
.comment {color:#555; background:#eee; border-radius: 4px;}
.highlight {background:#fcffc4; border-radius: 4px;}
.highlight .comment, .comment .highlight {background:#f0edd3;}
</style>
</head>
<body>
<h3><a href="../">Introduction and other tutorials</a></h3>
]]

    keywords = {}
    for keywordIndex, keyword in pairs{
        "and", "break", "do", "else", "elseif", "end", "for", "function", "if", "local", "nil", "not", "or", "repeat", "return", "then", "until", "while", "true", "false", "in"
    } do
        keywords[keyword] = true
    end

    function a(t, z)
        if type(z) ~= 'string' then
            s = s .. t .. '\n'
        else
            s = s .. '<'..t..'>'.. z .. '</'..t..'>\n'
        end
    end

    function highlight(s)
        local function noSpans(s, a)
            return s
            :gsub('<span class=@name@>', '')
            :gsub('<span class=@literal@>', '')
            :gsub('<span class=@call@>', '')
            :gsub('<span class=@comment@>', '')
            :gsub('</span>', '')
        end
        local name = '[%a_][%a%d_%.%:]*'
        local function f(s)
            return s
            :gsub(name, function(s) if not keywords[s:match('%a+')] then return '<span class=@name@>'..s..'</span>' end end)
            :gsub('<span class=@name@>('..name..')%.%.</span>', function(s) return '<span class=@name@>'..s..'</span>..' end)
            :gsub('('..name..')%(', function(s) if not keywords[s:match('%a+')] then return '<span class=@call@>'..s..'</span>(' end end)
            :gsub('function <span class=@name@>', 'function <span class=@literal@>')
            :gsub('<span class=@name@>'..name..'</span>%(', function(s) return '<span class=@call@>'..s:gsub('<span class=@name@>', '') end)

            :gsub([[%'<span class=@name@>]]..name..[[*</span>%']], function(s) return '\''..s:gsub('\' <span class=@name@>', ' '):gsub('\'<span class=@name@>', ''):gsub('</span> \'', ' '):gsub('</span>\'', '')..'\'' end)
            :gsub([[%'[ ]?<span class=@name@>]]..name..[[+</span>[ ]?%']], function(s) return '\''..s:gsub('\' <span class=@name@>', ' '):gsub('\'<span class=@name@>', ''):gsub('</span> \'', ' '):gsub('</span>\'', '')..'\'' end)

            :gsub([[%"<span class=@name@>]]..name..[[*</span>%"]], function(s) return "\""..s:gsub("\" <span class=@name@>", " "):gsub("\"<span class=@name@>", ""):gsub("</span> \"", " "):gsub("</span>\"", "").."\"" end)
            :gsub([[%"[ ]?<span class=@name@>]]..name..[[+</span>[ ]?%"]], function(s) return "\""..s:gsub("\" <span class=@name@>", " "):gsub("\"<span class=@name@>", ""):gsub("</span> \"", " "):gsub("</span>\"", "").."\"" end)

            :gsub('([%)%(%-%+%=%*%/%%%^%,%|%{%}%[%] ])([%d%.]+)([%)%(%-%+%=%*%/%%%^%,%|%{%}%[%] \n])', function(a, b, c) return a..'<span class=@literal@>'..b..'</span>'..c end)
            :gsub('true', function(s) return '<span class=@literal@>'..s..'</span>' end)
            :gsub('false', function(s) return '<span class=@literal@>'..s..'</span>' end)
            :gsub('nil', function(s) return '<span class=@literal@>'..s..'</span>' end)

            :gsub('function <span class=@literal@>', 'function <span class=@name@>')
            :gsub('(<span class=@comment@>)(%s*)', function(a, b) return b..a end)

        end
        s = f(s)

        local function magiclines(s)
            if s:sub(-1)~="\n" then s=s.."\n" end
            return s:gmatch("(.-)\n")
        end
        local inComment = false
        local output = ''
        for line in magiclines(s) do
            line = line:gsub([[%b'']], function(s) return '<span class=@literal@>'..noSpans(s)..'</span>' end)
                       :gsub([[%b""]], function(s) return '<span class=@literal@>'..noSpans(s)..'</span>' end)
            if not inComment then
                local a, z = line:match('(.*)(%-%-%[%[.*)')
                if z then
                    line = a .. '<span class="comment">'..noSpans(z)
                    inComment = true
                else
                    local a, z = line:match('(.*)(%-%-.*)')
                    if z then
                        line = a..'<span class=@comment@>'..noSpans(z)..'</span>'
                    end
                end
            else
                local a, z = line:match('(.*%]%])(.*)')
                if a then
                    line = noSpans(a)..'</span>'..z
                    inComment = false
                else
                    line = noSpans(line)
                end
            end
            output = output..'\n'..line
            :gsub('<span class=@', '<span class="')
            :gsub('@>', '">')
            :gsub([[%b||]], function(s) return '<span class="highlight">'..s..'</span>' end):gsub('|', '')
        end
        output = output:gsub([[%b||]], function(s) return '<span class="highlight">'..s..'</span>' end):gsub('|', '')
        output = output:gsub('^\n', '')

        return output
    end

    codeString = ''
    consoleString = ''
    list = false
    inCode = false
    inConsole = false
    inTable = false
    imageNumber = 1

    for line in love.filesystem.lines(name..'/input.txt') do
        line = line:gsub('\t', '    ')
        h1 = line:match('^#%s(.+)')
        h2 = line:match('^##%s(.+)')
        h3 = line:match('^###%s(.+)')
        h4 = line:match('^####%s(.+)')
        li = line:match('^- (.+)')
        link = line:match('^%%(.+)')
        code = line:match('^%`$')
        console = line:match('^%~$')
        image = line:match('^%!$')
        td1, td2 = line:match('^%&%s+(.-)%s+%&%s+(.+)')

        if code then
            if inCode then
                inCode = false
                a(highlight(codeString:sub(1, -2)))
                codeString = ''
                a('</pre></div>')
            else
                inCode = true
                s = s..'<div class="pre"><pre class="code">'
            end
        elseif console then
            if inConsole then
                inConsole = false
                a(consoleString:sub(1, -2))
                consoleString = ''
                a('</pre></div>')
            else
                inConsole = true
                a('<div class="pre"><pre class="console">')
            end
        elseif inCode then
            codeString = codeString..line..'\n'
        elseif inConsole then
            consoleString = consoleString..line..'\n'
        elseif not li and list then
            a('</ul>')
            list = false
        elseif li and not list then
            list = true
            a('<ul>')
            li = li:gsub('%*[^%*]+%*', function(s) return '<b>'..s:sub(2, -2)..'</b>' end)
            a('li', li)
        elseif h1 then
            a('h1', h1)
        elseif h2 then
            a('h2', h2)
        elseif h3 then
            a('h3', h3)
        elseif h4 then
            a('h4', h4)
        elseif li then
            li = li:gsub('%*[^%*]+%*', function(s) return '<b>'..s:sub(2, -2)..'</b>' end)
            a('li', li)
        elseif image then
            a('<img src="'..imageNumber..'.png">')
            imageNumber = imageNumber + 1
        elseif link then
            a('<a href="'..link..'"><h2>'..link..'</h2></a>')
        elseif td1 then
            td1 = td1:gsub('%*[^%*]+%*', function(s) return '<b>'..s:sub(2, -2)..'</b>' end)
            td2 = td2:gsub('%*[^%*]+%*', function(s) return '<b>'..s:sub(2, -2)..'</b>' end)

            td1 = td1:gsub('%b``', function(s) return '<span class="inlinecode">'..highlight(s)..'</span>' end):gsub('`', '')
            td2 = td2:gsub('%b``', function(s) return '<span class="inlinecode">'..highlight(s)..'</span>' end):gsub('`', '')

            local image = td1:match('^%!$')
            if image then
                if not inTable then
                    inTable = true
                    a('<table>')
                end
                a('<tr><td><img src="'..imageNumber..'.png"><td>'..td2..'</td></tr>')
                imageNumber = imageNumber + 1
            else
                if not inTable then
                    inTable = true
                    a('<table>')
                end
                a('<tr><td>'..td1..'</td><td>'..td2..'</td></tr>')
            end
        elseif inTable then
            a('</table>')
            inTable = false
        elseif line ~= '' then
            line = line:gsub('%b``', function(s) return '<span class="inlinecode">'..highlight(s)..'</span>' end):gsub('`', '')
            line = line:gsub('%*[^%*]+%*', function(s) return '<b>'..s:sub(2, -2)..'</b>' end)
            a('p', line)
        end
    end

    a('</body></html>')

    function love.run()
        love.filesystem.createDirectory(name)
        s = s:gsub('LOVE', 'L&Ouml;VE'):gsub('²', '&sup2;')
        love.filesystem.write(name..'/index.html', s)
    end
end
