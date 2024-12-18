// Global variables
ArrayList<Node> nodes;
ArrayList<Connection> connections;
int timeCounter = 0;
color bgColor;

void setup() {
  size(800, 800);
  nodes = new ArrayList<Node>();
  connections = new ArrayList<Connection>();
  bgColor = color(10, 10, 30);
}

void draw() {
  // Update background based on time (day-night cycle)
  updateBackground();
  background(bgColor);
  
  // Update and draw nodes
  for (Node node : nodes) {
    node.update();
    node.display();
  }
  
  // Draw connections
  for (Connection conn : connections) {
    conn.display();
  }
  
  // Increment time
  timeCounter++;
}

// Mouse interaction - Add new node
void mousePressed() {
  Node newNode = new Node(mouseX, mouseY, randomColor());
  nodes.add(newNode);
  
  // Connect the new node to an existing node randomly
  if (nodes.size() > 1) {
    int randomIndex = int(random(nodes.size() - 1));
    connections.add(new Connection(newNode, nodes.get(randomIndex)));
  }
}

// Update background color based on time
void updateBackground() {
  float t = (timeCounter % 600) / 600.0; // Simulate a cycle (e.g., 600 frames per day-night cycle)
  float r = map(sin(TWO_PI * t), -1, 1, 10, 50);
  float g = map(sin(TWO_PI * t + HALF_PI), -1, 1, 20, 60);
  float b = map(cos(TWO_PI * t), -1, 1, 30, 80);
  bgColor = color(r, g, b);
}

// Generate random colors
color randomColor() {
  return color(random(100, 255), random(100, 255), random(100, 255), 200);
}

// Node class
class Node {
  float x, y, size;
  color c;
  
  Node(float x, float y, color c) {
    this.x = x;
    this.y = y;
    this.size = random(5, 15);
    this.c = c;
  }
  
  void update() {
    size += 0.05; // Simulate slow growth
  }
  
  void display() {
    noStroke();
    fill(c);
    ellipse(x, y, size, size);
  }
}

// Connection class
class Connection {
  Node nodeA, nodeB;
  
  Connection(Node nodeA, Node nodeB) {
    this.nodeA = nodeA;
    this.nodeB = nodeB;
  }
  
  void display() {
    stroke(150, 150, 255, 150);
    strokeWeight(2);
    line(nodeA.x, nodeA.y, nodeB.x, nodeB.y);
  }
}
