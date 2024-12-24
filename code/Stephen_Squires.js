// 关键字: Discovery, Sea, and Journey
// 主题句:
// "Through rough seas and changing skies, a solo boat begins
//  a long journey towards discovering the unknown."

let boatX;            // 船的x位置
let boatY = 300;      // 船的y位置
let waveAmplitude = 15; 
let waveFrequency = 0.02;
let numWaves = 4;     // 波浪数量
let starCount = 100;  // 星星数量
let starX = [];       // 存储星星x坐标的数组
let starY = [];       // 存储星星y坐标的数组

function setup() {
  createCanvas(800, 600);
  // 初始化船的位置
  boatX = -100;

  // 随机放置星星
  for (let i = 0; i < starCount; i++) {
    starX[i] = random(width);
    starY[i] = random(height / 2); // 上半部分放置星星
  }
}

function draw() {
  backgroundGradient();
  drawStars();
  drawWaves();
  drawBoat();
  updateBoatPosition();
}

// 根据时间更改背景颜色以显示昼夜变化
function backgroundGradient() {
  // 使用frameCount为颜色动画提供时间基础
  let cycle = sin(frameCount * 0.002);

  // skyColor在昼（浅蓝）和夜（深紫）之间渐变
  let r = map(cycle, -1, 1, 30, 150);
  let g = map(cycle, -1, 1, 30, 200);
  let b = map(cycle, -1, 1, 60, 255);

  // 从上到下创建渐变
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0, 1);
    let col = lerpColor(color(r, g, b), color(0, 20, 60), inter);
    stroke(col);
    line(0, y, width, y);
  }
}

// 绘制只有在夜晚时才出现的星星
function drawStars() {
  let cycle = sin(frameCount * 0.002);
  if (cycle < 0) {
    fill(255);
    noStroke();
    for (let i = 0; i < starCount; i++) {
      ellipse(starX[i], starY[i], 2, 2);
    }
  }
}

// 绘制模拟海洋的正弦波
function drawWaves() {
  stroke(0, 50, 150);
  noFill();
  for (let w = 0; w < numWaves; w++) {
    beginShape();
    for (let x = 0; x <= width; x += 10) {
      let y = height / 2 + w * waveAmplitude * 2 + 
              sin(x * waveFrequency + (frameCount * 0.03) + w * PI / 2) * waveAmplitude;
      vertex(x, y);
    }
    endShape();
  }
}

// 绘制船
function drawBoat() {
  // 船体
  fill(139, 69, 19);  // 棕色
  noStroke();
  rectMode(CENTER);
  rect(boatX, boatY, 50, 15);

  // 帆
  fill(255);
  triangle(boatX, boatY - 20, boatX, boatY, boatX + 25, boatY - 10);
}

// 更新船的位置并在超出屏幕时重置
function updateBoatPosition() {
  boatX += 1.0;
  if (boatX > width + 100) {
    boatX = -100;
  }
}
