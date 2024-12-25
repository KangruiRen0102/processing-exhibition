let waveCount = 60;
let waveHeight;
let waveSpeed;
let growthSize = 10;
let growthSpeed = 0.3;

function setup() {
  createCanvas(800, 600);
  noStroke();
}

function draw() {
  // 绘制海洋的渐变背景
  setGradient(0, 0, width, height, color(0, 100, 200), color(0, 0, 100), "Y");

  // 绘制波浪（象征变化带来的挑战）
  for (let i = 0; i < waveCount; i++) {
    waveHeight = sin(radians(frameCount + (i * 180 / waveCount))) * 50 + 100;
    waveSpeed = sin(radians(frameCount * 200 + i)) * 2;
    fill(255); // 波浪的颜色可以根据需要调整
    ellipse(i * (width / waveCount), waveHeight, waveSpeed, 30);
  }

  // 绘制成长象征的形状
  fill(0, 200, 250); // 明亮的颜色代表成长
  ellipse(width / 2, height / 2 + sin(radians(frameCount)) * 50, growthSize, growthSize);

  // 增加成长的大小，象征发展
  growthSize += growthSpeed;
  if (growthSize > 200) {
    growthSize = 10; // 重置大小，代表持续的成长
  }
}

// 函数：创建渐变背景
function setGradient(x, y, w, h, c1, c2, axis) {
  noFill();

  if (axis === "Y") { // 垂直渐变
    for (let i = y; i <= y + h; i++) {
      let inter = map(i, y, y + h, 0, 1);
      let c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x + w, i);
    }
  } else if (axis === "X") { // 水平渐变
    for (let i = x; i <= x + w; i++) {
      let inter = map(i, x, x + w, 0, 1);
      let c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y + h);
    }
  }
}
