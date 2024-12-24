// Media Art: "The Sea of Memories"
// Keywords: Sea, Memory, Journey

let waveOffset = 0;  // Offset for wave motion
let journeyX = 0;    // Position of the journeying element
let waveAmplitude = 50; // Height of waves
let waveFrequency = 0.05; // Frequency of waves
let trailOpacity = 50;  // Fading trail effect

function setup() {
  createCanvas(800, 600); // Canvas size to represent the "sea"
  background(20, 30, 60); // Deep ocean blue background
  noStroke(); 
}

function draw() {
  // Create a semi-transparent overlay to fade older frames, simulating memory fading
  fill(20, 30, 60, trailOpacity);
  rect(0, 0, width, height);

  // Draw wave-like motion using sine waves
  fill(70, 120, 200, 150); // Ocean blue with slight transparency
  for (let x = 0; x < width; x += 10) {
    let y = height / 2 + sin(waveFrequency * (x + waveOffset)) * waveAmplitude;
    ellipse(x, y, 15, 15); // Circular wave crest
  }

  // Update wave motion
  waveOffset += 2;

  // Draw the "journey" element (a glowing circle moving across the sea)
  let journeyY = height / 2 + sin(waveFrequency * (journeyX + waveOffset)) * waveAmplitude;
  fill(255, 200, 100, 200); // Glowing golden color
  ellipse(journeyX, journeyY, 30, 30);

  // Update the journey's position
  journeyX += 2;
  if (journeyX > width) {
    journeyX = 0; // Reset position to create a looping effect
  }
}

function keyPressed() {
  // Pause the animation when 'P' is pressed
  if (key === 'P' || key === 'p') {
    noLoop();
  }
  // Resume the animation when 'R' is pressed
  if (key === 'R' || key === 'r') {
    loop();
  }
}
