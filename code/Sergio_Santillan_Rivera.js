// 定义渐变颜色
let start_color, end_color, day_start_color, day_end_color;
let twilightFactor = 0; // 日夜过渡（1 表示白天，0 表示晚上）

let shapes = [];
let sunX, sunY;
let sunRadius = 100;
let lightIntensity = 150;
let canCreateShapes = true; // 是否允许创建形状
let isDraggingSun = false; // 是否正在拖动太阳

function setup() {
  createCanvas(1200, 800);

  // 初始化渐变颜色
  start_color = color(10, 10, 60); // 黄昏顶部颜色
  end_color = color(200, 150, 80); // 黄昏底部颜色
  day_start_color = color(135, 206, 250); // 早晨顶部颜色
  day_end_color = color(255, 255, 255); // 早晨底部颜色

  sunX = width / 2;
  sunY = height / 2;

  // 初始化雪花
  for (let i = 0; i < 100; i++) {
    shapes.push(new Snowflake(random(width), random(height), random(2, 5), color(255)));
  }

  frameRate(60);
}

function draw() {
  updateTwilightFactor(); // 更新日夜过渡因子

  // 计算渐变背景颜色
  let interpolated_start = lerpColor(start_color, day_start_color, twilightFactor);
  let interpolated_end = lerpColor(end_color, day_end_color, twilightFactor);

  // 绘制渐变背景
  for (let i = 0; i < height; i++) {
    let inter = map(i, 0, height, 0, 1);
    let c = lerpColor(interpolated_start, interpolated_end, inter);
    stroke(c);
    line(0, i, width, i);
  }

  // 绘制太阳
  drawSun();

  // 更新并绘制所有形状
  for (let shape of shapes) {
    if (shape instanceof Snowflake) {
      shape.update();
    }
    shape.display();
  }
}

function drawSun() {
  // 根据 twilightFactor 调整光强
  let scaledLightIntensity = map(twilightFactor, 0, 1, 300, 50); // 夜晚更亮，白天更暗

  // 绘制太阳周围的光环
  for (let r = sunRadius; r < sunRadius + scaledLightIntensity; r += 10) {
    let alpha = map(r, sunRadius, sunRadius + scaledLightIntensity, 150, 0);
    fill(255, 200, 0, alpha);
    ellipse(sunX, sunY, r * 2, r * 2);
  }

  // 绘制太阳本身
  fill(255, 255, 0);
  ellipse(sunX, sunY, sunRadius * 2, sunRadius * 2);
}

function updateTwilightFactor() {
  // 根据太阳的 Y 坐标更新 twilightFactor
  twilightFactor = map(sunY, height, 0, 0, 1);
  twilightFactor = constrain(twilightFactor, 0, 1);
}

function mouseDragged() {
  if (!canCreateShapes && isDraggingSun) {
    // 拖动太阳
    sunX = mouseX;
    sunY = mouseY;
  }
}

function mousePressed() {
  if (!canCreateShapes) {
    // 检查鼠标是否在太阳上
    let d = dist(mouseX, mouseY, sunX, sunY);
    if (d < sunRadius) {
      isDraggingSun = true;
    }
  }
}

function mouseReleased() {
  isDraggingSun = false; // 停止拖动太阳
}

function keyPressed() {
  switch (key.toLowerCase()) {
    case 'f': // 切换太阳的交互模式
      canCreateShapes = !canCreateShapes;
      break;

    case 'n': // 添加 20 个新的雪花
      if (canCreateShapes) {
        for (let i = 0; i < 20; i++) {
          shapes.push(new Snowflake(random(width), random(height), random(2, 5), color(255)));
        }
      }
      break;

    case 'c': // 清除所有雪花
      if (canCreateShapes) {
        shapes = shapes.filter(shape => !(shape instanceof Snowflake));
      }
      break;

    case 'w': // 调整雪花速度
      if (canCreateShapes) {
        for (let shape of shapes) {
          if (shape instanceof Snowflake) {
            shape.vx *= random(0.5, 1.5);
            shape.vy *= random(0.5, 1.5);
          }
        }
      }
      break;

    case 'l': // 降低太阳位置
      sunY = min(height, sunY + 10);
      break;

    case 'r': // 提升太阳位置
      sunY = max(0, sunY - 10);
      break;
  }
}

// 基础形状类
class Shape {
  constructor(x, y, fillColor) {
    this.x = x;
    this.y = y;
    this.fillColor = fillColor;
  }

  display() {
    fill(this.fillColor);
    noStroke();
  }
}

// 雪花类
class Snowflake extends Shape {
  constructor(x, y, size, fillColor) {
    super(x, y, fillColor);
    this.size = size;
    this.vx = random(-1, 1);
    this.vy = random(1, 3);
  }

  display() {
    super.display();
    ellipse(this.x, this.y, this.size, this.size);
  }

  update() {
    this.x += this.vx;
    this.y += this.vy;

    if (this.y > height) {
      this.y = 0;
      this.x = random(width);
    }
  }
}
