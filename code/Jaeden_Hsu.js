// 项目: 带有蒸汽和棉花糖的杯子场景

let mugCenterX = 400, mugCenterY = 400; // 杯子中心
let liquidLevel = 330; // 蒸汽和棉花糖浮动的参考高度
let steamParticles = []; // 蒸汽粒子数组

let numMarshmallows = 5; // 棉花糖数量
let marshmallows = [];
let selectedMarshmallow = null; // 当前拖拽的棉花糖
let marshmallowSize = 50;

function setup() {
  createCanvas(800, 800); // 画布大小
  frameRate(60);  // 设置更高的帧率以获得更平滑的动画
  
  for (let i = 0; i < numMarshmallows; i++) {
    let startX = mugCenterX + random(-17, 17) * 9; // 杯子宽度范围内的随机水平位置
    let startY = random(0, 400);  // 随机垂直位置
    marshmallows[i] = new Marshmallow(startX, startY, marshmallowSize); // 让棉花糖在不同位置生成
  }
}

function draw() {
  background(135, 206, 235); // 天空蓝色背景
  drawTable(); // 绘制桌子
  drawCup(); // 绘制杯子和碟子

  // 显示和交互棉花糖
  for (let m of marshmallows) {
    m.update();
    m.display();
  } 
  drawSteam(); // 绘制动态蒸汽
}

function drawTable() {
  stroke(0); // 黑色轮廓
  strokeWeight(2);
  fill(255); // 白色
  rect(0, 550, 800, 250); // 桌子
}

function drawCup() {
  // 碟子
  stroke(0); 
  strokeWeight(2);
  fill(255); // 白色
  ellipse(mugCenterX, 700, 600, 290); // 碟子
  noStroke(); 
  fill(0, 0, 0, 50); // 半透明黑色阴影
  ellipse(mugCenterX, 700, 440, 190); // 碟子阴影
  
  // 绘制杯子
  stroke(0); // 黑色轮廓
  strokeWeight(2);
  fill(255); // 白色
  rect(380, 355, 340, 205, 30); // 杯子手柄
  stroke(0); 
  strokeWeight(2);
  fill(135, 206, 235); // 天空蓝色
  rect(375, 370, 320, 175, 20); // 手柄背景
  fill(255); // 白色
  rect(175, 350, 450, 250); // 杯子主体
  ellipse(400, 600, 450, 300); // 杯子底部
  noStroke();
  fill(255); // 白色
  ellipse(400.5, 585, 448, 300); // 杯子底部（叠加）
  stroke(0); // 黑色轮廓
  strokeWeight(2);
  fill(255); // 白色
  ellipse(400, 350, 450, 180); // 杯子顶部
  
  // 绘制液体
  noStroke(); // 无轮廓
  fill(150, 75, 0); // 棕色杯液
  ellipse(400, 355, 410, 165); 
  fill(80, 40, 0); // 深棕色液体（咖啡或热巧克力）
  ellipse(400, 355, 400, 155); // 杯子内部液体
}

// 绘制蒸汽粒子的函数
function drawSteam() {
  if (frameCount % 10 === 0) {  // 每10帧添加一个蒸汽粒子
    steamParticles.push(new SteamParticle(mugCenterX, liquidLevel - 30));
  }

  // 更新并显示所有蒸汽粒子
  for (let i = steamParticles.length - 1; i >= 0; i--) {
    let p = steamParticles[i];
    p.update();
    p.display();

    // 移除消失的粒子
    if (p.lifespan <= 0) {
      steamParticles.splice(i, 1);
    }
  }
}

class SteamParticle {
  constructor(startX, startY) {
    this.x = startX + random(-100, 100); // 轻微水平变化
    this.y = startY + random(-50, 50);
    this.vx = random(-0.5, 0.5);       // 小水平漂移
    this.vy = random(-1, -5);          // 上升运动
    this.lifespan = 150;               // 初始透明度
    this.noiseOffset = random(1000);   // 用于扭曲运动的噪声偏移
  }

  update() {
    this.x += this.vx;
    this.y += this.vy;
    this.lifespan -= 1; // 逐渐消失

    // 基于噪声偏移添加扭曲运动
    this.vx = map(noise(this.noiseOffset), 0, 1, -1, 1); // 扭曲水平运动
    this.vy = map(noise(this.noiseOffset + 100), 0, 1, -1, -2); // 略微不同的噪声用于垂直运动
    this.noiseOffset += 0.01; // 增加噪声偏移以持续扭曲效果
  }

  display() {
    noStroke();
    fill(255, this.lifespan); // 白色，透明度随蒸汽消失而减少
    
    // 使用小椭圆绘制扭曲线条
    let squiggleLength = 40;  // 每段扭曲的长度
    for (let i = 0; i < squiggleLength; i++) {
      let angle = PI / 6;
      let sx = this.x + i * cos(angle) * 0.5; // X偏移，使其看起来扭曲
      let sy = this.y + i * sin(angle) * 0.5; // Y偏移，用于扭曲运动
      ellipse(sx, sy, 6, 12); // 绘制小椭圆作为扭曲段
    }
  }
}

function mousePressed() { // 当点击棉花糖时
  for (let m of marshmallows) {
    if (m.isHovered(mouseX, mouseY)) { // 如果鼠标在棉花糖上且点击，棉花糖被拖拽
      selectedMarshmallow = m;
      selectedMarshmallow.isFloating = false; // 拖拽时停止浮动
      break;
    }
  }
}

function mouseDragged() {
  // 拖拽棉花糖
  if (selectedMarshmallow != null) {
    selectedMarshmallow.x = mouseX;
    selectedMarshmallow.y = mouseY; // 随鼠标移动
  }
}

function mouseReleased() {
  // 放下棉花糖
  if (selectedMarshmallow != null) {
    selectedMarshmallow.x = constrain(selectedMarshmallow.x, mugCenterX - 130, mugCenterX + 130); // 限制棉花糖在杯子内移动
    selectedMarshmallow.isFloating = true; // 重新启用浮动
    selectedMarshmallow = null; // 取消选择
  }
}

class Marshmallow {
  constructor(x, y, size) {
    this.x = x;
    this.y = y;
    this.size = size; // 棉花糖大小
    this.vy = 0; // 垂直速度
    this.isFloating = true; // 是否浮动在液体上
    this.randomFloatOffset = random(-5, 35) * 2; // 用于定居的垂直偏移
    this.floatingSpeed = random(0.05, 0.1);  // 浮动速度
    this.hasSettled = false; // 棉花糖是否已定居
    this.targetY = liquidLevel + this.randomFloatOffset; // 棉花糖的最终定居位置
  }

  update() {
    if (this.isFloating) {
      // 应用重力，直到棉花糖到达液体水平
      if (this.y < liquidLevel - this.size / 2 && !this.hasSettled) {
        this.vy += 0.5; // 加速度
      } else {
        // 一旦棉花糖到达液体水平，停止重力并定居
        if (!this.hasSettled) {
          this.y = this.targetY; // 设置棉花糖的定居位置
          this.vy = 0; // 停止垂直速度
          this.hasSettled = true; // 棉花糖已定居
        }

        // 在定居位置周围平滑振荡
        let drift = sin(frameCount * 0.05) * 5; // 平滑振荡
        this.y = this.targetY + drift; // 应用平滑偏移
      }
      
      // 更新Y位置基于垂直速度
      this.y += this.vy;
    }
  }

  display() {
    stroke(0); // 黑色轮廓
    strokeWeight(2);
    fill(255); // 白色棉花糖
    ellipse(this.x, this.y, this.size, this.size * 0.6); // 椭圆形状，3D效果
  }

  isHovered(mx, my) {
    // 检查鼠标是否悬停在棉花糖上
    return dist(mx, my, this.x, this.y) < this.size / 2;
  }
}
