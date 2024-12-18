function setup() {
  createCanvas(800, 600); // Canvas size
  frameRate(100); // Frame rate
  noStroke();
}

function draw() {
  background(0); // Black background to represent the night sky
  
  // Aurora Effect: Flowing lights in the sky
  for (let i = 0; i < width; i += 20) {
    let waveOffset = sin((frameCount + i) * 0.02) * 50; // Wave effect for motion
    let c = lerpColor(
      color(30, 180, 255, 120), 
      color(180, 50, 255, 120), 
      noise(i * 0.01, frameCount * 0.01)
    );
    fill(c);
    ellipse(i, height / 2 + waveOffset, 100, 300); // Vertical aurora shapes
  }
  
  // Growing Plant: Represents growth over time
  let plantHeight = map(sin(frameCount * 0.02), -1, 1, 50, 200); // Dynamic height
  fill(50, 200, 50); // Green color for the plant stalk
  rect(width / 2 - 10, height - 50 - plantHeight, 20, plantHeight); // Plant stalk
  
  // Plant Leaves
  fill(80, 220, 80); // Color of the leaves
  ellipse(width / 2 - 30, height - 68 - plantHeight + 10, 50, 30); // Left leaf
  ellipse(width / 2 + 30, height - 68 - plantHeight + 10, 50, 30); // Right leaf
  
  // Glow Effect Around Plant and the Aurora
  noFill();
  stroke(0, 255, 0, 100); // Glow color
  strokeWeight(5); // Thickness of the glow
  // Glow can be extended with additional visual effects if needed
}
