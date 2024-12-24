let skyStart, skyEnd, seaStart, seaEnd, sandStart, sandEnd;
let waveOffset = 0, noiseOffset = 0;

function setup() {
  createCanvas(800, 600);
  smooth();
  frameRate(30);

  // Define colors
  skyStart = color(50, 50, 200);
  skyEnd = color(255, 140, 0);
  seaStart = color(30, 60, 150);
  seaEnd = color(10, 30, 80);
  sandStart = color(255, 230, 140);
  sandEnd = color(194, 151, 84);
}

function draw() {
  background(0);

  // Sky Gradient
  for (let i = 0; i < height / 2 + 50; i++) {
    stroke(lerpColor(skyStart, skyEnd, map(i, 0, height / 2 + 50, 0, 1)));
    line(0, i, width, i);
  }

  // Ocean Gradient
  for (let i = height / 2 + 50; i < height / 2 + 150; i++) {
    stroke(lerpColor(seaStart, seaEnd, map(i, height / 2 + 50, height / 2 + 150, 0, 1)));
    line(0, i, width, i);
  }

  // Wave
  stroke(255, 255, 255, 150);
  let y = height / 2 + 140;
  beginShape();
  for (let x = 0; x < width; x++) {
    if (int(x / 100) % 2 === 0) {
      vertex(x, y + noise(x * 0.03, y * 0.02, noiseOffset) * 10);
    }
  }
  endShape();

  // Foam
  stroke(255, 255, 255, 200);
  for (let yFoam = height / 2 + 130; yFoam < height / 2 + 150; yFoam += 10) {
    beginShape();
    for (let x = 0; x < width; x++) {
      let offset = noise(x * 0.05, yFoam * 0.02, noiseOffset) * 15;
      if (offset > 8) vertex(x, yFoam + offset);
    }
    endShape();
  }

  // Sand Gradient
  for (let i = height / 2 + 150; i < height; i++) {
    stroke(lerpColor(sandStart, sandEnd, map(i, height / 2 + 150, height, 0, 1)));
    line(0, i, width, i);
  }

  // Move Waves
  waveOffset += 0.02;
  noiseOffset += 0.01;
}
