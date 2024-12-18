let stems = []; // List to hold all stems
let activeStems = []; // List to hold stems eligible for branching
const maxStems = 12000; // Maximum number of stems
let globalRotation = 0; // Global rotation angle
const rotationSpeed = 0.0005; // Speed of the global rotation
const baseSize = 150; // Initial size for the first square
let bgColor;
let firstClick = true; // Flag to check if it's the first click

class Stem {
  constructor(x, y, gen, angle, parentColor) {
    this.xPos = x;
    this.yPos = y;
    this.gen = gen;
    this.size = baseSize / Math.pow(1.7, gen); // Size decreases with generation
    this.angle = angle; // Fixed branching angle
    this.rotation = random(-PI, PI); // Random rotation for each square

    // Slightly modify the parent color to create a new color
    const offset = 15;
    const r = red(parentColor) + random(-offset, offset);
    const g = green(parentColor) + random(-offset, offset);
    const b = blue(parentColor) + random(-offset, offset);
    this.stemColor = color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
  }

  render() {
    push();
    translate(this.xPos, this.yPos); // Move to the stem's position
    rotate(this.rotation); // Apply individual rotation
    fill(this.stemColor);
    rect(0, 0, this.size, this.size); // Render as a square
    pop();
  }

  branch() {
    let newStems = [];
    const numBranches = int(random(0, 4)); // Spawn between 0 and 3 new stems
    const offset = this.size * 1.3; // Distance to next square's position

    for (let i = 0; i < numBranches; i++) {
      const outwardAngle = atan2(this.yPos - height / 2, this.xPos - width / 2); // Angle pointing outward from center
      const newAngle = outwardAngle + random(-PI / 3, PI / 3); // Add variation to the angle
      const newX = this.xPos + cos(newAngle) * offset;
      const newY = this.yPos + sin(newAngle) * offset;
      newStems.push(new Stem(newX, newY, this.gen + 1, newAngle, this.stemColor));
    }

    if (newStems.length === 0) {
      newStems.push(this); // Keep the current stem active if no branches are created
    }

    return newStems;
  }
}

function setup() {
  createCanvas(1000, 1000);
  noStroke();
  rectMode(CENTER);
  bgColor = generateRandomPastelColor();

  // Start with a single initial stem at the center
  const initialStem = new Stem(width / 2, height / 2, 0, 0, bgColor);
  stems.push(initialStem);
  activeStems.push(initialStem);
}

function draw() {
  background(darkenColor(bgColor));

  // Apply global rotation
  push();
  translate(width / 2, height / 2);
  rotate(globalRotation);
  translate(-width / 2, -height / 2);

  // Render all stems
  stems.forEach(stem => stem.render());

  pop();

  // Increment global rotation
  globalRotation += rotationSpeed;
}

function mousePressed() {
  if (firstClick) {
    // On first click, generate between 4 and 13 evenly spaced branches
    const numBranches = int(random(4, 14));
    const angleIncrement = TWO_PI / numBranches;
    const newStems = [];

    for (let i = 0; i < numBranches; i++) {
      const angle = angleIncrement * i;
      const newX = width / 2 + cos(angle) * baseSize;
      const newY = height / 2 + sin(angle) * baseSize;
      newStems.push(new Stem(newX, newY, 1, angle, stems[0].stemColor));
    }

    stems.push(...newStems);
    activeStems = newStems;
    firstClick = false;
  } else {
    if (stems.length < maxStems) {
      const newStems = [];
      activeStems.forEach(stem => newStems.push(...stem.branch()));
      stems.push(...newStems);
      activeStems = newStems;
    }
  }
}

function keyPressed() {
  if (key === 'r' || key === 'R') {
    stems = [];
    activeStems = [];
    bgColor = generateRandomPastelColor();
    const initialStem = new Stem(width / 2, height / 2, 0, 0, bgColor);
    stems.push(initialStem);
    activeStems.push(initialStem);
    firstClick = true;
    globalRotation = 0;
  }
}

function generateRandomPastelColor() {
  const r = random(128, 255);
  const g = random(128, 255);
  const b = random(128, 255);
  return color(r, g, b);
}

function darkenColor(squareColor) {
  const offset = 50;
  const r = red(squareColor) - offset;
  const g = green(squareColor) - offset;
  const b = blue(squareColor) - offset;
  return color(constrain(r, 0, 255), constrain(g, 0, 255), constrain(b, 0, 255));
}
