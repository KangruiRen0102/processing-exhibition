// 全局变量声明
let buildingHeights;  // 存储建筑高度的数组
let numBuildings;     // 建筑物数量

function setup() {
  createCanvas(800, 400);  // 设置画布大小
  noStroke();              // 默认情况下，不绘制形状的轮廓
  
  // 初始化建筑高度数组
  numBuildings = floor(width / 100);  // 根据画布宽度和间隔确定建筑数量
  buildingHeights = new Array(numBuildings);
  
  // 为每栋建筑设置随机高度，只设置一次，较高的高度
  for (let i = 0; i < numBuildings; i++) {
    buildingHeights[i] = floor(random(0.6 * height, 0.9 * height));  // 随机高度在画布高度的60%到90%之间
  }
}

function draw() {
  background(220, 240, 255);  // 设置背景颜色为浅蓝色
  
  // 绘制城市天际线（每帧绘制）
  drawSkyline();
  
  // 绘制红色桥梁（位于天际线和波浪之间）
  drawBridge();
  
  // 在桥梁和建筑物上方绘制波浪
  drawWaves();
}

// 绘制城市天际线的函数
function drawSkyline() {
  let buildingWidth = 80;           // 每栋建筑的宽度
  let spaceBetweenBuildings = 100;  // 建筑之间的间隔
  
  // 循环绘制建筑物
  for (let i = 0; i < numBuildings; i++) {
    // 获取当前建筑的预设高度
    let buildingHeight = buildingHeights[i];
    
    // 设置建筑物的颜色为深色
    fill(50, 20, 100);  // 深色建筑物
    rect(i * spaceBetweenBuildings, height - buildingHeight, buildingWidth, buildingHeight);  // 绘制建筑物
    
    // 绘制窗户
    fill(255, 255, 0);  // 黄色窗户
    for (let j = height - buildingHeight + 10; j < height - 10; j += 30) {
      for (let k = i * spaceBetweenBuildings + 10; k < i * spaceBetweenBuildings + buildingWidth - 10; k += 20) {
        rect(k, j, 10, 10);  // 绘制一个窗户
      }
    }
  }
}

// 绘制红色桥梁的函数
function drawBridge() {
  fill(255, 0, 0);  // 设置桥梁颜色为红色
  let bridgeHeight = 50;      // 桥梁高度
  let supportHeight = 250;    // 支撑柱高度
  
  // 设置桥梁轮廓的描边颜色和宽度
  stroke(255, 0, 0);      // 红色描边
  strokeWeight(5);        // 描边线条宽度为5
  
  // 绘制桥梁支撑柱（垂直矩形）
  rect(0, 250, 800, 20);      // 主桥梁支撑
  rect(275, 80, 5, 170);      // 左支撑柱
  rect(525, 80, 5, 170);      // 右支撑柱
  rect(25, 80, 5, 170);       // 左外支撑柱
  rect(775, 80, 5, 170);      // 右外支撑柱
  rect(25, 80, 750, 2);       // 顶部支撑柱
  
  // 绘制桥梁轮廓的线条
  line(30, 80, 0, 120);
  line(150, 250, 25, 80);  
  line(275, 80, 150, 250); 
  line(400, 250, 275, 80);
  line(525, 80, 400, 250);
  line(650, 250, 525, 80); 
  line(775, 80, 650, 250); 
  line(800, 120, 775, 80);
  
  // 绘制完桥梁后，关闭描边
  noStroke();
}

// 绘制波浪的函数
function drawWaves() {
  // 第一波浪 - 深蓝色
  fill(0, 0, 128);  // 深蓝色
  beginShape();
  
  // 从画布左边开始
  vertex(0, height);  // 左下角
  
  // 绘制第一波浪（深蓝色）
  for (let x = 0; x < width; x += 1) {  // 减少步长以获得更平滑的波浪
    let waveOffset = mouseX * 0.05;  // 用鼠标X控制波浪的移动
    let y = height / 2 + 75  + sin(TWO_PI * (x / width) * 4 + waveOffset) * 50;
    vertex(x, y);  // 根据正弦波添加点
  }
  
  // 结束于画布右边
  vertex(width, height);  // 右下角
  
  endShape(CLOSE);  // 关闭形状并填充颜色

  // 第二波浪 - 浅蓝色（相反方向）
  fill(170, 210, 230);  // 浅蓝色
  beginShape();
  
  // 从画布左边开始
  vertex(0, height);  // 左下角
  
  // 绘制第二波浪（浅蓝色）
  for (let x = 0; x < width; x += 1) {  // 减少步长以获得更平滑的波浪
    let waveOffset = mouseX * -0.05;  // 第二波浪方向相反
    let y = height / 2 + 75 + sin(TWO_PI * (x / width) * 4 + waveOffset) * 50;
    vertex(x, y);  // 根据正弦波添加点
  }
  
  // 结束于画布右边
  vertex(width, height);  // 右下角
  
  endShape(CLOSE);  // 关闭形状并填充颜色
  
  // 第三波浪 - 深蓝色
  fill(0, 0, 130);  // 深蓝色
  beginShape();
  
  // 从画布左边开始
  vertex(0, height);  // 左下角
  
  // 绘制第三波浪（深蓝色）
  for (let x = 0; x < width; x += 1) {  // 减少步长以获得更平滑的波浪
    let waveOffset = mouseX * 0.1;  // 用鼠标X控制波浪的移动
    let y = height / 2 + 100 + sin(TWO_PI * (x / width) * 4 + waveOffset) * 50;
    vertex(x, y);  // 根据正弦波添加点
  }
  
  // 结束于画布右边
  vertex(width, height);  // 右下角
  
  endShape(CLOSE);  // 关闭形状并填充颜色

  // 第四波浪 - 浅蓝色（相反方向）
  fill(100, 130, 240);  // 浅蓝色
  beginShape();
  
  // 从画布左边开始
  vertex(0, height);  // 左下角
  
  // 绘制第四波浪（浅蓝色）
  for (let x = 0; x < width; x += 1) {  // 减少步长以获得更平滑的波浪
    let waveOffset = mouseX * -0.1;  // 第四波浪方向相反
    let y = height / 2 + 100 + sin(TWO_PI * (x / width) * 4 + waveOffset) * 50;
    vertex(x, y);  // 根据正弦波添加点
  }
  
  // 结束于画布右边
  vertex(width, height);  // 右下角
  
  endShape(CLOSE);  // 关闭形状并填充颜色
}

