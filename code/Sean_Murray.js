let cols, rows;
let scl = 20;
let w = 2000;
let h = 1600;
let a = true;
let move = 0;
let t = [];
let Rp, Gp, Yp;

function setup() {
  createCanvas(1000, 1000, WEBGL);
  cols = w / scl;
  rows = h / scl;
  
  // Initialize 2D array for terrain
  for (let x = 0; x < cols; x++) {
    t[x] = [];
    for (let y = 0; y < rows; y++) {
      t[x][y] = 0;
    }
  }

  // Create planet shapes with colors
  Rp = createSphere(250, color(255, 0, 0));
  Gp = createSphere(150, color(0, 255, 0));
  Yp = createSphere(70, color(0, 0, 255));
}

function draw() {
  move += 0.01;
  let yoff = move;

  // Generate terrain using Perlin noise
  for (let y = 0; y < rows; y++) {
    let xoff = 0;
    for (let x = 0; x < cols; x++) {
      t[x][y] = map(noise(xoff, yoff), 0, 1, -60, 60);
      xoff += 0.2;
    }
    yoff += 0.2;
  }

  background(0);
  stroke(255);
  fill(51, 153, 255);

  // Set perspective and center the terrain
  translate(width / 2, height / 2);
  rotateX(PI / 3);
  translate(-w / 2, -h / 2);

  // Draw terrain using triangle strips
  for (let y = 0; y < rows - 1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (let x = 0; x < cols; x++) {
      vertex(x * scl, y * scl, t[x][y]);
      vertex(x * scl, (y + 1) * scl, t[x][y + 1]);
    }
    endShape();
  }

  // Move to position for planets
  translate(0, 230, -460);
  rotateX(PI / 3);

  if (a) {
    // Red Planet
    push();
    translate(0.95 * width, 0.7 * height, -20);
    rotateY(PI * frameCount / 500);
    Rp.display();
    pop();

    // Green Planet
    push();
    rotateY(-PI * frameCount / 1000);
    translate(0.5 * width, 0.5 * height, 100);
    Gp.display();
    pop();

    // Yellow Planet
    push();
    rotateY(PI * frameCount / 1000);
    translate(width, height, 100);
    Yp.display();
    pop();
  } else {
    // Red Planet (stationary)
    push();
    translate(0.95 * width, 0.7 * height, -20);
    Rp.display();
    pop();

    // Green Planet
    push();
    rotateY(-PI * frameCount / 1000);
    translate(0.5 * width, 0.5 * height, 100);
    Gp.display();
    pop();

    // Yellow Planet
    push();
    rotateY(PI * frameCount / 1000);
    translate(width, height, 100);
    Yp.display();
    pop();
  }
}

function mousePressed() {
  a = !a;
}

function createSphere(size, fillColor) {
  let sphereShape = createGraphics(1, 1, WEBGL);
  sphereShape.noStroke();
  sphereShape.fill(fillColor);
  sphereShape.sphere(size);
  return {
    display: function () {
      texture(sphereShape);
      sphere(size);
    }
  };
}
