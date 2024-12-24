let pucks = []; // 用于存储冰球的数组
let confettis = []; // 用于庆祝动画的彩纸数组
let defenders = []; // 守门员列表
let players = []; // 埃德蒙顿油人队球员
let goal; // 球门
let showTrophy = false; // 是否显示奖杯
const maxPucks = 7; // 最大冰球数量

function setup() {
  createCanvas(800, 600);
  goal = new Goal(width / 2, 50);

  // 添加油人队球员
  players.push(new Player(width / 4, height - 50, "97", "McDavid"));
  players.push(new Player(width / 2, height - 50, "29", "Draisaitl"));
  players.push(new Player((3 * width) / 4, height - 50, "18", "Hyman"));

  // 添加守门员
  for (let i = 0; i < 2; i++) {
    defenders.push(new Defender(random(width / 4, (3 * width) / 4), random(height / 4, height / 2)));
  }
}

function draw() {
  drawRink(); // 绘制冰球场
  goal.display(); // 显示球门

  // 显示并移动守门员
  for (let defender of defenders) {
    defender.display();
    defender.move();
  }

  // 显示球员
  for (let player of players) {
    player.display();
  }

  // 更新并显示冰球
  for (let i = pucks.length - 1; i >= 0; i--) {
    let puck = pucks[i];
    puck.display();
    puck.move();

    // 检查冰球是否与守门员碰撞
    for (let defender of defenders) {
      if (defender.isBlocking(puck)) {
        puck.deflect();
      }
    }

    // 检查冰球是否进球
    if (goal.isReached(puck)) {
      pucks.splice(i, 1);
      showTrophy = true;
      for (let j = 0; j < 100; j++) {
        confettis.push(new Confetti(goal.x, goal.y));
      }
    }
  }

  // 显示并更新彩纸
  for (let i = confettis.length - 1; i >= 0; i--) {
    let c = confettis[i];
    c.display();
    c.update();
    if (c.isOffScreen()) {
      confettis.splice(i, 1);
    }
  }

  // 显示奖杯动画
  if (showTrophy) {
    drawTrophy(width / 2, height / 2);
    if (frameCount % 120 === 0) {
      showTrophy = false;
    }
  }

  // 显示底部标语
  fill(255);
  textSize(16);
  textAlign(CENTER);
  text("Hometown Pride", width / 2, height - 10);
}

function mousePressed() {
  // 点击球员发射冰球
  for (let player of players) {
    if (player.isClicked(mouseX, mouseY)) {
      if (pucks.length < maxPucks) {
        pucks.push(new Puck(player.x, player.y - 20));
      }
      break;
    }
  }
}

function drawRink() {
  background(200, 200, 255);
  stroke(255, 0, 0);
  strokeWeight(4);
  line(width / 2, 0, width / 2, height);
  stroke(0, 0, 255);
  ellipse(width / 2, height / 2, 150, 150);

  fill(255, 140, 0);
  ellipse(width / 2, height / 2, 100, 100);
  fill(255);
  ellipse(width / 2, height / 2, 80, 80);
  fill(0, 50, 255);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("OILERS", width / 2, height / 2);
}

class Puck {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-4, 4);
    this.speedY = random(-2, -6);
    this.col = random(1) < 0.5 ? color(0, 50, 255) : color(255, 100, 0);
  }

  display() {
    fill(this.col);
    noStroke();
    ellipse(this.x, this.y, 20, 20);
  }

  move() {
    this.x += this.speedX;
    this.y += this.speedY;
    if (this.x < 0 || this.x > width) this.speedX *= -1;
    if (this.y < 0 || this.y > height) this.speedY *= -1;
  }

  deflect() {
    this.speedX *= -1;
    this.speedY *= -1;
  }
}

class Goal {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.size = 100;
  }

  display() {
    stroke(255, 0, 0);
    strokeWeight(5);
    fill(255, 255, 255, 50);
    rectMode(CENTER);
    rect(this.x, this.y, this.size, 40);
  }

  isReached(puck) {
    return dist(puck.x, puck.y, this.x, this.y) < this.size / 2;
  }
}

class Confetti {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-2, 2);
    this.speedY = random(1, 3);
    this.col = color(random(255), random(255), random(255));
  }

  display() {
    fill(this.col);
    noStroke();
    ellipse(this.x, this.y, 5, 5);
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;
  }

  isOffScreen() {
    return this.y > height;
  }
}

class Defender {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.speedX = random(-2, 2);
  }

  display() {
    push();
    translate(this.x, this.y);
    fill(0);
    rectMode(CENTER);
    rect(0, 10, 20, 40);
    fill(255);
    ellipse(0, -10, 20, 20);
    stroke(150);
    strokeWeight(3);
    line(-10, 30, 10, 50);
    pop();
  }

  move() {
    this.x += this.speedX;
    if (this.x < width / 4 || this.x > (3 * width) / 4) this.speedX *= -1;
  }

  isBlocking(puck) {
    return dist(this.x, this.y, puck.x, puck.y) < 25;
  }
}

class Player {
  constructor(x, y, number, name) {
    this.x = x;
    this.y = y;
    this.number = number;
    this.name = name;
  }

  display() {
    push();
    translate(this.x, this.y);
    fill(0, 50, 255);
    rectMode(CENTER);
    rect(0, 10, 20, 40);
    fill(255);
    ellipse(0, -10, 20, 20);
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(12);
    text(this.number, 0, 10);
    textSize(10);
    text(this.name, 0, 25);
    pop();
  }

  isClicked(mx, my) {
    return dist(mx, my, this.x, this.y) < 20;
  }
}

function drawTrophy(x, y) {
  fill(255, 223, 0);
  stroke(0);
  strokeWeight(3);
  ellipse(x, y - 20, 80, 80);
  rect(x - 30, y + 10, 60, 20);
}
