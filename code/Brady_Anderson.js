let snowflakeCount = 200; // Number of snowflakes
let snowflakes = []; // Array to store snowflakes

function setup() {
  createCanvas(930, 400);
  
  // Initialize snowflakes
  for (let i = 0; i < snowflakeCount; i++) {
    snowflakes.push(new Snowflake());
  }
}

function draw() {
  // Draw twilight sky
  drawTwilightSky();

  // Draw Edmonton skyline
  drawBuildings();

  // Draw and animate snowfall
  for (let i = 0; i < snowflakeCount; i++) {
    snowflakes[i].fall();
    snowflakes[i].display();
  }
}

function drawTwilightSky() {
  // Create a gradient from dark blue to orange
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0, 1);
    let c = lerpColor(color(25, 25, 112), color(255, 140, 0), inter);
    stroke(c);
    line(0, y, width, y); // Draw horizontal line
  }
}

function drawBuildings() {
  fill(0); // Black fill for buildings
  noStroke();

  // Ground
  rect(0, 370, width, 30);

  // Draw the skyline
  rect(0, 300, 30, 100);
  rect(40, 170, 50, 230);
  rect(45, 130, 40, 50);
  rect(37.5, 340, 55, 60);

  rect(100, 220, 40, 200);
  triangle(105, 220, 105, 205, 135, 220);

  rect(155, 205, 50, 195);
  rect(150, 350, 60, 50);
  rect(215, 150, 70, 350);
  rect(210, 340, 80, 60);

  rect(300, 330, 230, 70);
  rect(375, 315, 80, 30);
  rect(390, 210, 50, 105);
  triangle(390, 210, 415, 180, 440, 210);
  rect(412.5, 160, 5, 25);

  rect(540, 240, 60, 150);
  triangle(540, 240, 540, 220, 600, 240);

  rect(610, 170, 100, 200);
  rect(620, 150, 80, 20);
  rect(630, 130, 10, 20);
  rect(680, 130, 10, 20);

  rect(725, 135, 60, 265);
  rect(730, 120, 50, 15);

  rect(795, 200, 110, 170);
  triangle(797.5, 200, 850, 150, 902.5, 200);
  rect(830, 150, 40, 50);
}

// Snowflake class
class Snowflake {
  constructor() {
    this.x = random(width);      // Random x position
    this.y = random(-height, 0); // Start above the screen
    this.speed = random(1, 3);   // Random falling speed
    this.size = random(2, 5);    // Random snowflake size
  }

  fall() {
    this.y += this.speed;        // Move snowflake downward
    if (this.y > height) {       // Reset snowflake position if off-screen
      this.y = random(-50, 0);
      this.x = random(width);
    }
  }

  display() {
    fill(255); // White snowflake
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }
}
