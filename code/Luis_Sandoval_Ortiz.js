// Dot storage
let dots = [];
let disruptor;
let formingCircle = false;
let disrupted = false;
let snakeMode = false;
let formingInfinity = false;
let draggingDisruptor = false;
let ruptureComplete = false;
let changedToPurple = false;
let changedToGreen = false;
let changedToYellow = false;
let t = 0;

function setup() {
  createCanvas(800, 600);
  background(0);
  initializeDots(50);
}

function draw() {
  background(0);

  for (let i = 0; i < dots.length; i++) {
    let dot = dots[i];

    if (!formingCircle && !disrupted && !formingInfinity) {
      dot.moveToLineToCircle();
    } else if (formingCircle && !disrupted) {
      dot.moveInCircle();
    } else if (disrupted && !ruptureComplete) {
      if (!changedToPurple) {
        changeDotsColor(color(75, 0, 130));
        changedToPurple = true;
      }
      dot.fallToFloor();
    } else if (ruptureComplete && !snakeMode) {
      dot.restOnFloor();
    } else if (snakeMode && !formingInfinity) {
      if (!changedToGreen) {
        changeDotsColor(color(57, 255, 20));
        changedToGreen = true;
      }
      dot.followMouse(i);
    } else if (formingInfinity) {
      if (!changedToYellow) {
        changeDotsColor(color(255, 255, 0));
        changedToYellow = true;
      }
      dot.moveToInfinity(t);
    }

    dot.display();
  }

  if (formingInfinity) {
    t += 0.02;
  }

  if (disruptor) {
    disruptor.display();

    if (draggingDisruptor) {
      for (let dot of dots) {
        if (dist(disruptor.x, disruptor.y, dot.x, dot.y) < disruptor.size / 2) {
          disrupted = true;
          break;
        }
      }
    }
  }
}

function mousePressed() {
  if (!disruptor) {
    disruptor = new Dot(mouseX, mouseY, color(255, 0, 0), 20);
  } else if (dist(mouseX, mouseY, disruptor.x, disruptor.y) < disruptor.size) {
    draggingDisruptor = true;
  } else if (ruptureComplete && !snakeMode) {
    snakeMode = true;
  } else if (snakeMode && !formingInfinity) {
    formingInfinity = true;
  }
}

function mouseDragged() {
  if (draggingDisruptor && disruptor) {
    disruptor.x = mouseX;
    disruptor.y = mouseY;
  }
}

function mouseReleased() {
  draggingDisruptor = false;
}

function initializeDots(count) {
  for (let i = 0; i < count; i++) {
    let x = width / count * i + 50;
    let y = height / 2;
    dots.push(new Dot(x, y, color(255, 255, 0), 15));
  }
}

function changeDotsColor(newColor) {
  for (let dot of dots) {
    dot.setColor(newColor);
  }
}

class Dot {
  constructor(x, y, col, size) {
    this.x = x;
    this.y = y;
    this.targetX = x;
    this.targetY = y;
    this.velocityX = random(-2, 2);
    this.velocityY = random(1, 3);
    this.col = col;
    this.size = size;
    this.radius = 200;
    this.fallen = false;
    this.angle = 0;
  }

  moveToLineToCircle() {
    let progress = (dots.indexOf(this) + 1) / dots.length;
    let angle = progress * TWO_PI - HALF_PI;
    this.targetX = width / 2 + cos(angle) * this.radius;
    this.targetY = height / 2 + sin(angle) * this.radius;

    this.x = lerp(this.x, this.targetX, 0.05);
    this.y = lerp(this.y, this.targetY, 0.05);

    if (dist(this.x, this.y, this.targetX, this.targetY) < 2) {
      formingCircle = true;
    }
  }

  moveInCircle() {
    this.angle += 0.02;
    this.x = width / 2 + cos(this.angle + (dots.indexOf(this) * TWO_PI / dots.length)) * this.radius;
    this.y = height / 2 + sin(this.angle + (dots.indexOf(this) * TWO_PI / dots.length)) * this.radius;
  }

  fallToFloor() {
    if (!this.fallen) {
      this.x += this.velocityX;
      this.y += this.velocityY;
      this.velocityY += 0.2;

      if (this.y >= height - 10) {
        this.y = height - 10;
        this.velocityY = 0;
        this.fallen = true;
      }
    }

    if (dots.every(dot => dot.fallen)) {
      ruptureComplete = true;
    }
  }

  restOnFloor() {
    // Dots remain stationary on the floor after falling
  }

  followMouse(index) {
    if (index === 0) {
      this.targetX = mouseX;
      this.targetY = mouseY;
    } else {
      let previous = dots[index - 1];
      this.targetX = previous.x;
      this.targetY = previous.y;
    }

    this.x = lerp(this.x, this.targetX, 0.1);
    this.y = lerp(this.y, this.targetY, 0.1);
  }

  moveToInfinity(t) {
    let offset = dots.indexOf(this) * 0.2;
    if (dots.indexOf(this) % 2 === 0) {
      this.targetX = width / 2 + cos(t + offset) * 150;
      this.targetY = height / 2 + sin(2 * (t + offset)) * 100;
    } else {
      this.targetX = width / 2 + cos(t + offset + PI) * 150;
      this.targetY = height / 2 + sin(2 * (t + offset + PI)) * 100;
    }

    this.x = lerp(this.x, this.targetX, 0.05);
    this.y = lerp(this.y, this.targetY, 0.05);
  }

  setColor(newColor) {
    this.col = newColor;
  }

  display() {
    fill(this.col);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }
}
