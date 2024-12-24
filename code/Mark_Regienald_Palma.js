// -----------------------------
// 全局变量声明（对应原 Processing 变量）
// -----------------------------

let silhouette;             // silhouette.png
let numStars = 150;
let starX = [];
let starY = [];
let starSizes = [];
let starSpeeds = [];

let numWaves = 8;
let offsets = [];
let auroraColors = [];

let meteor;                 // 单个流星对象
let meteorActive = false;   // 是否激活流星
let fireworks = [];         // Firework 对象列表（ArrayList<Firework>）

// -----------------------------
// p5.js 的 preload()：在这里加载图片等
// -----------------------------
function preload() {
  // 根据实际路径修改，如放在同级就保持这样，
  // 若在 `upload/` 下，则改为: loadImage("upload/silhouette.png")
  silhouette = loadImage("uploads/silhouette.png");
}

// -----------------------------
// setup()：初始化，与原 Processing 对应
// -----------------------------
function setup() {
  createCanvas(1600, 1200); // 不用 P2D，p5 默认是 2D
  // 如果担心图片没加载到，可在这里判断
  if (!silhouette) {
    print("Image failed to load. Check the file name and location.");
  }

  // 初始化星星的数据
  for (let i = 0; i < numStars; i++) {
    starX[i] = random(width);
    starY[i] = random(height * 0.7);
    starSizes[i] = random(2, 6);
    starSpeeds[i] = random(0.01, 0.05);
  }

  // 初始化极光波和它们的颜色
  for (let i = 0; i < numWaves; i++) {
    offsets[i] = random(TWO_PI); 
    // 这里用 p5.js color() 来生成 RGBA
    auroraColors[i] = color(random(50, 255), random(100, 255), random(150, 255), 100);
  }

  meteor = new Meteor(); // 初始化流星
  noStroke();            // 不描边
}

// -----------------------------
// draw()：主循环，与原 Processing 对应
// -----------------------------
function draw() {
  drawNightGradient(); // 绘制夜空渐变
  drawStars();         // 绘制星星

  // 如果流星激活，则更新并绘制它
  if (meteorActive) {
    meteor.update();
    meteor.display();
  }

  drawAuroraWaves();   // 绘制极光波
  drawFireworks();     // 绘制烟花
  drawSilhouette();    // 绘制剪影（silhouette.png）
}

// -----------------------------
// 与原代码对应的函数区域
// -----------------------------

// 1) 绘制夜空渐变
function drawNightGradient() {
  // Processing 中写的 color[] palette
  let palette = [
    color(1, 22, 46),
    color(0, 29, 55),
    color(0, 39, 70),
    color(1, 49, 85),
    color(0, 58, 99),
    color(1, 66, 109)
  ];

  let numColors = palette.length;
  let sectionHeight = height / (numColors - 1);

  for (let i = 0; i < numColors - 1; i++) {
    for (let y = i * sectionHeight; y < (i + 1) * sectionHeight; y++) {
      let t = map(y, i * sectionHeight, (i + 1) * sectionHeight, 0, 1);
      let interColor = lerpColor(palette[i], palette[i + 1], t);
      stroke(interColor);
      line(0, y, width, y);
    }
  }
}

// 2) 绘制星星
function drawStars() {
  noStroke();
  for (let i = 0; i < numStars; i++) {
    let brightness = 155 + sin(frameCount * starSpeeds[i]) * 100;
    fill(brightness);
    ellipse(starX[i], starY[i], starSizes[i], starSizes[i]);
  }
}

// 3) 绘制极光波
function drawAuroraWaves() {
  for (let i = 0; i < numWaves; i++) {
    fill(auroraColors[i]);

    // 根据 sin() + mouseY 计算波浪的竖直偏移
    let yOffset = map(sin(offsets[i]), -1, 1, -50, 50) +
                  map(mouseY, 0, height, -30, 30);

    beginShape();
    // 上边的波
    for (let x = 0; x <= width; x += 10) {
      let yTop = height / 3 + yOffset
        + sin(offsets[i] + x * 0.05 + map(mouseX, 0, width, -PI, PI)) * 60;
      vertex(x, yTop);
    }
    // 下边的波
    for (let x = width; x >= 0; x -= 10) {
      let yBottom = height / 2 + yOffset
        + sin(offsets[i] + x * 0.07 + map(mouseX, 0, width, -PI, PI)) * 30;
      vertex(x, yBottom);
    }
    endShape(CLOSE);

    offsets[i] += 0.02; // 让波浪随时间移动
  }
}

// 4) 绘制剪影图像
function drawSilhouette() {
  if (silhouette) {
    // 按整幅画布大小绘制
    image(silhouette, 0, 0, width, height);
  } else {
    print("Silhouette image not found!");
  }
}

// 5) 绘制烟花
function drawFireworks() {
  // 倒序遍历，方便删除已结束的烟花
  for (let i = fireworks.length - 1; i >= 0; i--) {
    let fw = fireworks[i];
    fw.update();
    fw.display();
    // 如果其粒子都结束了，就从数组中移除
    if (fw.particles.length === 0) {
      fireworks.splice(i, 1);
    }
  }
}

// -----------------------------
// Meteor 类
// -----------------------------
class Meteor {
  constructor() {
    this.reset();
  }

  reset() {
    this.x = random(width);
    this.y = random(height / 2);
    this.speedX = random(5, 8);
    this.speedY = random(5, 8);
    this.size = random(5, 20);
    this.coreColor = color(255);
    this.glowColor = color(255, 255, 255, 100);
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;
    if (this.x > width || this.y > height) {
      meteorActive = false;
    }
  }

  display() {
    // 画出流星光晕
    for (let i = 1; i <= 5; i++) {
      let glowSize = this.size + i * 10;
      fill(this.glowColor, 100 - i * 20);
      ellipse(this.x, this.y, glowSize, glowSize);
    }

    // 画出核心
    fill(this.coreColor);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);

    // 尾巴
    for (let i = 0; i < 10; i++) {
      let tailX = this.x - this.speedX * i * 0.5;
      let tailY = this.y - this.speedY * i * 0.5;
      let tailSize = this.size - i;
      fill(this.glowColor, 150 - i * 15);
      ellipse(tailX, tailY, tailSize, tailSize);
    }
  }
}

// -----------------------------
// Firework 类
// -----------------------------
class Firework {
  constructor(x, y) {
    this.particles = [];
    let numParticles = 100;
    for (let i = 0; i < numParticles; i++) {
      // 从 auroraColors 数组里随机选择一个颜色
      let col = auroraColors[floor(random(auroraColors.length))];
      this.particles.push(new Particle(x, y, col));
    }
  }

  update() {
    for (let i = this.particles.length - 1; i >= 0; i--) {
      let p = this.particles[i];
      p.update();
      if (p.isFinished()) {
        this.particles.splice(i, 1);
      }
    }
  }

  display() {
    for (let p of this.particles) {
      p.display();
    }
  }
}

// -----------------------------
// Particle 类 (烟花中的粒子)
// -----------------------------
class Particle {
  constructor(startX, startY, c) {
    this.x = startX;
    this.y = startY;
    this.speedX = random(-5, 5);
    this.speedY = random(-5, 5);
    this.life = 255; 
    this.col = c;
    this.size = random(5, 15);
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;
    this.life -= 5;
  }

  display() {
    fill(this.col, this.life);
    noStroke();
    ellipse(this.x, this.y, this.size, this.size);
  }

  isFinished() {
    return this.life <= 0;
  }
}

// -----------------------------
// 鼠标点击事件
// -----------------------------
function mousePressed() {
  // 如果按住 SHIFT 则在鼠标处创建烟花，否则重置并激活流星
  if (keyIsDown(SHIFT)) {
    fireworks.push(new Firework(mouseX, mouseY));
  } else {
    meteor.reset();
    meteorActive = true;
  }
}
