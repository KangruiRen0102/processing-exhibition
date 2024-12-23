let particles = []; // 粒子列表
let time = 0; // 用于背景和动画的时间变量

function setup() {
  createCanvas(800, 800);
  smooth();
  particles.push(new Particle(width / 2, height / 2)); // 从一个粒子开始
}

function draw() {
  // 时间驱动背景从白天到夜晚的渐变
  let bgR = map(sin(time), -1, 1, 20, 100);
  let bgG = map(sin(time), -1, 1, 30, 120);
  let bgB = map(cos(time), -1, 1, 60, 150);
  background(bgR, bgG, bgB);

  // 增加时间以平滑动画
  time += 0.03;

  // 更新并显示所有粒子
  for (let i = particles.length - 1; i >= 0; i--) {
    let p = particles[i];
    p.update();
    p.display();

    // 如果粒子太大或离开屏幕，则移除
    if (p.isOffScreen() || p.size > 200) {
      particles.splice(i, 1);
    }
  }
}

// 鼠标点击时添加新粒子
function mousePressed() {
  particles.push(new Particle(mouseX, mouseY));
}

// 粒子类
class Particle {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.size = random(5, 15); // 初始尺寸
    this.growthRate = random(0.3, 0.7); // 随机增长率
    this.speedX = random(-2, 2); // 随机水平速度
    this.speedY = random(-2, 2); // 随机垂直速度
    this.particleColor = color(
      random(100, 255),
      random(100, 255),
      random(100, 255)
    ); // 随机颜色
  }

  // 更新粒子的位置和大小
  update() {
    this.x += this.speedX;
    this.y += this.speedY;
    this.size += this.growthRate; // 随时间增长
  }

  // 显示粒子
  display() {
    noStroke();
    fill(this.particleColor, 200 - this.size); // 随增长渐隐
    ellipse(this.x, this.y, this.size, this.size);
  }

  // 检查粒子是否离开屏幕
  isOffScreen() {
    return (
      this.x < -50 || this.x > width + 50 || this.y < -50 || this.y > height + 50
    );
  }
}
