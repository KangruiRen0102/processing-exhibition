let skibidiballs = []; // 创建一个数组来存储 SkibidiBall 对象

function setup() {
  createCanvas(1080, 720);

  for (let i = 0; i < 16; i++) { // 创建 16 个小球
    let dx, dy;

    do {
      dx = int(random(-5, 5));
      dy = int(random(-5, 5));
    } while (dx === 0 || dy === 0); // 确保速度不会为 0

    skibidiballs.push(new SkibidiBall(int(random(400, 600)), int(random(250, 300)), dx, dy, int(random(10, 50))));
  }
}

function draw() {
  background(255);

  for (let i = 0; i < skibidiballs.length; i++) {
    skibidiballs[i].display();
    skibidiballs[i].update();
  }
}

class SkibidiBall {
  constructor(x, y, dx, dy, size) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.size = size;
    this.colour = random(10) < 5 ? color(0, 255, 0) : color(255, 255, 0); // 初始颜色：绿色或黄色
  }

  update() {
    this.move();
    this.checkWallCollision();
  }

  move() {
    this.x += this.dx;
    this.y += this.dy;
  }

  checkWallCollision() {
    if (this.horizontalWallCollide()) {
      this.dy *= -1;
      this.colorChange();
    }
    if (this.verticalWallCollide()) {
      this.dx *= -1;
      this.colorChange();
    }
  }

  colorChange() {
    this.colour = color(random(255), random(255), random(255)); // 碰撞时随机改变颜色
  }

  horizontalWallCollide() {
    return this.y + this.size / 2 > height || this.y - this.size / 2 < 0;
  }

  verticalWallCollide() {
    return this.x + this.size / 2 > width || this.x - this.size / 2 < 0;
  }

  display() {
    fill(this.colour);
    ellipse(this.x, this.y, this.size, this.size);
  }
}
