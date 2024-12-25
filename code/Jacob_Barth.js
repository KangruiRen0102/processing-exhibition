let numWaves = 10; // 波浪层数
let numRaindrops = 300; // 雨滴数量
let raindrops = []; // 存储所有雨滴的数组
let lightningBolts = []; // 存储闪电束的数组

function setup() {
  createCanvas(800, 600); // 创建800x600像素的画布
  noStroke(); // 全局禁用描边

  // 初始化雨滴
  for (let i = 0; i < numRaindrops; i++) {
    raindrops.push(new Raindrop());
  }

  // 初始化闪电束
  lightningBolts.push(new LightningBolt(200, 0, 220, 100, 220, 100, 200, 200)); // 闪电1
  lightningBolts.push(new LightningBolt(600, 0, 580, 150, 580, 150, 600, 250)); // 闪电2
}

function draw() {
  background(30, 40, 80); // 绘制深色暴风雨的天空背景

  drawClouds();          // 绘制云朵
  drawWaves();           // 绘制波浪
  drawStaticLightning(); // 绘制静态闪电
  drawShip();            // 绘制船只
  drawRain();            // 绘制雨滴
}

// 绘制混乱的波浪
function drawWaves() {
  fill(10, 20, 50);
  noStroke();
  for (let y = height / 2; y < height; y += 20) {
    beginShape();
    for (let x = 0; x < width; x += 10) {
      // 计算波浪高度，基于正弦和噪声，添加 frameCount 以实现动画
      let waveHeight = sin(radians(x * 0.05 + frameCount * 0.1)) * 20 + noise(x * 0.01, y * 0.01) * 40;
      vertex(x, y + waveHeight);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

// 绘制船只
function drawShip() {
  fill(200, 100, 50); // 船的颜色
  push(); // 保存当前变换矩阵
  translate(width / 2, height / 2); // 平移到画布中心

  // 船体
  rect(-70, -20, 140, 40);

  // 船底
  fill(150, 80, 40);
  arc(0, 20, 140, 60, 0, PI);

  // 桅杆（缩短，棕色）
  fill(139, 69, 19);
  rect(-5, -60, 10, 40);

  // 黑旗
  fill(0);
  rect(-5, -100, 50, 30);

  // 黑旗上的骷髅和骨头
  fill(255);
  ellipse(20, -85, 15, 15);
  ellipse(15, -80, 5, 5);
  ellipse(25, -80, 5, 5);
  rect(18, -78, 4, 5);
  stroke(255);
  strokeWeight(2);
  line(10, -90, 30, -80);
  line(10, -80, 30, -90);
  noStroke();

  // 帆
  fill(50);
  triangle(-5, -90, -70, -40, 60, -40);
  pop(); // 恢复之前的变换矩阵
}

// 绘制云朵
function drawClouds() {
  fill(80, 80, 80, 150);
  noStroke();
  for (let i = 0; i < 10; i++) {
    // 使云朵随着时间移动
    let x = (i * 150 + frameCount * 0.5) % (width + 200) - 200;
    let y = 50 + i * 20;
    ellipse(x, y, 150, 80);
    ellipse(x + 60, y + 10, 120, 70);
    ellipse(x - 60, y + 10, 120, 70);
  }
}

// 绘制雨滴
function drawRain() {
  for (let drop of raindrops) {
    drop.update();
    drop.show();
  }
}

// 绘制静态闪电
function drawStaticLightning() {
  stroke(255); // 白色的闪电
  strokeWeight(4);
  
  // 绘制所有闪电束
  for (let bolt of lightningBolts) {
    bolt.show();
  }
  
  strokeWeight(1); // 重置描边宽度
}

// Raindrop 类：管理单个雨滴的属性和行为
class Raindrop {
  constructor() {
    this.reset();
  }

  // 重置雨滴属性
  reset() {
    this.x = random(width);
    this.y = random(-height, height);
    this.speed = random(4, 10);
    this.len = random(10, 20);
    this.thickness = 1;
    this.color = color(100, 150, 255, 150);
  }

  // 更新雨滴位置
  update() {
    this.y += this.speed;
    if (this.y > height) {
      this.y = random(-100, -10);
      this.x = random(width);
    }
  }

  // 显示雨滴
  show() {
    stroke(this.color);
    strokeWeight(this.thickness);
    line(this.x, this.y, this.x, this.y + this.len);
  }
}

// LightningBolt 类：管理单个闪电束的属性和行为
class LightningBolt {
  constructor(x1, y1, x2, y2, x3, y3, x4, y4) {
    this.points = [
      createVector(x1, y1),
      createVector(x2, y2),
      createVector(x3, y3),
      createVector(x4, y4)
    ];
  }

  // 显示闪电束
  show() {
    beginShape();
    for (let p of this.points) {
      vertex(p.x, p.y);
    }
    endShape();
  }
}
