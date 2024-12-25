let skibidiballs = []; // 创建数组来存储多个球体对象

class SkibidiBall {
  constructor(x, y, dx, dy, size) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.size = size;
    // 初始颜色为绿色或黄色
    this.colour = random(10) < 5 ? color(0, 255, 0) : color(255, 255, 0);
  }

  update() {
    this.move();
    this.checkWallCollision();
  }

  move() {
    this.y += this.dy;
    this.x += this.dx;
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
    this.colour = color(random(255), random(255), random(255));
  }

  verticalWallCollide() {
    return this.x + (this.size / 2) > width || this.x - (this.size / 2) < 0;
  }

  horizontalWallCollide() {
    return this.y + (this.size / 2) > height || this.y - (this.size / 2) < 0;
  }

  display() {
    fill(this.colour);
    ellipse(this.x, this.y, this.size, this.size);
  }
}

function setup() {
  createCanvas(1080, 720);
  
  // 创建16个球体
  for (let i = 0; i < 16; i++) {
    let dx, dy;
    
    // 确保速度不为0
    do {
      dx = int(random(-5, 5));
      dy = int(random(-5, 5));
    } while (dx === 0 || dy === 0);
    
    // 创建新的球体对象并添加到数组
    skibidiballs[i] = new SkibidiBall(
      int(random(400, 600)),     // x坐标
      int(random(250, 300)),     // y坐标
      dx,                        // x方向速度
      dy,                        // y方向速度
      int(random(10, 50))        // 大小
    );
  }
}

function draw() {
  background(255); // 添加白色背景以清除前一帧
  
  // 更新和显示所有球体
  for (let i = 0; i < skibidiballs.length; i++) {
    skibidiballs[i].display();
    skibidiballs[i].update();
  }
}