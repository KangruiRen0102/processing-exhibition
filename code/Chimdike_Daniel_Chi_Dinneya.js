let nodes = [];
let connections = [];
let timeCounter = 0;
let bgColor;

function setup() {
  createCanvas(800, 800);
  bgColor = color(10, 10, 30);
}

function draw() {
  // Update background based on time (day-night cycle)
  updateBackground();
  background(bgColor);

  // Update and draw nodes
  for (let node of nodes) {
    node.update();
    node.display();
  }

  // Draw connections
  for (let conn of connections) {
    conn.display();
  }

  // Increment time
  timeCounter++;
}

// Mouse interaction - Add new node
function mousePressed() {
  let newNode = new Node(mouseX, mouseY, randomColor());
  nodes.push(newNode);

  // Connect the new node to an existing node randomly
  if (nodes.length > 1) {
    let randomIndex = int(random(nodes.length - 1));
    connections.push(new Connection(newNode, nodes[randomIndex]));
  }
}

// Update background color based on time
function updateBackground() {
  let t = (timeCounter % 600) / 600.0; // Simulate a cycle (e.g., 600 frames per day-night cycle)
  let r = map(sin(TWO_PI * t), -1, 1, 10, 50);
  let g = map(sin(TWO_PI * t + HALF_PI), -1, 1, 20, 60);
  let b = map(cos(TWO_PI * t), -1, 1, 30, 80);
  bgColor = color(r, g, b);
}

// Generate random colors
function randomColor() {
  return color(random(100, 255), random(100, 255), random(100, 255), 200);
}

// Node class
class Node {
  constructor(x, y, c) {
    this.x = x;
    this.y = y;
    this.size = random(5, 15);
    this.c = c;
  }

  update() {
    this.size += 0.05; // Simulate slow growth
  }

  display() {
    noStroke();
    fill(this.c);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

// Connection class
class Connection {
  constructor(nodeA, nodeB) {
    this.nodeA = nodeA;
    this.nodeB = nodeB;
  }

  display() {
    stroke(150, 150, 255, 150);
    strokeWeight(2);
    line(this.nodeA.x, this.nodeA.y, this.nodeB.x, this.nodeB.y);
  }
}
