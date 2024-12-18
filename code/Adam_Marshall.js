let particles = [];
let infinityShape;

// 初始化
function setup() {
  createCanvas(800, 800);
  frameRate(60);
  noStroke();

  // 初始化无限符号和粒子
  infinityShape = new InfinityShape(width / 2, height / 2, 200);
  for (let i = 0; i < 200; i++) {
    particles.push(new FlowingParticle());
  }
}

// 动态绘制
function draw() {
  // 动态背景
  fill(0, 20);
  rect(0, 0, width, height);

  // 更新并绘制无限符号
  infinityShape.update();
  infinityShape.display();

  // 更新并绘制流动粒子
  for (let p of particles) {
    p.update(infinityShape.getTime());
    p.display(infinityShape.getTime());
  }
}

// 无限符号类
class InfinityShape {
  constructor(x, y, baseRadius) {
    this.x = x;
    this.y = y;
    this.baseRadius = baseRadius;
    this.layers = 13;
    this.speedFactor = 1.0;
    this.baseTime = 0;
    this.lastMillis = millis();
  }

  update() {
    // 计算时间间隔
    let currentMillis = millis();
    let deltaTime = (currentMillis - this.lastMillis) * 0.001;
    this.lastMillis = currentMillis;

    // 更新基础时间
    this.baseTime += deltaTime * this.speedFactor;

    // 调整速度因子
    if (mouseIsPressed && mouseButton === RIGHT) {
      this.speedFactor = max(0.2, lerp(this.speedFactor, 0.2, 0.05)); // 减慢
    } else {
      this.speedFactor = min(1.0, lerp(this.speedFactor, 1.0, 0.05)); // 恢复
    }
  }

  display() {
    let angleStep = TWO_PI / 200; // 每层的平滑度
    let growthRate = 6;          // 每层的增长
    let depthFactor = 40;        // Z轴深度模拟
    let verticalSpin = sin(this.baseTime * 0.7); // 垂直旋转

    for (let i = 0; i < this.layers; i++) {
      let radius = this.baseRadius + i * growthRate; // 半径递增
      let rotationSpeed = 0.3 + i * 0.05;           // 每层的旋转速度
      let layerAngleOffset = this.baseTime * rotationSpeed; // 角度偏移
      let z = sin(this.baseTime * 2 + i * 0.3) * depthFactor; // Z轴深度

      beginShape();
      for (let angle = 0; angle < TWO_PI; angle += angleStep) {
        let distortion = sin(angle * 5 + this.baseTime * 2) * 20; // 扭曲效果
        let px = this.x + (radius + distortion) * cos(angle + layerAngleOffset);
        let py = this.y + (radius + distortion) * sin(angle + layerAngleOffset);

        // 应用垂直旋转效果
        py += verticalSpin * (radius + distortion) * sin(angle);

        vertex(px, py);
      }
      endShape(CLOSE);

      // 模拟深度效果
      let thickness = map(z, -depthFactor, depthFactor, 1, 6); // 调整粗细

      // 动态颜色
      let baseHue = (this.baseTime * 40 + i * 15) % 255;
      stroke(color(baseHue, 200, 255 - i * 10, 200));
      strokeWeight(thickness);
      noFill();
    }
  }

  getTime() {
    return this.baseTime;
  }
}

// 粒子类
class FlowingParticle {
  constructor() {
    this.position = createVector(random(width), random(height));
    this.angleOffset = random(1000); // 唯一的Perlin噪声偏移
    this.lifespan = random(150, 255);
    this.gathering = false;
  }

  update(time) {
    if (this.gathering) {
      // 聚集到鼠标
      let target = createVector(mouseX, mouseY);
      let direction = p5.Vector.sub(target, this.position).normalize().mult(2);
      this.position.add(direction);
    } else {
      // 随机运动
      let angle = noise(this.position.x * 0.01, this.position.y * 0.01, time + this.angleOffset) * TWO_PI * 2;
      let velocity = p5.Vector.fromAngle(angle).mult(0.5); // 慢速运动
      this.position.add(velocity);
    }

    // 屏幕边界包裹
    if (this.position.x > width) this.position.x = 0;
    if (this.position.x < 0) this.position.x = width;
    if (this.position.y > height) this.position.y = 0;
    if (this.position.y < 0) this.position.y = height;

    this.lifespan -= 0.2; // 缓慢减少寿命
    if (this.lifespan < 0) this.lifespan = random(150, 255); // 重置寿命
  }

  display(time) {
    // 颜色随时间变化
    let r = sin(time * 0.3 + this.angleOffset) * 127 + 128;
    let g = sin(time * 0.4 + this.angleOffset + PI / 3) * 127 + 128;
    let b = sin(time * 0.5 + this.angleOffset + PI / 2) * 127 + 128;
    fill(r, g, b, this.lifespan);

    ellipse(this.position.x, this.position.y, 8, 8);
  }
}

// 鼠标按下事件
function mousePressed() {
  if (mouseButton === LEFT) {
    for (let p of particles) {
      p.gathering = true; // 聚集粒子
    }
  }
}

// 鼠标释放事件
function mouseReleased() {
  if (mouseButton === LEFT) {
    for (let p of particles) {
      p.gathering = false; // 恢复正常运动
    }
  }
}
