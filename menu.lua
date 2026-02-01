local menu = {}

local boasVindasMsg = "TETRIS"


local botaoJogar = {
    x = 0, y = 0,
    w = 260, h = 70
}

local corBotao     = {0.2, 0.6, 1}
local corHover     = {0.3, 0.8, 1}
local corAtual     = corBotao

function menu.load()
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()

    botaoJogar.x = (sw - botaoJogar.w) / 2
    botaoJogar.y = sh / 2 + 40
end

function menu.update(dt)
    local mx, my = love.mouse.getPosition()

    if dentro(mx, my, botaoJogar) then
        corAtual = corHover
    else
        corAtual = corBotao
    end
end

function menu.draw()
    local sw = love.graphics.getWidth()

    -- Fundo
    love.graphics.setColor(0.1, 0.1, 0.12)
    love.graphics.rectangle("fill", 0, 0, sw, love.graphics.getHeight())

    -- Título
    love.graphics.setColor(1, 1, 1)
    love.graphics.setNewFont(28)
    love.graphics.printf(boasVindasMsg, 0, 160, sw, "center")

    -- Botão
    love.graphics.setColor(corAtual)
    love.graphics.rectangle("fill", botaoJogar.x, botaoJogar.y, botaoJogar.w, botaoJogar.h, 12, 12)

    love.graphics.setColor(0, 0, 0)
    love.graphics.printf(
        "JOGAR",
        botaoJogar.x,
        botaoJogar.y + 22,
        botaoJogar.w,
        "center"
    )

    love.graphics.setColor(1, 1, 1)
end

function menu.mousepressed(mx, my, button)
    if button ~= 1 then return end

    if dentro(mx, my, botaoJogar) then
        estado = "jogando"
        require("Jogo").load()
    end
end

function dentro(mx, my, b)
    return mx >= b.x and mx <= b.x + b.w
       and my >= b.y and my <= b.y + b.h
end

return menu