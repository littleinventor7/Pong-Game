local function is_collide(ball,paddle)
    return ball.x <= paddle.x + paddle.width and
           paddle.x <= ball.x + ball.r and
           ball.y <= paddle.y + paddle.height and
           paddle.y <= ball.y + ball.r

end
local winning_score = 10
gameoover = false
winner = nil
gamestate = "start" 
function love.load()
    if gamestate == "pong_game" then
        love.window.setTitle("Pong Game")
        love.window.setMode(800,600)
        local paddle_w = 20 
        local paddle_h = 100  
        local ball_r = 10
        score1 = 0
        score2 = 0
        bounce_sound=love.audio.newSource("bounce.wav","static")
        score_sound=love.audio.newSource("score.wav","static")

        player1 = {
            x = 50,
            y = 240,
            width = paddle_w,
            height = paddle_h,
            color = "white"
        } 
    
        player2 = { 
            x = 800-50-paddle_w,
            y = 240,
            width = paddle_w,
            height = paddle_h,
            color = "white" 
        }

        ball = {
            x = 400 - ball_r/2,
            y = 300 -ball_r/2,
            color = "white",
            r = ball_r
        }
        ball.dx = 200 
        ball.dy = 200


    end
end  
local function resetBall()
    ball.x = 400 - ball.r/2
    ball.y = 300 -ball.r/2
    ball.dx = 200 * (math.random(2) == 1 and 1 or -1)
    ball.dy = 200 * (math.random(2) == 1 and 1 or -1)
end
function love.update(dt)
  
   if gamestate == "pong_game" then
        if love.keyboard.isDown("m") then
            gamestate = "menu" 
            love.load()
        end
    if score1 >= winning_score then
        gameoover = true
        winner = "Player 1"
        return
    elseif score2 >= winning_score then
        gameoover = true
        winner = "Player 2"
        return
    end

    if love.keyboard.isDown("w") and player1.y >=0 then
        player1.y = player1.y - 300 * dt
    elseif love.keyboard.isDown("s") and player1.y + player1.height <=600 then
        player1.y = player1.y + 300 * dt
    end
    if love.keyboard.isDown("up") and player2.y >=0 then
        player2.y = player2.y - 300 * dt
    elseif love.keyboard.isDown("down") and player2.y + player2.height <=600 then
        player2.y = player2.y + 300 * dt
    end

    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt
    if ball.y <=0 then
        ball.y =0
        ball.dy = -ball.dy
        love.audio.play(bounce_sound)
    elseif ball.y+ball.r >= 600 then
        ball.y = 600 - ball.r
        ball.dy = -ball.dy
        love.audio.play(bounce_sound)
    end

    if is_collide(ball, player1) then
        ball.x = player1.x + player1.width
        ball.dx = -ball.dx * 1.05
        love.audio.play(bounce_sound)
    elseif is_collide(ball, player2) then
        ball.x = player2.x - ball.r
        ball.dx = -ball.dx * 1.05
        love.audio.play(bounce_sound)
    end

    if ball.x + ball.r <=0 then
        score2 = score2+1
        love.audio.play(score_sound)
        resetBall()
    elseif ball.x >=800 then
        score1 = score1+1
        love.audio.play(score_sound)
        resetBall()
    end
    end
 

end
    function love.keypressed(key)
        if gamestate == "pong_game" then 
            if key=="r" and gameoover then
            score1 = 0
            score2 = 0
            gameoover = false
            winner = nil
            resetBall()
             end
        end
    end
function love.draw()
    if gamestate == "start" then
        love.graphics.setBackgroundColor(0, 0, 0)
        local titleFont = love.graphics.newFont(50)
        love.graphics.setFont(titleFont)
        love.graphics.printf("Welcome to Mini games", 0, 200, 800, "center")
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.printf("Press Enter to Start", 0, 300, 800, "center")
        if love.keyboard.isDown("return") then
            gamestate = "menu"
            love.load()
        end
    elseif gamestate == "menu" then
        love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
        local menuFont = love.graphics.newFont(40)
        love.graphics.setFont(menuFont)
        love.graphics.printf("Select a Game", 0, 150, 800, "center")
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.printf("Press 1 for Pong Game", 0, 300, 800, "center")

        if love.keyboard.isDown("1") then
            gamestate = "pong_game"
            love.load()
        end
    elseif gamestate == "pong_game" then
    if love.keyboard.isDown("m") then 
            gamestate = "menu" 
            love.load()
        end
    if gameoover then
        local gameOverFont = love.graphics.newFont(40)
        love.graphics.setFont(gameOverFont)
        love.graphics.printf("Game Over! "..winner.." wins!", 0, 250, 800, "center")
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.printf("Press R to Restart", 0, 350, 800, "center")
        return
    end
    love.graphics.setBackgroundColor(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    for i= 8, 600, 30 do
            love.graphics.rectangle("fill",395,i,10,15)
    end
    love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height)
    love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height)
    love.graphics.circle("fill", ball.x, ball.y, ball.r)

    local scoreFont = love.graphics.newFont(40)
    love.graphics.setFont(scoreFont)
    love.graphics.printf(score1,0,50,400,"center")
    love.graphics.printf(score2,400,50,400,"center")

    end
end