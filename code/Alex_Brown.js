let scene = 0; // 0 = Day, 1 = Twilight, 2 = Night
let northernLights = []; // 北极光的运动路径
let stars = []; // 星星数组
let buildings = [];
let northernLightsOffset = 0; // 北极光的偏移量

function setup() {
  createCanvas(800, 600); // 画布大小
  frameRate(60);  // 设置更高的帧率以获得更平滑的动画
  
  buildings = [];
  northernLights = [];
  stars = [];
  
  generateSmallTown();       // 生成“小镇”的布局，包括房屋和商店
  generateNorthernLights();  // 生成北极光
  generateStars();           // 生成星星
}

function draw() {
  switch (scene) {
    case 0:
      drawDayScene(); // 白天场景
      break;
    case 1:
      drawTwilightScene(); // 黄昏场景
      break;
    case 2:
      drawNightScene(); // 夜晚场景
      break;
  }
}

function mousePressed() {
  scene = (scene + 1) % 3; // 循环切换白天、黄昏和夜晚
}

function drawDayScene() {
  background(135, 206, 235); // 白天的蓝天背景
  
  // 太阳
  fill(255, 223, 0); // 黄色
  noStroke();
  ellipse(700, 100, 100, 100); // 太阳在右上角
  
  drawTown(50, color(50, 50, 50)); // 深灰色的轮廓
}

function drawTwilightScene() {
  // 创建从橙色到紫色的渐变天空
  for (let y = 0; y < height; y++) {
    let lerpFactor = map(y, 0, height, 0, 1);
    stroke(lerpColor(color(255, 94, 58), color(64, 27, 110), lerpFactor));
    line(0, y, width, y);
  }
  
  // 地平线附近发光的太阳
  noStroke();
  fill(255, 150, 0, 200); // 微弱的橙色光芒
  ellipse(700, height - 100, 120, 120); // 地平线附近的太阳
  
  fill(255, 223, 0, 255); // 更亮的中心
  ellipse(700, height - 100, 80, 80);
  
  drawTown(50, color(30, 30, 30)); // 更深的黑色轮廓
}

function drawNightScene() {
  background(10, 15, 45); // 夜晚的深蓝色天空
  
  drawNorthernLights(); // 绘制北极光
  drawStars();          // 绘制星星
  
  // 月亮
  fill(240, 240, 240); // 白色
  noStroke();
  ellipse(700, 100, 80, 80); // 月亮在右上角
  
  drawTown(50, color(30, 30, 30)); // 黑色轮廓
}

function drawNorthernLights() {
  northernLightsOffset += 0.005; // 慢慢移动北极光的偏移量
  
  for (let light of northernLights) {
    noFill();
    strokeWeight(10);
    
    for (let i = 0; i < light.length; i++) {
      let p = light[i];
      let shift = sin(northernLightsOffset + i * 0.05) * 10; // 微妙的垂直移动
      let clr = lerpColor(color(0, 255, 100, 100), color(50, 200, 255, 150), random(1));
      stroke(clr);
      line(p.x, p.y + shift, p.x + 10, p.y + shift);
    }
  }
}

function drawStars() {
  noStroke();
  fill(255);
  for (let star of stars) {
    ellipse(star.x, star.y, 2, 2); // 在静态位置绘制每颗星星
  }
}

function drawTown(baseHeight, silhouetteColor) {
  fill(silhouetteColor); // 设置轮廓颜色
  noStroke();
  
  rect(0, height - baseHeight, width, baseHeight); // 地面
  
  for (let b of buildings) {
    // 绘制建筑主体
    rect(b.x, height - baseHeight - b.height, b.width, b.height);
    
    // 为房屋添加尖顶屋顶
    if (b.type === "house") {
      triangle(
        b.x, height - baseHeight - b.height,
        b.x + b.width / 2, height - baseHeight - b.height - b.height / 3,
        b.x + b.width, height - baseHeight - b.height
      );
    }
    
    // 绘制窗口
    for (let window of b.windowPositions) {
      strokeWeight(2); // 固定窗口边框厚度
      stroke(255); // 白色边框
      noFill();
      rect(b.x + window.x - 0.8, height - baseHeight - b.height / 2 + window.y - 2, 20, 20); // 大窗口
      
      // 窗户“关闭”效果
      fill(175, 214, 255); // 与天空颜色相同的填充色
      noStroke();
      rect(b.x + window.x, height - baseHeight - b.height / 2 + window.y, 18, 18); // 较大的窗口大小
      
      // 窗户中间的竖线
      stroke(255); // 白色线条
      line(
        b.x + window.x + 9, 
        height - baseHeight - b.height / 2 + window.y, 
        b.x + window.x + 9, 
        height - baseHeight - b.height / 2 + window.y + 18
      );
      
      // 窗户中间的横线
      line(
        b.x + window.x, 
        height - baseHeight - b.height / 2 + window.y + 8, 
        b.x + window.x + 18, 
        height - baseHeight - b.height / 2 + window.y + 8
      );
    }
    
    // 在商店内添加标志
    if (b.type === "store") {
      fill(255); // 白色
      textSize(16);
      textAlign(CENTER, CENTER);
      text("STORE", b.x + b.width / 2, height - baseHeight - b.height / 2); // 商店内的标志
    }
    
    fill(silhouetteColor); // 重置填充色为下一个建筑物准备
  }
}

function generateSmallTown() {
  // 设置固定数量的建筑：1个商店和2个房屋
  let x = 50; // 从左侧开始留出一些间距
  
  // 房屋1
  let houseWidth = 100;
  let houseHeight = 80;
  let house1 = new Building(x, houseWidth, houseHeight, "house");
  house1.windowPositions.push(createVector(houseWidth / 2 - 8, -houseHeight / 4)); // 低位大窗口
  buildings.push(house1);
  x += houseWidth + random(40, 60); // 添加间距
  
  // 房屋2
  let houseWidth2 = 100;
  let houseHeight2 = 80;
  let house2 = new Building(x, houseWidth2, houseHeight2, "house");
  house2.windowPositions.push(createVector(houseWidth2 / 2 - 8, -houseHeight2 / 4)); // 低位大窗口
  buildings.push(house2);
  x += houseWidth2 + random(40, 60); // 添加间距
  
  // 商店（较大）
  let storeWidth = 200;  // 较宽的商店
  let storeHeight = 120;
  let store = new Building(x, storeWidth, storeHeight, "store");
  store.windowPositions.push(createVector(storeWidth / 4 - 8, -storeHeight / 4)); // 低位大窗口
  store.windowPositions.push(createVector(3 * storeWidth / 4 - 8, -storeHeight / 4)); // 低位大窗口
  buildings.push(store);
}

function generateNorthernLights() {
  for (let i = 0; i < 10; i++) {
    let light = [];
    let xStart = random(0, width);
    let xEnd = xStart + random(100, 200);
    let yStart = random(100, 200);
    let yEnd = yStart + random(50, 150);
    
    for (let x = xStart; x <= xEnd; x += 10) {
      let y = lerp(yStart, yEnd, noise(x * 0.01));
      light.push(createVector(x, y));
    }
    northernLights.push(light);
  }
}

function generateStars() {
  for (let i = 0; i < 100; i++) {
    stars.push(createVector(random(width), random(height / 2))); // 随机星星位置
  }
}

class Building {
  constructor(x, width, height, type) {
    this.x = x;
    this.width = width;
    this.height = height;
    this.type = type;
    this.windowPositions = [];
  }
}
