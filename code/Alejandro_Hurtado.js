let cols, rows; // Number of columns and rows in the grid
let cellSize = 120; // Size of each cell in the labyrinth
let grid = []; // 2D array to store the labyrinth cells
let stack = []; // Stack for backtracking during maze generation
let current; // The current cell being processed
let goal; // The exit cell, which represents the goal of the maze

// Player variables
let ballX, ballY; // Position of the player's ball
let ballSize = 20; // Diameter of the ball
let ballSpeed = 3; // Speed at which the ball moves
let velX = 0, velY = 0; // Velocity components of the ball
let ballColor; // Color of the ball

function setup() {
  createCanvas(800, 800);
  cols = floor(width / cellSize); // Calculate the number of columns
  rows = floor(height / cellSize); // Calculate the number of rows
  ballColor = color(255, 192, 203); // Pink ball color

  // Initialize each cell in the grid
  for (let x = 0; x < cols; x++) {
    grid[x] = [];
    for (let y = 0; y < rows; y++) {
      grid[x][y] = new Cell(x, y);
    }
  }

  // Start maze generation from the top-left cell
  current = grid[0][0];
  goal = grid[cols - 1][rows - 1]; // Set the goal at the bottom-right corner

  // Make the goal an island with intact walls
  goal.walls[0] = true; // Top wall
  goal.walls[1] = true; // Right wall
  goal.walls[2] = true; // Bottom wall
  goal.walls[3] = true; // Left wall

  // Initialize the player's starting position at the center of the first cell
  ballX = cellSize / 2;
  ballY = cellSize / 2;

  // Generate the maze using depth-first search (DFS)
  generateMaze();
}

function draw() {
  background(50); // Set background color to dark gray

  // Draw the grid (maze)
  for (let x = 0; x < cols; x++) {
    for (let y = 0; y < rows; y++) {
      grid[x][y].show();
    }
  }

  // Draw the goal (island)
  drawIsland(goal.col * cellSize + cellSize / 2, goal.row * cellSize + cellSize / 2);

  // Update and move the ball
  moveBall();

  // Slowly increase the ball's size over time
  ballSize += 0.1;

  // Draw the player's ball
  fill(ballColor); // Set the ball color
  noStroke();
  ellipse(ballX, ballY, ballSize, ballSize);

  // Check if the player has reached the goal
  if (dist(ballX, ballY, goal.col * cellSize + cellSize / 2, goal.row * cellSize + cellSize / 2) < ballSize) {
    textSize(70);
    fill(255, 255, 0); // Yellow text color
    textAlign(CENTER, CENTER);
    text("YOU REACHED HOPE!!", width / 2, height / 2); // Display message when the island is reached
    noLoop(); // Stop the draw loop
  }
}

function drawIsland(x, y) {
  noStroke();
  fill(0, 100, 255, 150); // Transparent blue water
  ellipse(x, y, cellSize * 1.5, cellSize * 1.5);

  fill(34, 139, 34); // Green island
  ellipse(x, y, cellSize, cellSize);

  fill(255, 255, 0, 150); // Faint yellow glow
  ellipse(x, y, cellSize / 2, cellSize / 2);
}

function moveBall() {
  let nextX = ballX + velX;
  let nextY = ballY + velY;

  let col = floor(ballX / cellSize);
  let row = floor(ballY / cellSize);
  let currentCell = grid[col][row];

  if (velY < 0 && currentCell.walls[0] && ballY - ballSize / 2 <= row * cellSize) velY = 0; // Top wall
  if (velX > 0 && currentCell.walls[1] && ballX + ballSize / 2 >= (col + 1) * cellSize) velX = 0; // Right wall
  if (velY > 0 && currentCell.walls[2] && ballY + ballSize / 2 >= (row + 1) * cellSize) velY = 0; // Bottom wall
  if (velX < 0 && currentCell.walls[3] && ballX - ballSize / 2 <= col * cellSize) velX = 0; // Left wall

  ballX = nextX;
  ballY = nextY;
}

function keyPressed() {
  if (keyCode === UP_ARROW) velY = -ballSpeed;
  if (keyCode === DOWN_ARROW) velY = ballSpeed;
  if (keyCode === LEFT_ARROW) velX = -ballSpeed;
  if (keyCode === RIGHT_ARROW) velX = ballSpeed;
}

function keyReleased() {
  if (keyCode === UP_ARROW || keyCode === DOWN_ARROW) velY = 0;
  if (keyCode === LEFT_ARROW || keyCode === RIGHT_ARROW) velX = 0;
}

function generateMaze() {
  stack.push(current);
  current.visited = true;

  while (stack.length > 0) {
    let next = current.checkNeighbors();
    if (next) {
      next.visited = true;
      stack.push(current);
      removeWalls(current, next);
      current = next;
    } else {
      current = stack.pop(); // Backtrack
    }
  }
}

function removeWalls(a, b) {
  let x = a.col - b.col;
  let y = a.row - b.row;

  if (x === 1) {
    a.walls[3] = false;
    b.walls[1] = false;
  } else if (x === -1) {
    a.walls[1] = false;
    b.walls[3] = false;
  }
  if (y === 1) {
    a.walls[0] = false;
    b.walls[2] = false;
  } else if (y === -1) {
    a.walls[2] = false;
    b.walls[0] = false;
  }
}

class Cell {
  constructor(col, row) {
    this.col = col;
    this.row = row;
    this.walls = [true, true, true, true]; // Top, right, bottom, left
    this.visited = false;
  }

  show() {
    let x = this.col * cellSize;
    let y = this.row * cellSize;
    stroke(255);

    if (this.walls[0]) line(x, y, x + cellSize, y); // Top
    if (this.walls[1]) line(x + cellSize, y, x + cellSize, y + cellSize); // Right
    if (this.walls[2]) line(x + cellSize, y + cellSize, x, y + cellSize); // Bottom
    if (this.walls[3]) line(x, y + cellSize, x, y); // Left

    if (this.visited) {
      noStroke();
      fill(100, 100, 255, 100); // Semi-transparent blue
      rect(x, y, cellSize, cellSize);
    }
  }

  checkNeighbors() {
    let neighbors = [];

    let top = this.row > 0 ? grid[this.col][this.row - 1] : null;
    let right = this.col < cols - 1 ? grid[this.col + 1][this.row] : null;
    let bottom = this.row < rows - 1 ? grid[this.col][this.row + 1] : null;
    let left = this.col > 0 ? grid[this.col - 1][this.row] : null;

    if (top && !top.visited) neighbors.push(top);
    if (right && !right.visited) neighbors.push(right);
    if (bottom && !bottom.visited) neighbors.push(bottom);
    if (left && !left.visited) neighbors.push(left);

    if (neighbors.length > 0) {
      let index = floor(random(neighbors.length));
      return neighbors[index];
    } else {
      return null;
    }
  }
}
