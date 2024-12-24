// -----------------------------
// p5.js 版：暗影中的时钟 (Time, Shadow, Twilight)
// -----------------------------

// 画布及时钟变量
let centerX, centerY;  // 时钟中心点
let clockRadius;       // 时钟半径

function setup() {
  createCanvas(1000, 1000);  // 对应 Processing 中的 size(1000, 1000)

  centerX = width / 2;
  centerY = height / 2;
  clockRadius = Math.min(width, height) / 2 - 50; // 设置半径并留白
}

function draw() {
  background(10, 10, 30); // 深色背景，模拟暗影

  // 1. 绘制表盘
  fill(35, 35, 75); // 暗色表盘
  noStroke();
  ellipse(centerX, centerY, clockRadius * 1.5, clockRadius * 1.5);

  // 2. 绘制 12 个整点刻度
  for (let i = 0; i < 12; i++) {
    let angle = map(i, 0, 12, 0, TWO_PI) - HALF_PI;
    let x = centerX + cos(angle) * clockRadius * 0.6;
    let y = centerY + sin(angle) * clockRadius * 0.6;
    fill(200, 200, 100);
    ellipse(x, y, 12, 12); // 表示每个整点的小圆点
  }

  // 3. 获取当前时间（p5.js 提供的时间函数与 Processing 相同）
  let h = hour() % 12;
  let m = minute();
  let s = second();

  // 4. 计算三根指针的角度
  let hourAngle   = map(h + m / 60.0, 0, 12, 0, TWO_PI) - HALF_PI;
  let minuteAngle = map(m + s / 60.0, 0, 60, 0, TWO_PI) - HALF_PI;
  let secondAngle = map(s,            0, 60, 0, TWO_PI) - HALF_PI;

  // 5. 绘制指针（使用 strokeCap(ROUND) 实心端点）
  strokeCap(ROUND);

  // 小时针
  stroke(200, 200, 255, 150);
  strokeWeight(8);
  line(
    centerX, centerY,
    centerX + cos(hourAngle)   * clockRadius * 0.4,
    centerY + sin(hourAngle)   * clockRadius * 0.4
  );

  // 分针
  stroke(150, 150, 200, 200);
  strokeWeight(6);
  line(
    centerX, centerY,
    centerX + cos(minuteAngle) * clockRadius * 0.6,
    centerY + sin(minuteAngle) * clockRadius * 0.6
  );

  // 秒针
  stroke(100, 100, 150, 200);
  strokeWeight(3);
  line(
    centerX, centerY,
    centerX + cos(secondAngle) * clockRadius * 0.7,
    centerY + sin(secondAngle) * clockRadius * 0.7
  );

  // 6. 在表面添加动态的暗影效果
  drawClockShadow();

  // 7. 绘制窗格
  drawWindow();

  // 8. 绘制月亮
  drawMoon();
}

// ========== 函数：绘制动态暗影 ==========
function drawClockShadow() {
  // 根据 frameCount 做简单摆动，生成暗影中心位置
  let shadowX = centerX + cos(frameCount * 0.01) * clockRadius * 0.6;
  let shadowY = centerY + sin(frameCount * 0.01) * clockRadius * 0.6;

  fill(0, 0, 0, 160);  // 半透明黑色，用于暗影
  noStroke();
  ellipse(shadowX, shadowY, clockRadius * 1.5, clockRadius * 1.5);
}

// ========== 函数：绘制窗格 ==========
function drawWindow() {
  stroke(0);
  strokeWeight(10);
  fill(245, 12);       // 半透明窗户颜色
  rectMode(CENTER);
  square(centerX, centerY, 900); // 绘制窗框

  // 在窗户上画两条分割线
  line(centerX - 450, centerY, centerX + 450, centerY);  // 水平线
  line(centerX, centerY - 450, centerX, centerY + 450);  // 垂直线
}

// ========== 函数：绘制月亮(带发光效果) ==========
function drawMoon() {
  // 将叠加模式设为 ADD，提升发光效果
  blendMode(ADD);

  // 基础圆形月亮
  fill(200, 200, 120, 200);
  circle(centerX + 300, centerY - 300, 70);

  // 发光层：从内到外，越外圈越大且越透明
  for (let i = 1; i <= 5; i++) {
    let glowRadius = 70 + i * 15;
    let glowAlpha  = 150 / i; // 越外层越淡
    fill(200, 200, 120, glowAlpha);
    circle(centerX + 300, centerY - 300, glowRadius);
  }

  // 恢复默认混合模式
  blendMode(BLEND);
}
