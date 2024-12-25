// ========== 全局变量 ==========
let home;
let highResBackground;

let expandSmallerCircle = false;  // Flag to control the expansion of the smaller circle
let smallerRadius = 40;  // Smaller starting radius of the smaller circle
let largerSize = 300;  // Size of the larger square
let growthSpeed = 1.5;  // Speed at which the smaller circle expands
let time = 0;  // Timer for animation

// ========== 预加载函数 ==========
function preload() {
  // 加载图像，确保路径正确（例如 "upload/home.jpg"）
  home = loadImage("upload/home.jpg", 
    () => {
      console.log("Image loaded successfully.");
    }, 
    () => {
      console.error("Image not loaded. Check file name and location.");
      noLoop(); // 停止绘制循环
    }
  );
}

// ========== 设置函数 ==========
function setup() {
  createCanvas(800, 800);  // Canvas size
  noStroke();

  // 创建离屏图形用于高分辨率背景
  highResBackground = createGraphics(1920, 1080);  // Set higher resolution for background
  home.resize(highResBackground.width, highResBackground.height); // 调整图像大小
  highResBackground.beginDraw();
  highResBackground.image(home, 0, 0);
  highResBackground.endDraw();
}

// ========== 主绘制循环 ==========
function draw() {
  background(255); // 白色背景

  // 显示高分辨率背景图像，缩放到画布大小
  image(highResBackground, 0, 0, width, height);  // Display the high-res background image

  // Center the drawing coordinates
  push();
  translate(width / 2, height / 2);  // Move the origin to the center of the canvas

  // Draw the transparent square with black outline and thicker border
  noFill();  // Remove fill (makes it transparent)
  stroke(0);  // Set the outline color to black
  strokeWeight(5);  // Set a thicker border for the square
  rectMode(CENTER);  // Rectangle centered on the origin
  rect(0, 0, largerSize, largerSize);  // Draw square with larger size

  // Draw the smaller expanding circle
  stroke(200, 100, 50);
  noFill();
  beginShape();
  for (let angle = 0; angle < TWO_PI; angle += 0.1) {
    // If mouse is clicked, the smaller circle grows faster
    let radius = expandSmallerCircle ? smallerRadius + growthSpeed * time : smallerRadius;
    let x = cos(angle) * radius;
    let y = sin(angle) * radius;
    vertex(x, y);
  }
  endShape(CLOSE);

  // Increase time for the smaller circle growth if expanding
  if (expandSmallerCircle) {
    time += 0.05;  // Faster growth after mouse click
  }

  pop();
}

// ========== 鼠标点击事件 ==========
function mousePressed() {
  expandSmallerCircle = true;  // Start expanding the smaller circle
  growthSpeed = 2.5;  // Increase the growth speed after click
}
