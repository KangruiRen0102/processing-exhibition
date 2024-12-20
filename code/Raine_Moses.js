let circleY = 20; // Height of the circle
let circleD = 20; // Diameter of the circle
let triX;
let triY;
let dim;
let k;
let n;
let x = 1;

let circX;
let circY;
let posX;
let posY;
let velX;
let velY;
let numCircles = 150;

function setup() {
  createCanvas(1000, 500);
  triX = width / 2 - 10;
  triY = height - 10;
  dim = 255;
  k = 1;
  n = 1;

  // Sand particle arrays
  posX = new Array(numCircles);
  posY = new Array(numCircles);
  velX = new Array(numCircles);
  velY = new Array(numCircles);

  for (let i = 0; i < numCircles; i++) {
    posX[i] = random(-200, width);
    posY[i] = random(0, height);
    velX[i] = random(1, 2);
    velY[i] = random(-0.5, 0.5);
  }
}

function draw() {
  if (circleY < height - circleD / 2 && frameCount < 100) {
    background(135, 150, 161);

    // Grass
    strokeWeight(40);
    stroke(101, 67, 33);
    line(0, 475, width, 475);
    stroke(77, 155, 55);
    line(0, 450, width, 450);

    // White line
    stroke(255);
    strokeWeight(3);
    line(width / 2, circleY, width / 2, circleY - circleD);

    // Black square
    rectMode(CENTER);
    fill(50);
    noStroke();
    square(width / 2, circleY - circleD / 2, circleD / 3);

    // Black circle
    fill(50);
    noStroke();
    circle(width / 2, circleY, circleD);

    // White arc
    stroke(150);
    arc(width / 2, circleY, circleD / 1.3, circleD / 1.3, HALF_PI, PI);

    // Orange circle
    fill(255, 165, 0);
    noStroke();
    circle(width / 2, circleY - circleD, circleD / 4);

    // Orange triangle
    fill(255, 165, 0);
    noStroke();
    triangle(
      width / 2 - circleD / 8,
      circleY - circleD,
      width / 2 + circleD / 8,
      circleY - circleD,
      width / 2,
      circleY - circleD - circleD / 4
    );

    // Yellow circle
    fill(255, 255, 0);
    noStroke();
    circle(width / 2, circleY - circleD, circleD / 8);

    x += 0.2;
    circleY = x * x;
    circleD += 0.5;

    // --------------------------------------------------------------------------------------------
  } else if (frameCount >= 100 && frameCount <= 108) {
    background(200);

    // Explosion circle
    fill(150);
    noStroke();
    circle(width / 2, height, 12 * k);

    // Explosion polygon
    fill(255, 165, 0);
    beginShape();
    vertex(width / 2 - 50, height);
    vertex(width / 2 - 80, height - 30);
    vertex(width / 2 - 25, height - 10);
    vertex(width / 2 - 50, height - 60);
    vertex(width / 2, height - 10);
    vertex(width / 2 + 50, height - 60);
    vertex(width / 2 + 25, height - 10);
    vertex(width / 2 + 80, height - 30);
    vertex(width / 2 + 50, height);
    endShape(CLOSE);

    // Fragments
    fill(0);
    noStroke();
    triangle(
      triX - 10 * k,
      triY - 5 * k,
      triX + 10 - 10 * k,
      triY + 10 - 5 * k,
      triX + 10 - 10 * k,
      triY - 10 - 5 * k
    );
    triangle(
      triX + 5 * k,
      triY - 8 * k,
      triX + 20 + 5 * k,
      triY - 20 - 8 * k,
      triX + 40 + 5 * k,
      triY + 20 - 8 * k
    );
    triangle(
      triX + 0 * k,
      triY - 9 * k,
      triX + 10 + 0 * k,
      triY - 20 - 9 * k,
      triX + 20 + 0 * k,
      triY + 20 - 9 * k
    );
    triangle(
      triX - 5 * k,
      triY - 8 * k,
      triX + 20 - 5 * k,
      triY - 20 - 8 * k,
      triX + 30 - 5 * k,
      triY + 20 - 8 * k
    );
    triangle(
      triX + 10 * k,
      triY - 5 * k,
      triX + 20 + 10 * k,
      triY - 20 - 5 * k,
      triX + 40 + 10 * k,
      triY + 20 - 5 * k
    );

    k += 4;
    // -------------------------------------------------------------------------------------------
  } else if (frameCount > 108 && frameCount <= 250) {
    background(dim);

    // Screen fade
    dim = dim - 2;
    if (dim < 0) dim = 0;

    // --------------------------------------------------------------------------------------------
  } else if (frameCount > 250 && frameCount <= 350) {
    background(0);

    // Time text
    fill(34, 76, 98);
    textSize(500);
    textAlign(CENTER, CENTER);
    text("TIME", width / 2, height / 2);

    // Sand in the hourglass
    fill(194, 178, 128);
    noStroke();
    beginShape();
    vertex(width / 2 - 40, height / 2 + 80);
    vertex(width / 2 - 30, height / 2 + 60);
    vertex(width / 2, height / 2 + 50);
    vertex(width / 2 + 30, height / 2 + 60);
    vertex(width / 2 + 40, height / 2 + 80);
    endShape(CLOSE);
    triangle(
      width / 2,
      height / 2,
      width / 2 - 20,
      height / 2 - 40,
      width / 2 + 20,
      height / 2 - 40
    );
    stroke(194, 178, 128);
    strokeWeight(2);
    line(width / 2, height / 2, width / 2, height / 2 + 50);

    // Hourglass glass
    noFill();
    stroke(255);
    strokeWeight(2);
    triangle(width / 2, height / 2, width / 2 - 40, height / 2 - 80, width / 2 + 40, height / 2 - 80);
    triangle(width / 2, height / 2, width / 2 - 40, height / 2 + 80, width / 2 + 40, height / 2 + 80);

    // Hourglass top and bottom
    fill(255);
    rect(width / 2 - 50, height / 2 - 90, 100, 20);
    rect(width / 2 - 50, height / 2 + 70, 100, 20);

    // Sand particles
    for (let i = 0; i < numCircles; i++) {
      // Update positions
      posX[i] += velX[i];
      posY[i] += velY[i];
      // Draw circles
      fill(194, 178, 128);
      noStroke();
      circle(posX[i], posY[i], 5);
    }
    // ------------------------------------------------------------------------------
  } else if (frameCount > 350 && frameCount <= 450) {
    background(0);

    // Infinity text
    fill(100);
    textSize(100);
    textAlign(CENTER, CENTER);
    text("I    N    F    I      N    I    T    Y", width / 2, height / 2 - 20);

    // Infinity symbol
    fill(255);
    textSize(800);
    textAlign(CENTER, CENTER);
    text("\u221e", width / 2, height / 2 - 40);

    // Blue and red light rays
    stroke(28, 107, 160);
    strokeWeight(50);
    line(width / 2 - width / 2 + 10 * k, height, width / 2 - width + 20 * k, 0);
    stroke(220, 20, 60);
    line(width / 2 + width / 2 - 10 * k, height, width / 2 + width - 20 * k, 0);

    k += 1;
    // --------------------------------------------------------------------------------
  } else if (frameCount > 450 && frameCount <= 600) {
    background(0);

    // Stars
    for (let i = 0; i < numCircles; i++) {
      // Draw circles
      fill(255);
      noStroke();
      circle(posX[i], posY[i], 5);
    }

    // Planet
    fill(34, 76, 98);
    noStroke();
    circle(width / 2, height / 1.5, 300);
    stroke(44, 86, 108);
    noFill();
    arc(width / 2, height / 1.5 - 150, 300, 200, PI / 4, PI / 2);
    arc(width / 2, height / 1.5 - 150, 450, 375, (5 * PI) / 12, (2 * PI) / 3);
    arc(width / 2, height / 1.5 - 150, 500, 550, (3 * PI) / 8, (7 * PI) / 12);

    // Cloud
    fill(100);
    noStroke();
    ellipse(width / 2, height / 1.5 - 130, 120 + n, 40 + n);
    fill(50);
    ellipse(width / 2, height / 1.5 - 140, 90 + n, 30 + n);

    fill(85, 70, 60);
    strokeWeight(15);
    stroke(255, 200, 150);
    line(width / 2, height / 1.5 - 150, width / 2, height / 1.5 - 225);

    stroke(85, 70, 60);
    ellipse(width / 2 - 12, height / 1.5 - 225 - n, 25, 40);
    ellipse(width / 2 + 12, height / 1.5 - 225 - n, 25, 40);
    ellipse(width / 2, height / 1.5 - 220 - n, 75, 25);
    fill(240, 160, 120);
    stroke(240, 160, 120);
    ellipse(width / 2 - 10, height / 1.5 - 150, 15, 20);
    ellipse(width / 2 + 10, height / 1.5 - 150, 15, 20);
    ellipse(width / 2, height / 1.5 - 147, 50, 15);
    noFill();
    stroke(255, 200, 150);
    strokeWeight(5);
    ellipse(width / 2, height / 1.5 - 185, 50 + n, 8);

    // Chaos text
    fill(138, 3, 3);
    textSize(150);
    textAlign(CENTER, CENTER);
    text("C", 50 + k / 5, 250 + k / 5);
    text("H", 250 + k / 5, 350 - k / 5);
    text("A", 550 - k / 5, 200 + k / 5);
    text("O", 750 - k / 5, 300 + k / 5);
    text("S", 850 + k / 5, 250 - k / 5);

    k += 1;
    n += 0.1;

    // --------------------------------------------------------------------------------
  } else {
    background(0);
  }
}
