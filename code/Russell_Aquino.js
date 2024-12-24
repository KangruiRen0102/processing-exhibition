// -----------------------------
// 全局变量
// -----------------------------

// Ball 列表
let balls = [];        

// 计时相关
let startTime;         // 初始毫秒数
let elapsedTime;       // 当前经过的毫秒数
let running = true;    // 计时器是否在运行

// 正弦波相关
let sineOpacity = 255; // 正弦波初始不透明度
let waveOffset = 0;    
let waveFading = false; // 是否开始淡出正弦波

// 红点 & 波开始标识
let ballStarted = false;  // 是否已经开始发球（即红点离开正弦波）
let redDotClicked = false; // 是否点击了红点
let redDotX, redDotY;      // 红点位置

// 秒表动画相关
let stopwatchRadius = 20;   // 计时器小圆的半径
let lineAngle = -HALF_PI;   // 旋转线的起始角度 (指针从顶部开始)
let angleIncrement = TWO_PI / 60; // 假设 60FPS，每秒转 2π
let stopRotating = false;   // 是否停止旋转线

function setup() {
  createCanvas(800, 600);
  // 初始化，记录初始时间
  startTime = millis();

  // 文字属性
  textAlign(RIGHT, TOP);
  textSize(32);

  // 不描边
  noStroke();
}

function draw() {
  // 让背景是纯黑，更好区分正弦波
  background(0);

  // 如果计时器在运行，计算经过时间
  if (running) {
    elapsedTime = millis() - startTime;
  }

  // 把 elapsedTime 拆分成 mm:ss.mmm
  let minutes = int(elapsedTime / 60000);
  let seconds = int((elapsedTime % 60000) / 1000);
  let milliseconds = int(elapsedTime % 1000);

  // 右上角显示计时 (格式 mm:ss.mmm)
  fill(255);
  text(
    nf(minutes, 2) + ":" + nf(seconds, 2) + "." + nf(milliseconds, 3),
    width - 40, 
    10
  );

  // 在计时文字左侧绘制小秒表动画
  drawStopwatchAnimation(minutes, seconds, milliseconds);

  // 如果正弦波还没开始淡出，则正常绘制；否则逐渐减少不透明度
  if (!waveFading) {
    drawSineWave();
  } else {
    sineOpacity -= 2; 
    if (sineOpacity < 0) {
      sineOpacity = 0;
      // 当正弦波完全淡出后，如果还没开始发球，就开始
      if (!ballStarted) {
        startBall();
      }
    }
    drawSineWave();
  }

  // 更新并显示所有球
  for (let i = 0; i < balls.length; i++) {
    balls[i].update();
    balls[i].display();
  }

  // 如果红点还没有被点击，则让它继续在正弦波上运动
  if (!redDotClicked) {
    let amplitude = 100;
    let frequency = 0.02;

    // 红点在画面水平中心
    redDotX = width / 2;
    // 高度随正弦变化
    redDotY = sin(frequency * (redDotX + waveOffset)) * amplitude + height / 2;

    fill(255, 0, 0);
    noStroke();
    ellipse(redDotX, redDotY, 12, 12);
  }
}

// -----------------------------
// 鼠标点击事件
// -----------------------------
function mousePressed() {
  // 如果红点还没被点击过，则执行以下逻辑
  if (!redDotClicked) {
    redDotClicked = true;   // 标记红点被点击
    running = false;        // 停止计时
    waveFading = true;      // 开始淡出正弦波
    stopRotating = true;    // 停止秒表动画的转动

    // 在红点位置创建一个新球
    balls.push(new Ball(redDotX, redDotY));
  }
}

// -----------------------------
// 当正弦波完全淡出后，启动小球
// -----------------------------
function startBall() {
  ballStarted = true;
}

// -----------------------------
// 绘制正弦波背景
// -----------------------------
function drawSineWave() {
  let amplitude = 100;
  let frequency = 0.02;

  // 采用较粗的线条，方便看见波
  stroke(0, 191, 255, sineOpacity);
  strokeWeight(5);

  // 用画线 segment 的方式连成波，而不是 point()
  // 这样更容易看清
  beginShape();
  for (let x = 0; x <= width; x++) {
    let y = sin(frequency * (x + waveOffset)) * amplitude + height / 2;
    vertex(x, y);
  }
  endShape();

  // 让波形向右移动
  waveOffset += 1;
}

// -----------------------------
// 绘制秒表动画 (小圆 + 一条旋转的指针)
// -----------------------------
function drawStopwatchAnimation(minutes, seconds, milliseconds) {
  // 将秒表小圆放在计时文字左边
  let centerX = width - stopwatchRadius * 2 - 140;
  let centerY = 10 + stopwatchRadius;

  // 画外圈 (小圆)
  noFill();
  stroke(255);
  strokeWeight(4);
  ellipse(centerX, centerY, stopwatchRadius * 2, stopwatchRadius * 2);

  // 如果不停止旋转，指针持续旋转 (1秒转一圈)
  if (!stopRotating) {
    lineAngle += angleIncrement; 
  }

  // 指针末端坐标
  let lineX = centerX + cos(lineAngle) * stopwatchRadius;
  let lineY = centerY + sin(lineAngle) * stopwatchRadius;
  line(centerX, centerY, lineX, lineY);
}

// -----------------------------
// Ball 类 (改写为 p5.js 的形式)
// -----------------------------
class Ball {
  constructor(startX, startY) {
    this.x = startX;
    this.y = startY;
    this.radius = 10;

    // x, y 方向的随机速度 [3,6]
    this.dx = random(3, 6);
    this.dy = random(3, 6);

    // 随机颜色
    this.ballColor = color(random(255), random(255), random(255));
  }

  update() {
    // 更新位置
    this.x += this.dx;
    this.y += this.dy;

    // 碰到左右边界
    if (this.x - this.radius <= 0 || this.x + this.radius >= width) {
      this.dx = -this.dx;     // 反向
      this.duplicateBall();   // 复制
      this.increaseSpeed();   // 加速
    }

    // 碰到上下边界
    if (this.y - this.radius <= 0 || this.y + this.radius >= height) {
      this.dy = -this.dy;
      this.duplicateBall();
      this.increaseSpeed();
    }
  }

  display() {
    fill(this.ballColor, 150); // 带一点透明度
    noStroke();
    ellipse(this.x, this.y, this.radius * 2, this.radius * 2);
  }

  // 复制一个新球在屏幕随机位置
  duplicateBall() {
    balls.push(new Ball(random(width), random(height)));
  }

  // 每次碰撞后小幅加速
  increaseSpeed() {
    this.dx *= 1.05;
    this.dy *= 1.05;
  }
}
