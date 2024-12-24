// -----------------------------
//  先进的极光、黄昏与海洋视觉效果 (p5.js版)
//  主题: “极光下的迷人黄昏，映照在宁静海面”
// -----------------------------

// ========== 全局变量 ==========
let twilightFactor = 0;           // 用于控制黄昏渐变动画
let auroras = [];                // 存储极光 AuroraWave 对象
let stars = [];                  // 存储 Star 对象
let shootingStars = [];          // 存储 ShootingStar 对象
let waves = [];                  // 存储海浪 Wave 对象
let moonX, moonY;               // 月亮位置

// 波浪角度和振幅
let angle = 0;
let angle1 = 90;
let angle2 = 180;
let amplitude = 4;    // 第一层海浪振幅
let amplitude1 = 7;   // 第二层海浪振幅
let amplitude2 = 5;   // 第三层海浪振幅

// 海洋渐变色
let seaColor1, seaColor2, seaColor3;

function setup() {
  createCanvas(800, 600);      // 创建画布
  frameRate(30);               // 设置帧率
  
  // 颜色初始化
  seaColor1 = color(16, 3, 57);   // 深蓝
  seaColor2 = color(22, 4, 67);   // 稍亮一点的蓝色
  seaColor3 = color(25, 5, 75);   // 再亮一点的蓝色

  // 初始化极光 AuroraWave
  for (let i = 0; i < 5; i++) {
    auroras.push(new AuroraWave(random(width), random(50, 150), random(2, 5), random(100, 300)));
  }

  // 在屏幕上半部随机生成星星
  for (let i = 0; i < 200; i++) {
    stars.push(new Star(random(width), random(height / 2)));
  }

  // 生成少量流星
  for (let i = 0; i < 3; i++) {
    shootingStars.push(new ShootingStar(random(width), random(height / 2), random(3, 5)));
  }

  // 生成海浪
  for (let i = 0; i < 3; i++) {
    waves.push(new Wave(random(0, width), height - 80, random(100, 200), random(0.0025, 0.01)));
  }

  // 月亮位置（屏幕顶部中心）
  moonX = width / 2;
  moonY = height / 4;
}

function draw() {
  drawTwilight();      // 1. 画出黄昏渐变背景
  
  // 2. 绘制并更新星星（闪烁）
  for (let star of stars) {
    star.twinkle();
  }
  
  // 3. 流星的更新与显示
  for (let shootingStar of shootingStars) {
    shootingStar.update();
    shootingStar.display();
  }

  // 4. 绘制并更新极光
  for (let wave of auroras) {
    wave.update();
    wave.display();
  }

  // 5. 绘制山脉
  drawMountains();

  // 6. 绘制月亮
  drawMoon();

  // 7. 绘制海浪分层
  drawWater1();
  drawWater2();
  drawWater3();

  // 8. 最前景的树
  drawTrees();
}

// 点击鼠标时，随机改变极光的振幅
function mousePressed() {
  for (let aurora of auroras) {
    aurora.amplitude = random(50, 200);
  }
}

// ===============================
//         黄昏渐变背景
// ===============================
function drawTwilight() {
  // 从暖色到冷色，再逐渐到黑色
  for (let y = 0; y < height; y++) {
    let inter = map(y, 0, height, 0, 1);
    let c1 = lerpColor(color(255, 150, 150), color(50, 50, 150), inter); // 暖 -> 冷
    let c2 = lerpColor(color(50, 50, 150), color(0, 0, 0), inter);       // 冷 -> 黑
    stroke(lerpColor(c1, c2, twilightFactor));
    line(0, y, width, y);
  }
  twilightFactor += 0.0003;     // 缓慢变化
  if (twilightFactor > 1) {
    twilightFactor = 0;         // 循环
  }
}

// ===============================
//         AuroraWave 类
// ===============================
class AuroraWave {
  constructor(xOffset, y, speed, amplitude) {
    this.xOffset = xOffset;
    this.y = y;
    this.speed = speed;
    this.amplitude = amplitude;
    this.hue = random(150, 250); // Aurora 颜色基调
  }

  update() {
    // 向左移动
    this.xOffset -= this.speed;
    // 如果移出屏幕，则回到右侧
    if (this.xOffset < -width) {
      this.xOffset = width;
    }
    // 慢慢变化颜色
    this.hue += 0.1;
    if (this.hue > 300) {
      this.hue = 150;
    }
  }

  display() {
    noFill();
    strokeWeight(2);
    // 用 30 条相似的波形来做极光层次
    for (let i = 0; i < 30; i++) {
      // 半透明笔触，让后面的线条能层叠
      stroke(color(this.hue, 200, 255, 100 - i * 3));
      beginShape();
      for (let x = 0; x < width; x += 10) {
        let offset = this.xOffset + x;
        let yPos = this.y + sin(offset * 0.01) * this.amplitude;
        vertex(x, yPos - i * 2);
      }
      endShape();
    }
  }
}

// ===============================
//           Star 类
// ===============================
class Star {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.brightness = random(150, 255); // 初始亮度
    this.blinkSpeed = random(0.01, 0.03); 
  }

  twinkle() {
    this.brightness += sin(frameCount * this.blinkSpeed) * 5;
    fill(this.brightness, this.brightness, 255);
    noStroke();
    ellipse(this.x, this.y, 3, 3);
  }
}

// ===============================
//      ShootingStar (流星)
// ===============================
class ShootingStar {
  constructor(x, y, speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }

  update() {
    // 向左下移动
    this.x -= this.speed;
    this.y += this.speed * 0.5;
    // 超出屏幕后重置回右侧
    if (this.x < 0 || this.y > height) {
      this.x = random(width, width * 1.5);
      this.y = random(height / 2);
    }
  }

  display() {
    stroke(255, 255, 150);
    strokeWeight(2);
    // 小尾巴
    line(this.x, this.y, this.x + 10, this.y - 5);
  }
}

// ===============================
//           绘制月亮
// ===============================
function drawMoon() {
  noStroke();
  // 外层晕圈
  for (let i = 50; i > 0; i--) {
    fill(255, 240, 150, map(i, 50, 0, 50, 0));
    ellipse(moonX, moonY, 100 + i, 100 + i);
  }
  // 主体
  fill(255, 240, 150, 200);
  ellipse(moonX, moonY, 100, 100);
}

// ===============================
//           Wave 类
// ===============================
class Wave {
  constructor(xPos, yPos, amplitude, speed) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.amplitude = amplitude;
    this.speed = speed;
    this.waveOffset = random(0, 100);
  }

  update() {
    this.waveOffset += this.speed;
  }

  display() {
    fill(lerpColor(seaColor1, seaColor3, random(0.5, 0.8)));
    beginShape();
    for (let x = 0; x < width; x += 10) {
      let yWave = this.yPos + sin(this.waveOffset + x * 0.02) * this.amplitude;
      vertex(x, yWave);
    }
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
}

// ===============================
//    分层海浪 (三层)
// ===============================
function drawWater1() {
  push();
  translate(0, amplitude * sin(radians(angle)));
  angle += 0.25;
  fill(seaColor1);
  beginShape();
  vertex(0, height - 60);
  vertex(width, height - 60);
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
  pop();
}

function drawWater2() {
  push();
  translate(0, amplitude1 * sin(radians(angle1)));
  angle1 += 0.5;
  fill(seaColor2);
  beginShape();
  vertex(0, height - 40);
  vertex(width, height - 40);
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
  pop();
}

function drawWater3() {
  push();
  translate(0, amplitude2 * sin(radians(angle2)));
  angle2 += 0.75;
  fill(seaColor3);
  beginShape();
  vertex(0, height - 15);
  vertex(width, height - 15);
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
  pop();
}

// ===============================
//         绘制山脉
// ===============================
function drawMountains() {
  noStroke();

  // 第 1 层山（最远）
  fill(65, 22, 65);
  beginShape();
  vertex(0, height / 1.3);
  vertex(50, height / 1.7);
  vertex(100, height / 1.8);
  vertex(150, height / 1.7);
  vertex(200, height / 1.9);
  vertex(250, height / 2.1);
  vertex(300, height / 2.3);
  vertex(350, height / 2.1);
  vertex(400, height / 2.0);
  vertex(450, height / 1.8);
  vertex(500, height / 1.7);
  vertex(550, height / 1.8);
  vertex(600, height / 2.0);
  vertex(650, height / 1.8);
  vertex(700, height / 1.7);
  vertex(750, height / 1.8);
  vertex(800, height / 1.7);
  vertex(width, height);
  endShape(CLOSE);

  // 第 2 层山
  fill(46, 16, 46);
  beginShape();
  vertex(0, height / 1.4);
  vertex(50, height / 1.7);
  vertex(100, height / 1.6);
  vertex(150, height / 1.5);
  vertex(200, height / 1.5);
  vertex(250, height / 1.7);
  vertex(300, height / 2.0);
  vertex(350, height / 1.8);
  vertex(400, height / 1.7);
  vertex(450, height / 1.6);
  vertex(500, height / 1.6);
  vertex(550, height / 1.5);
  vertex(600, height / 1.7);
  vertex(650, height / 1.6);
  vertex(700, height / 1.5);
  vertex(750, height / 1.6);
  vertex(800, height / 1.7);
  vertex(width, height);
  endShape(CLOSE);

  // 第 3 层山
  fill(39, 13, 39);
  beginShape();
  vertex(0, height / 1.4);
  vertex(50, height / 1.6);
  vertex(100, height / 1.5);
  vertex(150, height / 1.4);
  vertex(200, height / 1.4);
  vertex(250, height / 1.5);
  vertex(300, height / 1.7);
  vertex(350, height / 1.6);
  vertex(400, height / 1.5);
  vertex(450, height / 1.4);
  vertex(500, height / 1.4);
  vertex(550, height / 1.5);
  vertex(600, height / 1.4);
  vertex(650, height / 1.3);
  vertex(700, height / 1.2);
  vertex(750, height / 1.3);
  vertex(800, height / 1.3);
  vertex(width, height);
  endShape(CLOSE);

  // 第 4 层山
  fill(23, 7, 23);
  beginShape();
  vertex(0, height / 1.3);
  vertex(50, height / 1.6);
  vertex(100, height / 1.4);
  vertex(150, height / 1.3);
  vertex(200, height / 1.3);
  vertex(250, height / 1.4);
  vertex(300, height / 1.6);
  vertex(350, height / 1.5);
  vertex(400, height / 1.4);
  vertex(450, height / 1.3);
  vertex(500, height / 1.3);
  vertex(550, height / 1.3);
  vertex(600, height / 1.4);
  vertex(650, height / 1.3);
  vertex(700, height / 1.2);
  vertex(750, height / 1.4);
  vertex(800, height / 1.3);
  vertex(width, height);
  endShape(CLOSE);

  // 第 5 层山（最近）
  fill(26, 7, 26);
  beginShape();
  vertex(0, height / 1.2);
  vertex(50, height / 1.6);
  vertex(100, height / 1.4);
  vertex(150, height / 1.3);
  vertex(200, height / 1.2);
  vertex(250, height / 1.4);
  vertex(300, height / 1.6);
  vertex(350, height / 1.5);
  vertex(400, height / 1.4);
  vertex(450, height / 1.2);
  vertex(500, height / 1.3);
  vertex(550, height / 1.2);
  vertex(600, height / 1.4);
  vertex(650, height / 1.3);
  vertex(700, height / 1.2);
  vertex(750, height / 1.4);
  vertex(800, height / 1.3);
  vertex(width, height);
  endShape(CLOSE);
}

// ===============================
//           绘制树
// ===============================
function drawTrees() {
  // 第 1 排树
  fill(19, 1, 15);
  for (let x = 0; x < width; x += 30) {
    let treeHeight = map(abs(x - width / 2), 0, width / 2.5, 30, 150);
    drawTree(x, height - 100, treeHeight);
  }

  // 第 2 排树（往下些）
  fill(11, 0, 10);
  for (let x = 0; x < width; x += 30) {
    let treeHeight = map(abs(x - width / 2), 0, width / 2, 10, 130);
    drawTree(x, height - 70, treeHeight);
  }

  // 第 3 排树（再往下）
  fill(4, 0, 4);
  for (let x = 0; x < width; x += 30) {
    let treeHeight = map(abs(x - width / 2), 0, width / 2, 5, 70);
    drawTree(x, height - 50, treeHeight);
  }
}

// 画单棵树：三段三角形 + 一个矩形树干
function drawTree(x, y, size) {
  triangle(x, y, x - size / 2, y + size, x + size / 2, y + size);               // 底部
  triangle(x, y - size / 3, x - size / 3, y + size / 3, x + size / 3, y + size / 3); // 中段
  triangle(x, y - (size * 2) / 3, x - size / 4, y, x + size / 4, y);            // 顶部
  rect(x - size / 10, y + size, size / 5, size / 4);                           // 树干
}
