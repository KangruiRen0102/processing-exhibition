let numWaves = 10;
let offsets = [];
let time = 0;
let hoverTimes = []; // Track when each wave is being hovered over by the mouse
let brightDuration = 0.3; // Duration for the wave to brighten
let waveActive = []; // Track whether the mouse is hovering over the wave

function setup() {
  createCanvas(800, 600);
  colorMode(HSB, 360, 100, 100); // Use HSB for colors

  // Initialize offsets, hover states, and hover times for waves
  for (let i = 0; i < numWaves; i++) {
    offsets.push(random(1000));
    hoverTimes.push(-brightDuration);
    waveActive.push(false);
  }
}

function draw() {
  background(10, 20, 20); // Dark background for night sky

  // Draw flowing waves
  for (let i = 0; i < numWaves; i++) {
    drawWave(i);
  }

  // Smooth animation
  time += 0.02;
}

function drawWave(waveIndex) {
  noFill();

  let waveY = map(waveIndex, 0, numWaves - 1, height, 0); // Vertical position
  let hue = (waveIndex * 30 + frameCount * 0.5) % 360; // Gradual hue shift
  let mouseProximity = abs(mouseY - waveY); // Distance from the mouse to the wave

  // Check if the mouse is hovering over the wave
  if (mouseProximity < 30) { // Adjust hover range as needed
    if (!waveActive[waveIndex]) {
      hoverTimes[waveIndex] = time; // Record the time the wave is first hovered over
      waveActive[waveIndex] = true;
    }
  } else {
    if (waveActive[waveIndex]) {
      hoverTimes[waveIndex] = time; // Record the time when the wave stops being hovered
      waveActive[waveIndex] = false;
    }
  }

  // Calculate brightness transition based on hover duration
  let activeTime = time - hoverTimes[waveIndex];
  let brightTransition = map(activeTime, 0, brightDuration, 0, 1);

  // Transition to a brighter color when hovering
  let waveColor;
  if (waveActive[waveIndex]) {
    waveColor = lerpColor(color(hue, 80, 80), color(hue, 100, 100), brightTransition);
  } else {
    waveColor = color(hue, 80, 80); // Default aurora color
  }

  // Draw the wave
  stroke(waveColor);
  strokeWeight(waveActive[waveIndex] ? 4 : 2); // Thicker stroke when glowing

  beginShape();
  for (let x = 0; x <= width; x += 10) {
    let noiseFactor = noise(x * 0.01, offsets[waveIndex], time);
    let y = waveY + sin(x * 0.02 + offsets[waveIndex] + time) * 50 * noiseFactor;
    vertex(x, y);
  }
  endShape();

  // Update offset for wave movement
  offsets[waveIndex] += waveActive[waveIndex] ? 0.05 : 0.005; // Faster when hovering
}
