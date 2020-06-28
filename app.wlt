let canvas
let ctx
const ballRadius = 10
let x
let y
let dx = 2
let dy = -2
const paddleHeight = 10
const paddleWidth = 75
let paddleX
let rightPressed = false
let leftPressed = false
const brickRowCount = 5
const brickColumnCount = 3
const brickWidth = 75
const brickHeight = 20
const brickPadding = 10
const brickOffsetTop = 30
const brickOffsetLeft = 30
let score = 0
let lives = 3

let bricks

const keyDownHandler = #(e) => {
  if (e.keyCode == 39) {
    rightPressed = true
  }
  elseif (e.keyCode == 37) {
    leftPressed = true
  }
}
const keyUpHandler = #(e) => {
  if (e.keyCode == 39) {
    rightPressed = false
  }
  elseif (e.keyCode == 37) {
    leftPressed = false
  }
}
const mouseMoveHandler = #(e) => {
  const relativeX = e.clientX - canvas.offsetLeft
  if (relativeX > 0 && relativeX < canvas.width) {
    paddleX = relativeX - paddleWidth / 2
  }
}

const collisionDetection = #() => {
  bricks = doAll(map(bricks #(b) => {
    if (b.:status == 1 && x > b.:x && x < b.:x + brickWidth && y > b.:y && y < b.:y + brickHeight) {
      dy = -1 * dy
      score = score + 1
      if (score == brickRowCount * brickColumnCount) {
        alert("YOU WIN CONGRATS!")
        document.location.reload()
      }
      else {
        set(b :status 0)
      }
    }
    else {
      b
    }
  }))
}

const drawBall = #() => {
  ctx.beginPath()
  ctx.arc(x y ballRadius 0 Math.PI * 2)
  ctx.fillStyle = "#0095DD"
  ctx.fill()
  ctx.closePath()
}

const drawPaddle = #() => {
  ctx.beginPath()
  ctx.rect(paddleX canvas.height - paddleHeight paddleWidth paddleHeight)
  ctx.fillStyle = "#0095DD"
  ctx.fill()
  ctx.closePath()
}


// TODO this is combining drawing a brick with moving the brick. Change it.
const drawBricks = #() => {
  bricks = doAll(map(bricks #(b) => {
    if (b.:status == 1) {
      const brickX = #(b.:row * #(brickWidth + brickPadding)) + brickOffsetLeft
      const brickY = #(b.:column * #(brickHeight + brickPadding)) + brickOffsetTop
      ctx.beginPath()
      ctx.rect(brickX brickY brickWidth brickHeight)
      ctx.fillStyle = "#0095DD"
      ctx.fill()
      ctx.closePath()
      chain(b) {
        set(:x brickX)
        set(:y brickY)
      }
    }
    else {
      b
    }
  }))
}

const drawScore = #() => {
  ctx.font = "16px Arial"
  ctx.fillStyle = "#0095DD"
  ctx.fillText("Score: " + score 8 20)
}

const drawLives = #() => {
  ctx.font = "16px Arial"
  ctx.fillStyle = "#0095DD"
  ctx.fillText("Lives: " + lives canvas.width - 65 20)
}

const draw = #() => {
  ctx.clearRect(0 0 canvas.width canvas.height)
  drawBricks()
  drawBall()
  drawPaddle()
  drawScore()
  drawLives()
  collisionDetection()

  if (x + dx > canvas.width - ballRadius || x + dx < ballRadius) {
    dx = -1 * dx
  }
  if (y + dy < ballRadius) {
    dy = -1 * dy
  }
  elseif (y + dy > canvas.height - ballRadius) {
    if (x > paddleX && x < paddleX + paddleWidth) {
        dy = -1 * dy
    }
    else {
      lives = lives - 1
      if (lives == 0) {
        alert("GAME OVER")
        document.location.reload()
      }
      else {
        x = canvas.width / 2
        y = canvas.height - 30
        dx = 3
        dy = -3
        paddleX = #(canvas.width - paddleWidth) / 2
      }
    }
  }

  if (rightPressed && paddleX < canvas.width - paddleWidth) {
    paddleX = paddleX + 7
  }
  elseif (leftPressed && paddleX > 0) {
    paddleX = paddleX - 7
  }

  x = x + dx
  y = y + dy
  requestAnimationFrame(draw)
}

const main = #() => {
  canvas = document.getElementById("myCanvas2")
  ctx = canvas.getContext("2d")
  x = canvas.width / 2
  y = canvas.height - 30
  paddleX = #(canvas.width - paddleWidth) / 2

  document.addEventListener("keydown" keyDownHandler false)
  document.addEventListener("keyup" keyUpHandler false)
  document.addEventListener("mousemove" mouseMoveHandler false)

  bricks = for(
    column range(0 brickColumnCount)
    row range(0 brickRowCount)
  ) {
    // TODO change status from a number to a boolean
    #{
      x: 0
      y: 0
      status: 1
      row
      column
    }
  }

  draw()
}

module.exports = jsObject(#{
  main
})
