local GameOver = {}

local scoreFinal = 0
local larguraBotao = 200
local alturaBotao = 50
local xBotao, yBotao

function GameOver.load(pontoFinal)
    scoreFinal = pontoFinal
    xBotao = (love.graphics.getWidth() - larguraBotao) / 2
    yBotao = love.graphics.getHeight() / 2 + 50

end
function GameOver.draw()
    love.graphics.setColor(0, 0, 0, 0.8)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("GAME OVER", 0, love.graphics.getHeight() / 2 - 100, love.graphics.getWidth(), "center")
    love.graphics.printf("Pontuação: " .. scoreFinal, 0, love.graphics.getHeight() / 2 - 50, love.graphics.getWidth(), "center")
    love.graphics.rectangle("line", xBotao, yBotao, larguraBotao, alturaBotao)
    love.graphics.printf("REINICIAR", xBotao, yBotao + 15, larguraBotao, "center")
end

function GameOver.mousepressed(mx, my, button)
    if button == 1 then
        if mx >= xBotao and mx <= xBotao + larguraBotao and
           my >= yBotao and my <= yBotao + alturaBotao then
            return "reiniciar"
        end
    end
end

return GameOver