const BALL_RADIUS = 10
const PADDLE_HEIGHT = 10
const PADDLE_WIDTH = 75
const BRICK_ROW_COUNT = 5
const BRICK_COLUMN_COUNT = 3
const BRICK_WIDTH = 75
const BRICK_HEIGHT = 20
const BRICK_PADDING = 10
const BRICK_OFFSET_TOP = 30
const BRICK_OFFSET_LEFT = 30

let state;

const updateState = #(f) => {
  state = f(state)
}

const createState = #() => {
  const canvas = document.getElementById("myCanvas2")
  #{
    canvas
    ctx: canvas.getContext("2d")
    x: canvas.width / 2
    y: canvas.height - 30
    paddleX: #(canvas.width - PADDLE_WIDTH) / 2
    score: 0
    lives: 3
    dx: 2
    dy: -2
    bricks: for(
      column range(0 BRICK_COLUMN_COUNT)
      row range(0 BRICK_ROW_COUNT)
    ) {
      #{
        x: #(row * #(BRICK_WIDTH + BRICK_PADDING)) + BRICK_OFFSET_LEFT
        y: #(column * #(BRICK_HEIGHT + BRICK_PADDING)) + BRICK_OFFSET_TOP
        row
        column
      }
    }
  }
}

const drawBall = #() => {
  const ctx = state.:ctx
  ctx.beginPath()
  ctx.arc(state.:x state.:y BALL_RADIUS 0 Math.PI * 2)
  ctx.fillStyle = "#0095DD"
  ctx.fill()
  ctx.closePath()
}

const drawPaddle = #() => {
  const ctx = state.:ctx
  const canvas = state.:canvas
  ctx.beginPath()
  ctx.rect(state.:paddleX canvas.height - PADDLE_HEIGHT PADDLE_WIDTH PADDLE_HEIGHT)
  ctx.fillStyle = "#0095DD"
  ctx.fill()
  ctx.closePath()
}

const drawBricks = #() => {
  const ctx = state.:ctx
  doAll(map(state.:bricks #(b) => {
    ctx.beginPath()
    ctx.rect(b.:x b.:y BRICK_WIDTH BRICK_HEIGHT)
    ctx.fillStyle = "#0095DD"
    ctx.fill()
    ctx.closePath()
  }))
}

const drawScore = #() => {
  const ctx = state.:ctx
  ctx.font = "16px Arial"
  ctx.fillStyle = "#0095DD"
  ctx.fillText("Score: " + state.:score 8 20)
}

const drawLives = #() => {
  const ctx = state.:ctx
  const canvas = state.:canvas
  ctx.font = "16px Arial"
  ctx.fillStyle = "#0095DD"
  ctx.fillText("Lives: " + state.:lives canvas.width - 65 20)
}

const collisionDetection = #(state) => {
  const bricks = filter(state.:bricks #(b) => !#(
    state.:x > b.:x &&
    state.:x < b.:x + BRICK_WIDTH &&
    state.:y > b.:y &&
    state.:y < b.:y + BRICK_HEIGHT))

  if (count(state.:bricks) > count(bricks)) {
    // A brick was removed due to collision
    chain(state) {
      set(:bricks bricks)
      update(:dy #(v) => v * -1)
      update(:score #(v) => v + 1)
    }
  }
  else {
    set(state :bricks bricks)
  }
}

const moveBall = #(state) => {
  const canvas = state.:canvas
  let x = state.:x
  let dx = state.:dx
  let y = state.:y
  let dy = state.:dy
  let lives = state.:lives
  let paddleX = state.:paddleX

  if (x + dx > canvas.width - BALL_RADIUS || x + dx < BALL_RADIUS) {
    dx = -1 * dx
  }
  if (y + dy < BALL_RADIUS) {
    dy = -1 * dy
  }
  elseif (y + dy > canvas.height - BALL_RADIUS) {
    if (x > paddleX && x < paddleX + PADDLE_WIDTH) {
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
        paddleX = #(canvas.width - PADDLE_WIDTH) / 2
      }
    }
  }
  x = x + dx
  y = y + dy
  chain(state) {
    set(:x x)
    set(:y y)
    set(:dx dx)
    set(:dy dy)
    set(:lives lives)
    set(:paddleX paddleX)
  }
}

const draw = #() => {
  const canvas = state.:canvas
  const ctx = state.:ctx
  ctx.clearRect(0 0 canvas.width canvas.height)
  drawBricks()
  drawBall()
  drawPaddle()
  drawScore()
  drawLives()
  updateState(collisionDetection)

  if (state.:score == BRICK_ROW_COUNT * BRICK_COLUMN_COUNT) {
    alert("YOU WIN CONGRATS!")
    document.location.reload()
  }
  else {
    updateState(moveBall)
    requestAnimationFrame(draw)
  }

}

const main = #() => {
  // Initialize state
  updateState(createState)

  document.addEventListener("mousemove" #(e) => {
    updateState(#(state) => {
      const relativeX = e.clientX - state.:canvas.offsetLeft
      if (relativeX > 0 && relativeX < state.:canvas.width) {
        set(state :paddleX relativeX - PADDLE_WIDTH / 2)
      }
      else {
        state
      }
    })
  } false)

  draw()
}

module.exports = jsObject(#{
  main
})
