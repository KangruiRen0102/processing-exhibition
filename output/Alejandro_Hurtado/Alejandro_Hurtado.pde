// Labyrinth dimensions
int cols, rows; // Number of columns and rows in the grid
int cellSize = 120; // Size of each cell in the labyrinth
Cell[][] grid; // 2D array to store the labyrinth cells
ArrayList<Cell> stack = new ArrayList<>(); // Stack for backtracking during maze generation
Cell current; // The current cell being processed
Cell goal; // The exit cell, which represents the goal of the maze

// Player variables
float ballX, ballY; // Position of the player's ball
float ballSize = 20; // Diameter of the ball
float ballSpeed = 3; // Speed at which the ball moves
float velX = 0, velY = 0; // Velocity components of the ball
color ballColor = color(255, 192, 203); // Color of the ball (pink)

// Setup function initializes the sketch
void setup() {
  size(800, 800); // Set the canvas size
  cols = width / cellSize;  // Calculate the number of columns
  rows = height / cellSize; // Calculate the number of rows
  grid = new Cell[cols][rows]; // Create the grid array
  
  // Initialize each cell in the grid
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
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

// Main draw function for rendering the frame
void draw() {
  background(50); // Set background color to dark gray
  
  // Draw the grid (maze)
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
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

// Draw the island (goal)
void drawIsland(float x, float y) {
  // Draw water around the island
  noStroke();
  fill(0, 100, 255, 150); // Transparent blue water
  ellipse(x, y, cellSize * 1.5, cellSize * 1.5);
  
  // Draw the island itself
  fill(34, 139, 34); // Green island
  ellipse(x, y, cellSize, cellSize);
  
  // Add a glowing beacon to the goal
  fill(255, 255, 0, 150); // Faint yellow glow
  ellipse(x, y, cellSize / 2, cellSize / 2);
}

// Ball movement with collision detection
void moveBall() {
  // Calculate the ball's next position
  float nextX = ballX + velX;
  float nextY = ballY + velY;
  
  // Determine which cell the ball is currently in
  int col = floor(ballX / cellSize);
  int row = floor(ballY / cellSize);
  Cell currentCell = grid[col][row];
  
  // Check for collisions with cell walls
  if (velY < 0 && currentCell.walls[0] && ballY - ballSize / 2 <= row * cellSize) velY = 0; // Top wall
  if (velX > 0 && currentCell.walls[1] && ballX + ballSize / 2 >= (col + 1) * cellSize) velX = 0; // Right wall
  if (velY > 0 && currentCell.walls[2] && ballY + ballSize / 2 >= (row + 1) * cellSize) velY = 0; // Bottom wall
  if (velX < 0 && currentCell.walls[3] && ballX - ballSize / 2 <= col * cellSize) velX = 0; // Left wall
  
  // Update ball position
  ballX = nextX;
  ballY = nextY;
}

// Remove walls between two cells
void removeWalls(Cell a, Cell b) {
  int x = a.col - b.col;
  int y = a.row - b.row;
  
  if (x == 1) {
    a.walls[3] = false;
    b.walls[1] = false;
  } else if (x == -1) {
    a.walls[1] = false;
    b.walls[3] = false;
  }
  if (y == 1) {
    a.walls[0] = false;
    b.walls[2] = false;
  } else if (y == -1) {
    a.walls[2] = false;
    b.walls[0] = false;
  }
}

// Draw the beacon of light
void drawBeacon(float x, float y) {
  noStroke();
  fill(255, 255, 0, 100); // Semi-transparent yellow
  ellipse(x, y, cellSize, cellSize);
  fill(255, 255, 0); // Solid yellow
  ellipse(x, y, cellSize / 2, cellSize / 2);
}

// Handle key presses
void keyPressed() {
  if (keyCode == UP) velY = -ballSpeed;
  if (keyCode == DOWN) velY = ballSpeed;
  if (keyCode == LEFT) velX = -ballSpeed;
  if (keyCode == RIGHT) velX = ballSpeed;
}

// Handle key releases
void keyReleased() {
  if (keyCode == UP || keyCode == DOWN) velY = 0;
  if (keyCode == LEFT || keyCode == RIGHT) velX = 0;
}

// Generate the maze using depth-first search (DFS) algorithm
void generateMaze() {
  // Create a random stack for backtracking
  stack.add(current);
  current.visited = true;
  
  while (!stack.isEmpty()) {
    // Check unvisited neighbors
    Cell next = current.checkNeighbors();
    if (next != null) {
      next.visited = true;
      stack.add(current);
      removeWalls(current, next);
      current = next;
    } else {
      current = stack.remove(stack.size() - 1); // Backtrack
    }
  }
}

// Cell class for individual maze cells
class Cell {
  int col, row;
  boolean[] walls = {true, true, true, true}; // Top, right, bottom, left
  boolean visited = false;
  
  Cell(int col, int row) {
    this.col = col;
    this.row = row;
  }
  
  void show() {
    int x = col * cellSize;
    int y = row * cellSize;
    stroke(255);
    
    // Draw walls
    if (walls[0]) line(x, y, x + cellSize, y); // Top
    if (walls[1]) line(x + cellSize, y, x + cellSize, y + cellSize); // Right
    if (walls[2]) line(x + cellSize, y + cellSize, x, y + cellSize); // Bottom
    if (walls[3]) line(x, y + cellSize, x, y); // Left
    
    // Highlight visited cells
    if (visited) {
      noStroke();
      fill(100, 100, 255, 100); // Semi-transparent blue
      rect(x, y, cellSize, cellSize);
    }
  }
  
  // Check unvisited neighbors
  Cell checkNeighbors() {
    ArrayList<Cell> neighbors = new ArrayList<>();
    
    // Get neighbors
    Cell top = (row > 0) ? grid[col][row - 1] : null;
    Cell right = (col < cols - 1) ? grid[col + 1][row] : null;
    Cell bottom = (row < rows - 1) ? grid[col][row + 1] : null;
    Cell left = (col > 0) ? grid[col - 1][row] : null;
    
    // Add unvisited neighbors to list
    if (top != null && !top.visited) neighbors.add(top);
    if (right != null && !right.visited) neighbors.add(right);
    if (bottom != null && !bottom.visited) neighbors.add(bottom);
    if (left != null && !left.visited) neighbors.add(left);
    
    // Return a random unvisited neighbor, or null if none
    if (neighbors.size() > 0) {
      int index = int(random(neighbors.size()));
      return neighbors.get(index);
    } else {
      return null;
    }
  }
}
