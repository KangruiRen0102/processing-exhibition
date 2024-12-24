// ----------------------------------------------------
// 全局变量
// ----------------------------------------------------
let numStars = 500;
let stars = [];       // 存放 Star 对象
let t = 0;
let stopFrame = 200;

// 三种 Circle（粒子）数组
let circles = [];
let circles2 = [];
let circles3 = [];

// 波浪数组
let waves = [];

// ----------------------------------------------------
// Wave 类
// ----------------------------------------------------
class Wave {
  constructor(amplitude, wavelength, speed, waveColor, yOffset) {
    this.amplitude = amplitude;
    this.wavelength = wavelength;
    this.speed = speed;
    this.phase = 0;
    this.waveColor = waveColor; // 直接存储由 color(...) 创建出来的颜色
    this.yOffset = yOffset;
  }

  update() {
    this.phase += this.speed;
  }

  computeY(x) {
    // 计算当前 x 的波浪位移
    return this.amplitude * sin((TWO_PI * x) / this.wavelength + this.phase);
  }

  display() {
    noStroke();
    fill(this.waveColor); 
    for (let x = 0; x < width; x += 2) {
      let y = this.yOffset + this.computeY(x);
      ellipse(x, y, 16, 16);
    }
  }
}

// ----------------------------------------------------
// setup()，初始化
// ----------------------------------------------------
function setup() {
  createCanvas(1000, 1000);

  // 初始化 Star 数组
  for (let i = 0; i < numStars; i++) {
    stars[i] = new Star();
  }

  // 初始化 waves
  // 注意：p5.js 中不再用 ArrayList，而是直接用普通数组 waves = []
  for (let i = 1; i < 7; i++) {
    waves.push(new Wave(10, 130, 0.05, color(0,74,130), 500 + i * 75));
    waves.push(new Wave(15, 110, 0.03, color(0,102,179), 505 + i * 75));
    waves.push(new Wave(10, 90, 0.05, color(0,130,228), 515 + i * 75));
    waves.push(new Wave(25, 130, 0.02, color(22,155,255), 530 + i * 75));
    waves.push(new Wave(20, 110, 0.03, color(71,176,255), 535 + i * 75));
    waves.push(new Wave(15, 90, 0.05, color(120,197,255), 545 + i * 75));
    waves.push(new Wave(15, 130, 0.02, color(169,218,255), 550 + i * 75));
    waves.push(new Wave(10, 110, 0.03, color(218,239,254), 560 + i * 75));
  }

  background(0);
}

// ----------------------------------------------------
// draw()，每帧循环
// ----------------------------------------------------
function draw() {
  // 注意：266 超过正常的 0~255 灰度，但在 p5.js 中不会报错，会当成白色。
  // 如果想要普通白色，可以改为 background(255);
  background(266);

  // 以画布中心为原点
  translate(width / 2, height / 2);

  // 控制 circles / circles2 / circles3 的出现频率
  if (t % 1 === 0 && t < stopFrame) {
    circles.push(new Circle(0));
    circles2.push(new Circle2(-width / 2));
    circles3.push(new Circle3(-width / 4));
  }

  // 绘制 Circles3
  for (let circle3 of circles3) {
    circle3.move();
    circle3.display();
  }

  // 绘制 Circles
  for (let circle of circles) {
    circle.move();
    circle.display();
  }

  // 绘制 Circles2
  for (let circle2 of circles2) {
    circle2.move();
    circle2.display();
  }

  // 时间自增
  t += 1;

  // 把坐标系移回来，便于后面绘制星星和矩形
  translate(-width / 2, -height / 2);

  // 绘制星星
  for (let s of stars) {
    s.display();
  }

  // 绘制下方的矩形
  fill(0,46,81);
  rect(0, 650, 1000, 500);

  // 绘制波浪
  for (let wave of waves) {
    wave.update();
    wave.display();
  }
}

// ----------------------------------------------------
// Star 类
// ----------------------------------------------------
class Star {
  constructor() {
    this.x = random(width);
    this.y = random(height);
    this.brightness = random(100, 255);
    this.size = random(1, 3);
  }
  
  display() {
    // 计算与鼠标的距离
    let d = dist(mouseX, mouseY, this.x, this.y);

    // 如果鼠标距离星星 < 50，则加粗星星
    if (d < 50) {
      stroke(this.brightness);
      strokeWeight(this.size * 2);
    } else {
      stroke(150);
      strokeWeight(this.size);
    }
    point(this.x, this.y);
  }
}

// ----------------------------------------------------
// Circle 系列类
// ----------------------------------------------------
class Circle {
  constructor(startX) {
    this.d = startX;
    this.f = getYPosition1(this.d);
    this.speed = 2;
  }

  move() {
    this.d += this.speed;
    this.f = getYPosition1(this.d);
  }

  display() {
    noStroke();
    fill(179, 253, 0, 230);
    ellipse(this.d, this.f, 10, 10);
    fill(97, 204, 0, 210);
    ellipse(this.d, this.f - 8, 10, 10);
    fill(97, 204, 0, 190);
    ellipse(this.d, this.f - 16, 10, 10);
    fill(97, 204, 0, 170);
    ellipse(this.d, this.f - 24, 10, 10);
    fill(59, 178, 10, 150);
    ellipse(this.d, this.f - 32, 10, 10);
    fill(59, 178, 10, 130);
    ellipse(this.d, this.f - 40, 10, 10);
    fill(59, 178, 10, 110);
    ellipse(this.d, this.f - 48, 10, 10);
    fill(59, 178, 10, 90);
    ellipse(this.d, this.f - 56, 10, 10);
    fill(0, 154, 0, 70);
    ellipse(this.d, this.f - 64, 10, 10);
    fill(0, 154, 0, 50);
    ellipse(this.d, this.f - 72, 10, 10);
  }
}

class Circle2 {
  constructor(startX) {
    this.d = startX;
    this.f = getYPosition2(this.d);
    this.speed = 2;
  }

  move() {
    this.d += this.speed;
    this.f = getYPosition2(this.d);
  }

  display() {
    noStroke();
    fill(0, 223, 150, 230);
    ellipse(this.d, this.f, 10, 10);
    fill(0, 198, 144, 210);
    ellipse(this.d, this.f - 8, 10, 10);
    fill(0, 198, 144, 190);
    ellipse(this.d, this.f - 16, 10, 10);
    fill(0, 207, 82, 170);
    ellipse(this.d, this.f - 24, 10, 10);
    fill(0, 207, 82, 150);
    ellipse(this.d, this.f - 32, 10, 10);
    fill(0, 207, 82, 130);
    ellipse(this.d, this.f - 40, 10, 10);
    fill(25, 100, 106, 110);
    ellipse(this.d, this.f - 48, 10, 10);
    fill(25, 100, 106, 90);
    ellipse(this.d, this.f - 56, 10, 10);
    fill(25, 100, 106, 70);
    ellipse(this.d, this.f - 64, 10, 10);
    fill(3, 46, 62, 50);
    ellipse(this.d, this.f - 72, 10, 10);
  }
}

class Circle3 {
  constructor(startX) {
    this.d = startX;
    this.f = getYPosition3(this.d);
    this.speed = 2;
  }

  move() {
    this.d += this.speed;
    this.f = getYPosition3(this.d);
  }

  display() {
    noStroke();
    fill(14, 243, 197, 230);
    ellipse(this.d, this.f, 10, 10);
    fill(4, 226, 183, 210);
    ellipse(this.d, this.f - 8, 10, 10);
    fill(4, 226, 183, 190);
    ellipse(this.d, this.f - 16, 10, 10);
    fill(3, 130, 152, 170);
    ellipse(this.d, this.f - 24, 10, 10);
    fill(3, 130, 152, 150);
    ellipse(this.d, this.f - 32, 10, 10);
    fill(3, 130, 152, 130);
    ellipse(this.d, this.f - 40, 10, 10);
    fill(1, 82, 104, 110);
    ellipse(this.d, this.f - 48, 10, 10);
    fill(1, 82, 104, 90);
    ellipse(this.d, this.f - 56, 10, 10);
    fill(3, 46, 62, 70);
    ellipse(this.d, this.f - 64, 10, 10);
    fill(3, 46, 62, 50);
    ellipse(this.d, this.f - 72, 10, 10);
  }
}

// ----------------------------------------------------
// 函数：计算 y 坐标的形状
// ----------------------------------------------------
function getYPosition1(d) {
  // 注意：1.0 / 70 相当于除以70
  return (
    230 * sin((1.0 / 70) * d) -
    6.5 * sin((1.0 / 840) * 8 * d) +
    cos((1.0 / 500) * 2 * d) +
    196 * cos((1.0 / 250) * 5 * d) -
    200
  );
}

function getYPosition2(d) {
  return 345 * sin((1.0 / 234) * d) + 23 * cos((1.0 / 34) * d) - 110;
}

function getYPosition3(d) {
  return 345 * sin((1.0 / 2474) * d - 23) + 23 * cos((1.0 / 86) * d) - 510;
}
