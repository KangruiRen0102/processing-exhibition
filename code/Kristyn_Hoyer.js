let increment = 0.01;
let zoff = 0.0;  // The noise function's 3rd argument, treated as time
let zincrement = 0.02; 
let c = 0;  // Counter for mouse presses
let c2 = 0; // Counter for how long a key was pressed

function setup() {
  createCanvas(640, 360, WEBGL);
  background(0);
}

function draw() {
  if (mouseIsPressed) {
    Memory_Loading();
    c++;
  }

  if (c > 10) {
    Chaotic_Random_Memory();
  }

  if (keyIsPressed) {
    Hope_Directional();
    c2++;
  }

  if (c2 > 15) {
    Hope_Spots();
  }

  if (mouseY <= 170 && mouseY >= 140) {
    background(0, 60, 125);
    Hope();
  }
}

// Function to symbolize a hazy memory
function Memory_Loading() {
  frameRate(30);
  let xoff = 0.0;
  loadPixels();

  for (let x = 0; x < width; x++) {
    xoff += increment;
    let yoff = 0.0;

    for (let y = 0; y < height; y++) {
      yoff += increment;
      let bright = noise(xoff, yoff, zoff) * 255;
      let idx = (x + y * width) * 4;
      pixels[idx] = bright;
      pixels[idx + 1] = bright;
      pixels[idx + 2] = bright;
      pixels[idx + 3] = 255;
    }
  }

  updatePixels();
  zoff += zincrement;
}

// Function to symbolize a chaotic memory
function Chaotic_Random_Memory() {
  background(0);
  strokeWeight(20);
  frameRate(2);

  for (let i = 0; i < width; i++) {
    let r = random(255);
    stroke(r);
    line(i, 0, i, height);
  }
}

// Function to symbolize digging deeper into a memory
function Hope_Directional() {
  noStroke();
  background(0);
  let dirY = (mouseY / height - 0.5) * 2;
  let dirX = (mouseX / width - 0.5) * 2;
  directionalLight(204, 204, 204, -dirX, -dirY, -1);

  push();
  translate(-100, 0, 0);
  sphere(80);
  pop();

  push();
  translate(100, 0, 0);
  sphere(80);
  pop();
}

// Function to symbolize searching for hope
function Hope_Spots() {
  noStroke();
  fill(204);
  background(0);
  sphereDetail(60);

  directionalLight(51, 102, 126, 0, -1, 0);
  spotLight(204, 153, 0, 360, 160, 600, 0, 0, -1, PI / 2, 600);
  spotLight(102, 153, 204, 360, mouseY, 600, 0, 0, -1, PI / 2, 600);

  push();
  translate(0, 0, 0);
  sphere(120);
  pop();
}

// Function to symbolize hope being found
function Hope() {
  let c = color(125, 0, 200);
  fill(c);
  noStroke();
  ellipse(-200, -100, 320, 320);

  c = color(75);
  fill(c);
  ellipse(200, 100, 320, 320);
}
