// ========== 全局变量 ==========
let age = 34;
let img;

// ========== 预加载函数 ==========
function preload() {
  img = loadImage("uploads/B2.jpg"); // 确保图像路径正确
}

// ========== 设置函数 ==========
function setup() {
  createCanvas(500, 500);
  img.resize(50, 50); // 调整图像大小为 50x50 像素
}

// ========== 主绘制循环 ==========
function draw() {
  background(255); // 设置背景为白色
  
  fill(0);        // 设置填充颜色为黑色
  noStroke();     // 关闭描边
  
  // 根据鼠标X位置计算瓦片数量，确保至少为1
  let tiles = mouseX / 10;
  tiles = tiles > 0 ? tiles : 1;
  
  let tileSize = width / tiles; // 计算每个瓦片的大小
  
  translate(tileSize / 2, tileSize / 2); // 平移画布原点
  
  // 遍历每个瓦片
  for (let x = 0; x < tiles; x++) {
    for (let y = 0; y < tiles; y++) {
      
      // 获取图像对应位置的颜色，确保坐标在图像范围内
      let imgX = constrain(int(x * tileSize), 0, img.width - 1);
      let imgY = constrain(int(y * tileSize), 0, img.height - 1);
      let c = img.get(imgX, imgY);
      
      // 根据颜色亮度映射椭圆大小
      let ellipseSize = map(brightness(c), 0, 255, 20, 0);
      
      // 绘制椭圆（根据需要使用动态大小）
      ellipse(x * tileSize, y * tileSize, ellipseSize, ellipseSize);
      
      // 如果希望保持固定大小，使用以下代码：
      // ellipse(x * tileSize, y * tileSize, 30, 30);
    }
  }
}
