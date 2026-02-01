local menu = require "menu"
local Jogo = require "Jogo"
local GameOver = require "GameOver"

estado = "menu"

function love.load()
    menu.load()
end

function love.update(dt)
    if estado == "menu" then
        -- nada
    elseif estado == "jogando" then
        Jogo.update(dt)
    elseif estado == "gameover" then
        -- nada
    end
end

function love.draw()
    if estado == "menu" then
        menu.draw()
    elseif estado == "jogando" then
        Jogo.draw()
    elseif estado == "gameover" then
        GameOver.draw()
    end
end

function love.mousepressed(x, y, button)
    if estado == "menu" then
        menu.mousepressed(x, y, button)

    elseif estado == "jogando" then
        Jogo.mousepressed(x, y, button)

    elseif estado == "gameover" then
        local acao = GameOver.mousepressed(x, y, button)
        if acao == "reiniciar" then
            Jogo.load()
            estado = "jogando"
        end
    end
end