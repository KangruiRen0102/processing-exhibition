// ========== 全局变量 ==========
let fishSchool = []; // Array for fish
let numFish = 50;    // Number of fish
let seaFlow;         // PVector for sea flow
let noiseFactor = 0.01; // Noise factor for fish movement

// ========== 设置函数 ==========
function setup() {
  createCanvas(800, 600); // Canvas size
  seaFlow = createVector(1, 0.3); // Flow of the sea in vector form
  
  // 创建鱼群，指定颜色
  for (let i = 0; i < numFish; i++) {
    let fishColor = color(255, 165, 0); // 橙色
    fishSchool.push(new Fish(random(width), random(height), fishColor, 8));
  }
  
  // 添加一条蓝色鱼
  let uniqueColor = color(0, 0, 255); // 蓝色
  fishSchool.push(new Fish(random(width), random(height), uniqueColor, 12));
}

// ========== 主绘制循环 ==========
function draw() {
  background(30, 144, 255); // 天空蓝背景
  
  // 生成波浪图案
  for (let y = 0; y < height; y += 40) {
    stroke(0, 100, 255, 70);
    strokeWeight(2);
    noFill();
    beginShape();
    for (let x = 0; x < width; x += 20) {
      let waveY = y + sin((x + frameCount) * 0.05) * 10;
      vertex(x, waveY);
    }
    endShape();
  }
  
  // 绘制海底细节：海草和贝壳
  for (let i = 0; i < width; i += 50) {
    // 生成海草
    stroke(34, 139, 34); // 棕绿色
    strokeWeight(3);
    noFill();
    beginShape();
    for (let j = height - 40; j < height; j += 10) {
      let swayX = sin((i + frameCount) * 0.02) * 10;
      vertex(i + swayX, j);
    }
    endShape();
    
    // 添加贝壳
    fill(255, 223, 196); // 浅粉色
    stroke(210, 180, 140); // 沙棕色
    strokeWeight(1);
    ellipse(i, height - 20, 15, 10);
    line(i - 7, height - 20, i + 7, height - 20); // 贝壳细节线
  }
  
  // 更新和显示每条鱼
  for (let fish of fishSchool) {
    fish.followFlow(seaFlow);
    fish.updatePosition();
    fish.display();
  }
}

// ========== Fish 类 ==========
class Fish {
  constructor(x, y, c, s) {
    this.position = createVector(x, y); // 位置
    this.velocity = createVector(random(-2, 2), random(-1, 1)); // 速度
    this.size = s; // 尺寸
    this.fishColor = c; // 颜色
  }
  
  // 更新位置
  updatePosition() {
    this.position.add(this.velocity);
    
    // 边界检查，环绕效果
    if (this.position.x > width) this.position.x = 0;
    if (this.position.x < 0) this.position.x = width;
    if (this.position.y > height) this.position.y = 0;
    if (this.position.y < 0) this.position.y = height;
  }
  
  // 跟随海流
  followFlow(flow) {
    let angle = noise(this.position.x * noiseFactor, this.position.y * noiseFactor, frameCount * 0.01) * TWO_PI;
    let flowDirection = flow.copy().rotate(angle).normalize().mult(0.5);
    this.velocity.add(flowDirection);
    this.velocity.limit(2); // 限制速度，防止鱼游得太快
  }
  
  // 显示鱼
  display() {
    push();
    translate(this.position.x, this.position.y);
    let angle = atan2(this.velocity.y, this.velocity.x);
    rotate(angle);
    
    fill(this.fishColor);
    noStroke();
    
    // 绘制鱼体
    beginShape();
    vertex(-this.size * 1.5, 0);       // 后鳍
    vertex(-this.size, this.size / 2); // 下后角
    vertex(0, this.size / 2);          // 底部曲线
    vertex(this.size, this.size / 3);  // 底下方
    vertex(this.size * 1.5, 0);        // 鼻尖
    vertex(this.size, -this.size / 3); // 上部曲线
    vertex(0, -this.size / 2);         // 上后角
    vertex(-this.size, -this.size / 2); // 上鳍
    vertex(-this.size * 1.5, 0);       // 回到后鳍
    endShape(CLOSE);
    
    // 绘制眼睛
    fill(0); // 黑色眼睛
    ellipse(this.size * 0.8, -this.size * 0.2, this.size * 0.3, this.size * 0.3);
    
    // 绘制鱼鳞
    stroke(255, 215, 0, 100); // 金色鱼鳞
    noFill();
    for (let i = -this.size * 1.2; i < this.size * 0.5; i += this.size * 0.3) {
      for (let j = -this.size * 0.6; j < this.size * 0.6; j += this.size * 0.3) {
        ellipse(i, j, this.size * 0.3, this.size * 0.3);
      }
    }
    
    pop();
  }
}
