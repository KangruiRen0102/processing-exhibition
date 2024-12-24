let traveller;
let allRect = [];
let allCirc = [];
let messageDisplayed = false;

class Rectangle {
  constructor(x, y, w, h, col) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
    this.color = col;
  }

  draw() {
    fill(this.color);
    noStroke();
    rect(this.x, this.y, this.width, this.height);
  }

  move() {
    if (keyIsPressed) {
      if (keyCode === RIGHT_ARROW) {
        this.x += 3;
      } else if (keyCode === LEFT_ARROW) {
        this.x -= 3;
      } else if (keyCode === UP_ARROW) {
        this.y -= 3;
      } else if (keyCode === DOWN_ARROW) {
        this.y += 3;
      }

      // 限制旅行者在桥和墙内
      if (this.x >= 390 && this.x <= 530 && this.y < 100 && this.y > 70) {
        this.y = constrain(this.y, 80, 120 - this.height);
      } else if (this.x < 420) {
        this.x = constrain(this.x, 0, 420 - this.width);
        this.y = constrain(this.y, 0, 400 - this.height);
      } else if (this.x > 520) {
        this.x = constrain(this.x, 531, 600 - this.width);
        this.y = constrain(this.y, 0, 400 - this.height);
      }

      // 旅行者到达特定区域时成长
      if (this.x >= 530 && this.x <= 580 && this.y >= 320 && this.y <= 350) {
        this.width = 40;
        this.height = 40;
      }
      if (this.x >= 400 && this.x <= 420 && this.y >= 70 && this.y <= 100) {
        this.width = 30;
        this.height = 30;
      }
    }
  }
}

class Circle {
  constructor(x, y, r, col) {
    this.x = x;
    this.y = y;
    this.radius = r;
    this.color = col;
  }

  draw() {
    fill(this.color);
    stroke(50, 50, 0);
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
  }
}

function setup() {
  createCanvas(600, 400);
  background(0, 100, 0);

  // 初始化实例
  traveller = new Rectangle(5, 320, 20, 20, color(150, 0, 0));
  allRect = [
    new Rectangle(450, 0, 50, height, color(0, 0, 150)),
    new Rectangle(425, 75, 100, 50, color(150, 75, 0)),
    new Rectangle(420, 70, 110, 10, color(100, 75, 0)),
    new Rectangle(420, 120, 110, 10, color(100, 75, 0)),
    new Rectangle(420, 0, 10, 70, color(150, 150, 150)),
    new Rectangle(520, 0, 10, 70, color(150, 150, 150)),
    new Rectangle(420, 130, 10, height, color(150, 150, 150)),
    new Rectangle(520, 130, 10, height, color(150, 150, 150)),
    new Rectangle(0, 300, 360, 60, color(50, 50, 0)),
    new Rectangle(300, 180, 60, 120, color(50, 50, 0)),
    new Rectangle(30, 180, 330, 60, color(50, 50, 0)),
    new Rectangle(30, 70, 60, 110, color(50, 50, 0)),
    new Rectangle(30, 70, 400, 60, color(50, 50, 0)),
    new Rectangle(520, 70, 40, 60, color(50, 50, 0)),
    new Rectangle(540, 70, 50, 250, color(50, 50, 0)),
    new Rectangle(540, 320, 50, 10, color(0, 0, 0)),
    new Rectangle(540, 330, 50, 10, color(255, 255, 255)),
    new Rectangle(540, 340, 50, 10, color(0, 0, 0)),
  ];

  allCirc = [
    new Circle(565, 30, 25, color(0, 165, 0)),
    new Circle(200, 150, 40, color(0, 160, 0)),
    new Circle(125, 153, 20, color(0, 160, 0)),
    new Circle(350, 50, 35, color(0, 160, 0)),
    new Circle(20, 60, 50, color(0, 160, 0)),
    new Circle(200, 30, 25, color(0, 160, 0)),
    new Circle(395, 300, 45, color(0, 160, 0)),
    new Circle(120, 275, 30, color(0, 160, 0)),
    new Circle(240, 380, 25, color(0, 160, 0)),
    new Circle(390, 160, 20, color(0, 160, 0)),
  ];
}

function draw() {
  background(0, 100, 0);

  // 绘制所有矩形和圆形
  for (let rect of allRect) {
    rect.draw();
  }
  for (let circ of allCirc) {
    circ.draw();
  }

  // 移动旅行者并显示信息
  traveller.move();
  traveller.draw();

  if (
    traveller.x >= 530 &&
    traveller.x <= 580 &&
    traveller.y >= 320 &&
    traveller.y <= 350
  ) {
    if (!messageDisplayed) {
      showMessage("A good journey produces growth.");
      messageDisplayed = true;
    }
  }
}

function showMessage(message) {
  fill(0, 225, 200);
  textSize(36);
  textAlign(CENTER, CENTER);
  text(message, width / 2, height / 2);
}
