-- parametros da janela
local WINDOW_WIDTH = 800
local WINDOW_HEIGHT = 600

-- estado
local gamestate = ''

-- Funções
function love.load()
    -- Janela
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Coloca no menu
    gamestate = 'MainMenu'

    -- carrega fonte
    menu_font = love.graphics.newFont('/assets/fonts/menu_font.ttf', 52)
    menu_font_small = love.graphics.newFont('/assets/fonts/menu_font.ttf', 25)

    -- titulo janela
    love.window.setTitle('Linear Project')

    -- coloca imagem
    mapa = love.graphics.newImage('/assets/images/mapa.png')

    -- Inicializa os resultados
    sol = ""
    avaliacao = ""
end

function love.update(dt)
    if gamestate == 'PlayState' then
        -- se necessario dar update no playstate
    end
end

function love.draw()
    if gamestate == 'MainMenu' then
        love.graphics.setBackgroundColor(0.5, 0.5, 0.5)
        love.graphics.setFont(menu_font)
        love.graphics.printf('Caixeiro Viajante', 0, 0, WINDOW_WIDTH, "center")
        love.graphics.setFont(menu_font_small)
        love.graphics.printf('Mapa da cidade', 0, 80, WINDOW_WIDTH, "center")
        love.graphics.draw(mapa, 200, 200, 0, 0.4)
        love.graphics.printf('A', 65, 285, WINDOW_WIDTH, "center")
        love.graphics.printf('B', -50, 410, WINDOW_WIDTH, "center")
        love.graphics.printf('C', -140, 285, WINDOW_WIDTH, "center")
        love.graphics.printf('D', 0, 310, WINDOW_WIDTH, "center")
    end

    if gamestate == 'PlayState' then
        love.graphics.setBackgroundColor(0.2, 0.2, 0.2)

        -- Mostra os resultados
        love.graphics.setFont(menu_font_small)
        love.graphics.printf('Solucao Inicial: ' .. table.concat(sol, ', '), 0, 10, WINDOW_WIDTH, "center")
        love.graphics.printf('Avaliacao: ' .. avaliacao, 0, 40, WINDOW_WIDTH, "center")
    end
end

function love.keypressed(key)
    if key == 'space' then
        if gamestate == 'MainMenu' then
            sol = Solucao_inicial(#matriz)
            avaliacao = avalia(sol, matriz)
            gamestate = 'PlayState'
        end
    end
end

-- Função para verificar se um valor está em uma tabela
function tableContains(tbl, value)
    for i, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

function Solucao_inicial(tamanhomattriz)
    math.randomseed(os.time())  -- Define lugar uma vez no início do programa
    local sequencia_atual = {}

    -- Crie uma sequência aleatória única
    while #sequencia_atual < tamanhomattriz do
        local valor = math.random(tamanhomattriz)
        if not tableContains(sequencia_atual, valor) then
            table.insert(sequencia_atual, valor)
        end
    end

    return sequencia_atual
end

function avalia(sequencia, matriz)
    local distancia_total = 0

    for i = 1, #sequencia do
        local origem = sequencia[i]
        local destino

        if i < #sequencia then
            destino = sequencia[i + 1]
        else
            destino = sequencia[1]  -- Volte para o ponto inicial
        end

        local distancia = matriz[origem][destino]
        distancia_total = distancia_total + distancia
    end

    -- Adiciona uma pequena mudanca de 1% a 10% na distancia
    local variacao = love.math.random(1, 10) / 100
    distancia_total = distancia_total + distancia_total * variacao

    return distancia_total
end

matriz = {
    {0, 10, 20, 30},
    {10, 0, 40, 50},
    {20, 40, 0, 60},
    {30, 50, 60, 0},
}
