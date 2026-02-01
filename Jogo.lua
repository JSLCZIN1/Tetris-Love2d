local jogo = {}

function jogo.load()
    tile = 32

    tela = {
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
        {0,0,0,0,0,0,0,0},
    }

    linhas  = #tela
    colunas = #tela[1]

    pecas = {
        I = {{1,1,1,1}},
        O = {{1,1},{1,1}},
        T = {{0,1,0},{1,1,1}},
        S = {{0,1,1},{1,1,0}},
        Z = {{1,1,0},{0,1,1}},
        J = {{1,0,0},{1,1,1}},
        L = {{0,0,1},{1,1,1}}
    }

    botaoEsq  = { x = 0,   y = 80,  w = 200, h = 500 }
    botaoDir  = { x = 350, y = 80,  w = 200, h = 500 }
    botaoGira = { x = 200, y = 80,  w = 150, h = 500 }
    botaoB    = { x = 0,   y = 580, w = 580, h = 200 }

    screenWidth  = love.graphics.getWidth()
    screenHeight = love.graphics.getHeight()

    offsetX = (screenWidth  - colunas * tile) / 2
    offsetY = (screenHeight - linhas  * tile) / 2

    timer = 0
    velocidade = 0.5
    ponto = 0
    gameover = false

    randomPeca()
end
function jogo.update(dt)
    timer = timer + dt
    if timer >= velocidade then
        timer = 0
        if podeMover(0, 1, pecaAtual) then
            pecaPos.y = pecaPos.y + 1
        else
            fixaPeca()
            limparLinhas()
            randomPeca()
        end
    end

    if gameover then
        require("GameOver").load(ponto)
        estado = "gameover"
    end
end
function jogo.draw()
    love.graphics.print(ponto, 10, 10)

    for y = 1, linhas do
        for x = 1, colunas do
            local dx = offsetX + (x-1)*tile
            local dy = offsetY + (y-1)*tile
            if tela[y][x] == 1 then
                love.graphics.rectangle("fill", dx, dy, tile, tile)
            else
                love.graphics.rectangle("line", dx, dy, tile, tile)
            end
        end
    end

    for y = 1, #pecaAtual do
        for x = 1, #pecaAtual[y] do
            if pecaAtual[y][x] == 1 then
                love.graphics.rectangle(
                    "fill",
                    offsetX + (pecaPos.x + x - 2)*tile,
                    offsetY + (pecaPos.y + y - 2)*tile,
                    tile, tile
                )
            end
        end
    end
end
function limparLinhas()
    local y = linhas
    while y >= 1 do
        local cheia = true
        for x = 1, colunas do
            if tela[y][x] == 0 then
                cheia = false
                break
            end
        end

        if cheia then
            table.remove(tela, y)
            local novaLinha = {}
            for x = 1, colunas do
                novaLinha[x] = 0
                ponto = ponto + 100
            end
            table.insert(tela, 1, novaLinha)
        else
            y = y - 1
        end
    end
end
function randomPeca()
    local r = math.random(1,7)
    if r == 1 then
        pecaAtual = pecas.I
    elseif r == 2 then
        pecaAtual = pecas.O
    elseif r == 3 then
        pecaAtual = pecas.S
    elseif r == 4 then
        pecaAtual = pecas.J
    elseif r == 5 then
        pecaAtual = pecas.Z
    elseif r == 6 then
        pecaAtual = pecas.L
    elseif r == 7 then
        pecaAtual = pecas.T
    end
    pecaPos = { x = 4, y = 1 }
    if not podeMover(0,0,pecaAtual) then
        gameover = true
    end
end
function giraMatrix(m)
    novo = {}
    linha = #m
    coluna = #m[1]
    
    for x = 1, coluna do
        novo[x] = {}
        for y = linha,1,-1 do
            table.insert(novo[x],m[y][x])
        end
    end
    return novo
end
function podeMover(dx, dy, peca)
    for y = 1, #peca do
        for x = 1, #peca[y] do
            if peca[y][x] == 1 then

                local novoX = pecaPos.x + x - 1 + dx
                local novoY = pecaPos.y + y - 1 + dy
                if novoX < 1 or novoX > colunas then
                    return false
                end
                if novoY > linhas then
                    return false
                end
                if novoY >= 1 and tela[novoY][novoX] == 1 then
                    return false
                end
            end
        end
    end
    return true
end

function fixaPeca()
    for y = 1, #pecaAtual do
        for x = 1, #pecaAtual[y] do
            if pecaAtual[y][x] == 1 then
                local ty = pecaPos.y + y - 1
                local tx = pecaPos.x + x - 1
                tela[ty][tx] = 1
            end
        end
    end
end
function jogo.mousepressed(mx, my, button)
    if button ~= 1 then return end

    if dentro(mx,my,botaoEsq) and podeMover(-1,0,pecaAtual) then
        pecaPos.x = pecaPos.x - 1
    end

    if dentro(mx,my,botaoDir) and podeMover(1,0,pecaAtual) then
        pecaPos.x = pecaPos.x + 1
    end

    if dentro(mx,my,botaoGira) then
        local g = giraMatrix(pecaAtual)
        if podeMover(0,0,g) then pecaAtual = g end
    end

    if dentro(mx,my,botaoB) then
        if podeMover(0,1,pecaAtual) then
            pecaPos.y = pecaPos.y + 1
        else
            fixaPeca()
            limparLinhas()
            randomPeca()
        end
    end
end
function dentro(mx, my, botao)
    return
        mx >= botao.x and
        mx <= botao.x + botao.w and
        my >= botao.y and
        my <= botao.y + botao.h
end

return jogo