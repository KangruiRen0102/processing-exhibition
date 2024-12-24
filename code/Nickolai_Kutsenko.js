let cow;
let n = 1; // 用于控制动画的动态变量
const pi = Math.PI;
const L = pi / 2;

// 初始化画布和“牛”的颜色、尺寸等参数
function setup() {
  createCanvas(3141 / 2, 1000);
  noStroke();
  cow = new Cow(
    50,
    color(0, 0, 0),
    color(255, 255, 255),
    color(102, 51, 0),
    color(7, 8, 50),
    color(25, 30, 70),
    color(255, 103, 153),
    color(100, 100, 100)
  );
}

// 主绘图循环
function draw() {
  background(10);

  // 更新动态变量 n
  n += 2;
  if (n > 100000) {
    n = 1;
  }

  // 更新牛的位置和角度
  cow.update(mouseX, mouseY, 0.1);

  // 显示牛和动态行星系统
  cow.display();
}

// 定义 Cow 类
class Cow {
  constructor(size, black, white, brown, helm1, helm2, nose, grey) {
    this.size = size;
    this.brown = brown;
    this.nose = nose;
    this.grey = grey;
    this.helm1 = helm1;
    this.helm2 = helm2;
    this.black = black;
    this.white = white;
    this.x = 0;
    this.y = 0;
    this.angle = 0;
  }

  // 更新牛的位置和旋转角度
  update(targetX, targetY, easing) {
    let lag = dist(this.x, this.y, targetX - this.size / 2, targetY - this.size / 2);
    this.x += (targetX - this.x - this.size / 2) * easing;
    this.y += (targetY - this.y - this.size / 2) * easing;

    if (targetX !== this.x) {
      this.angle -= lag * 0.05;
    }
  }

  // 显示动态行星系统和牛
  display() {
    // 行星 1
    let x1 = 1000 + 200 * cos(n * 0.005);
    let y1 = 500 + 300 * sin(n * 0.005);
    let s1 = 1 + abs(90 * cos(n * 0.0025));
    fill(0, 70 * cos(n * 0.005), 100 * cos(n * 0.005));
    circle(x1, y1, s1);
    fill(0, 150 * cos(n * 0.005), 100 * cos(n * 0.005));
    circle(x1, y1, 1 + abs(80 * cos(n * 0.0025)));
    fill(0, 255 * cos(n * 0.005), 100 * cos(n * 0.005));
    circle(x1, y1, 1 + abs(60 * cos(n * 0.0025)));

    // 行星 1 的卫星
    let mx1 = x1 - 100 * cos(n * 0.08) * cos(n * 0.0025);
    let my1 = y1 + 150 * cos(n * 0.08) * cos(n * 0.0025);
    let ms1 = 1 + abs(20 * cos(n * 0.0025));
    fill(150 * cos(n * 0.005), 50 * cos(n * 0.005), 50 * cos(n * 0.005));
    circle(mx1, my1, ms1);

    // 太阳
    fill(250, 100 + abs(30 * cos(n * 0.0033)), 0);
    circle(950, 500, 50 + 2 * abs(cos(n * 0.0033)));
    fill(250, 170, 100);
    circle(950, 500, 30 + 5 * abs(cos(n * 0.0033)));
    fill(250, 240, 100);
    circle(950, 500, 5 + 10 * abs(cos(n * 0.0033)));

    // 显示牛
    push();
    translate(this.x + this.size / 2, this.y + this.size / 2);
    rotate(radians(this.angle));

    // 绘制牛身体的各部分
    fill(this.grey);
    ellipse(this.size * 0.5, -this.size * 0.5, this.size * 0.35, this.size * 0.8);
    ellipse(-this.size * 0.55, -this.size * 0.5, this.size * 0.35, this.size * 0.8);
    fill(this.white);
    rectMode(CENTER);
    rect(0, 0, this.size * 0.9, this.size * 0.8);
    fill(this.brown);
    ellipse(this.size * 1.2, this.size * 0.65, this.size * 0.1, this.size * 0.3);
    ellipse(this.size * 0.85, this.size * 0.65, this.size * 0.1, this.size * 0.3);
    pop();
  }
}
