// Ripple properties
let centerX = 400;
let centerY = 300;
let radius = 0;
let fillColor;
let maxRadius = 1000;
let duration = 10000; // Ripple effect duration in milliseconds
let startTime;
let isCreatingRipple = false; // Flag to control ripple creation

// Text after the ripple starts, showcasing the "Hope" part of the thematic statement
let showText = false; // Flag to control text display
let textDelay = 3000; // Delay for text display in milliseconds

function setup() {
  createCanvas(800, 600);
  noFill();
  textAlign(CENTER, CENTER);
  fillColor = color(92, 150, 240); // Set the ripple color
}

function draw() {
  background(255); // Clear the screen with white

  // Display chaotic text ("Chaos" part of the thematic statement)
  drawChaosText();

  // Check if ripple creation is triggered
  if (isCreatingRipple) {
    let elapsedTime = millis() - startTime;
    let progress = min(elapsedTime / duration, 1);

    // Update the radius based on time passed
    radius = progress * maxRadius;

    // Draw the ripple circle
    fill(fillColor);
    noStroke();
    ellipse(centerX, centerY, radius * 2, radius * 2);

    // Check if 3 seconds have passed to show the text
    if (elapsedTime >= textDelay) {
      showText = true;
    }
  }

  // Display the final message ("Hope" part of the thematic statement)
  if (showText) {
    fill(255); // Set text color to white
    textSize(40);
    text("It is okay, breathe", width / 2, height / 2);
  }
}

function mousePressed() {
  isCreatingRipple = true;
  startTime = millis();
}

function drawChaosText() {
  textSize(35);
  fill(0);
  text("why can't I do better?", 200, 200);
  text("it's too much", 400, 400);
  text("what if", 150, 25);
  text("if they can do it why can't you", 230, 580);
  text("do it like they do", 620, 20);
  text("too frustrating", 105, 300);
  text("I don't want to do it anymore", 510, 260);

  textSize(45);
  text("I need to do more", 630, 550);
  text("give up", 260, 430);

  textSize(30);
  text("i'm lost", 375, 75);
  text("i'm scared to fail", 500, 175);
  text("why can't I be like them", 600, 330);
  text("be better", 600, 150);
  text("fit in", 260, 340);
  text("you have to do this", 240, 545);

  textSize(25);
  text("do more than that", 110, 170);
  text("don't make mistakes", 200, 380);
  text("dumb", 610, 440);

  fill(255, 0, 0);
  textSize(40);
  text("my efforts are not enough", 530, 290);
  text("I keep failing", 475, 50);
  text("I don't know what to do", 200, 480);
  text("i'm so jealous of them", 400, 120);

  textSize(25);
  text("do it perfectly", 530, 520);

  // Rotated text for added chaos
  push();
  translate(700, 420);
  rotate(radians(35));
  textSize(25);
  fill(0);
  text("I am not good enough", 0, 0);
  pop();

  push();
  translate(390, 310);
  rotate(radians(-45));
  textSize(20);
  fill(0);
  text("there's too many things", 0, 0);
  pop();

  push();
  translate(680, 60);
  rotate(radians(-20));
  textSize(30);
  fill(0);
  text("it never gets easier", 0, 0);
  pop();

  push();
  translate(180, 450);
  rotate(radians(20));
  textSize(30);
  fill(0);
  text("I could've done so much better", 0, 0);
  pop();

  push();
  translate(400, 530);
  rotate(radians(-30));
  textSize(25);
  fill(0);
  text("it's too hard", 0, 0);
  pop();

  push();
  translate(170, 100);
  rotate(radians(30));
  textSize(40);
  fill(0);
  text("maybe I should quit", 0, 0);
  pop();

  push();
  translate(120, 530);
  rotate(radians(-15));
  textSize(25);
  fill(0);
  text("don't deserve to rest", 0, 0);
  pop();

  push();
  translate(230, 300);
  rotate(radians(20));
  textSize(45);
  fill(255, 0, 0);
  text("wish I could be like them", 0, 0);
  pop();

  push();
  translate(620, 220);
  rotate(radians(20));
  textSize(35);
  fill(0);
  text("i'm so tired", 0, 0);
  pop();

  push();
  translate(560, 475);
  rotate(radians(10));
  textSize(35);
  fill(0);
  text("need to reach their expectations", 0, 0);
  pop();

  push();
  translate(140, 260);
  rotate(radians(10));
  textSize(40);
  fill(0);
  text("how do I do this", 0, 0);
  pop();

  push();
  translate(250, 50);
  rotate(radians(-10));
  textSize(20);
  fill(0);
  text("someone stop it please", 0, 0);
  pop();

  push();
  translate(100, 130);
  rotate(radians(20));
  textSize(25);
  fill(0);
  text("just stop", 0, 0);
  pop();

  push();
  translate(700, 190);
  rotate(radians(50));
  textSize(25);
  fill(0);
  text("how are they so perfect", 0, 0);
  pop();

  push();
  translate(500, 380);
  rotate(radians(5));
  textSize(40);
  fill(255, 0, 0);
  text("will it ever get better", 0, 0);
  pop();

  push();
  translate(740, 115);
  rotate(radians(10));
  textSize(40);
  fill(0);
  text("stupid", 0, 0);
  pop();
}
