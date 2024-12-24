// 全局变量
let numStars = 30; // 星星数量
let stars = []; // 存储星星的位置
let auroraLines = 10; // 极光线条初始数量
let initialAuroraLines = 10; // 按下R键重置时的极光线条数量
let auroraColors = []; // 每条极光的颜色数组
let celestialX = 0; // 太阳或月亮的水平位置
let celestialY; // 太阳或月亮的垂直位置
let celestialSpeed = 3; // 太阳和月亮的移动速度
let arcHeight = 200; // 太阳和月亮的轨迹高度
let arcStartY = 250; // 轨迹起始垂直位置
let isSun = false; // 当前是太阳还是月亮
let celestialSize = 80; // 太阳和月亮的大小
let auroraOpacity = 255; // 极光的初始透明度
let isEclipse = false; // 是否发生日食

// 颜色定义
let skyBlue, sunsetOrange, nightBlue, oceanDay, oceanNight, eclipseColor, eclipseWater;

function setup() {
  createCanvas(800, 600); // 画布大小
  noStroke();
  smooth();

  // 初始化颜色
  skyBlue = color(135, 206, 250);
  sunsetOrange = color(255, 140, 0);
  nightBlue = color(10, 20, 50);
  oceanDay = color(70, 130, 180);
  oceanNight = color(0, 0, 128);
  eclipseColor = color(0);
  eclipseWater = oceanNight;

  // 初始化极光颜色
  initializeAuroraColors();

  // 随机生成星星的位置
  for (let i = 0; i < numStars; i++) {
    let starX = random(width); // 随机x坐标
    let starY = random(height / 2); // 随机y坐标（只在画布上半部分）
    stars.push(createVector(starX, starY));
  }
}

function draw() {
  // 根据当前状态设置背景和海洋颜色
  let currentBackground, currentOcean;
  let transitionSpeed = 0.5;
  let transitionFactor = map(celestialX, 0, width, 0, 1);
  transitionFactor = min(transitionFactor + transitionSpeed, 1);

  if (isEclipse) {
    currentBackground = color(0);
    currentOcean = eclipseWater;
  } else if (isSun) {
    currentBackground = lerpColor(sunsetOrange, skyBlue, transitionFactor);
    currentOcean = oceanDay;
    auroraOpacity = 0;
  } else {
    currentBackground = lerpColor(sunsetOrange, nightBlue, transitionFactor);
    currentOcean = oceanNight;
    auroraOpacity = 255;
  }

  // 绘制天空和海洋
  drawGradientSky(currentBackground, currentOcean);

  // 绘制极光（只有在夜晚且没有日食时显示）
  if (!isEclipse && auroraOpacity > 0) {
    drawAurora();
    drawAuroraReflection();
  }

  // 更新太阳和月亮的位置
  updateCelestialPosition();

  // 绘制太阳或月亮
  if (isEclipse) {
    drawGlow(celestialX, celestialY, 65, color(255, 100, 0));
    drawCelestial(celestialX, celestialY, color(0)); // 黑色太阳
    drawReflection(celestialX, celestialY, color(0));
  } else {
    if (isSun) {
      drawCelestial(celestialX, celestialY, color(255, 255, 0));
      drawReflection(celestialX, celestialY, color(255, 255, 0));
    } else {
      drawCelestial(celestialX, celestialY, color(200, 200, 255));
      drawReflection(celestialX, celestialY, color(200, 200, 255));
    }
  }

  // 绘制星星（仅夜晚显示）
  if (!isSun && !isEclipse) {
    drawStars();
  }
}

// 绘制渐变天空
function drawGradientSky(backgroundColor, oceanColor) {
  for (let i = 0; i < height / 2; i++) {
    let gradientColor = lerpColor(sunsetOrange, backgroundColor, map(i, 0, height / 2, 0, 1));
    stroke(gradientColor);
    line(0, i, width, i);
  }
  for (let i = height / 2; i < height; i++) {
    stroke(oceanColor);
    line(0, i, width, i);
  }
}

// 更新太阳和月亮的位置
function updateCelestialPosition() {
  celestialX += celestialSpeed;

  // 使用正弦波计算垂直位置
  let sineFactor = sin(map(celestialX, 0, width, 0, PI));
  celestialY = arcStartY - sineFactor * arcHeight;

  // 判断日食
  if (celestialX >= 0 && celestialX < 5 && isSun) {
    isEclipse = random(10) < 1;
  }

  // 从太阳到月亮的过渡
  if (celestialX >= width) {
    celestialX = 0;
    isSun = !isSun;
    isEclipse = false;
  }
}

// 绘制太阳或月亮
function drawCelestial(x, y, celestialColor) {
  noStroke();
  fill(celestialColor, 220);
  ellipse(x, y, celestialSize, celestialSize);

  for (let glow = 1; glow <= 10; glow++) {
    let glowAlpha = isSun ? 50 - glow * 5 : 80 - glow * 8;
    fill(celestialColor, glowAlpha);
    ellipse(x, y, celestialSize + glow * 15, celestialSize + glow * 15);
  }
}

// 绘制反射
function drawReflection(x, y, celestialColor) {
  let reflectionY = height - (y - height / 2) * 0.1;
  noStroke();
  fill(celestialColor, 100);
  ellipse(x, reflectionY, celestialSize * 1.2, celestialSize * 1.2);
}

// 绘制极光
function drawAurora() {
  for (let i = 0; i < auroraLines; i++) {
    let c = auroraColors[i];
    for (let glow = 1; glow <= 15; glow++) {
      stroke(red(c), green(c), blue(c), auroraOpacity - glow * 5);
      noFill();
      beginShape();
      for (let x = 0; x < width; x += 10) {
        let y = noise(x * 0.01, frameCount * 0.01 + i) * height / 2 - glow * 2;
        vertex(x, y);
      }
      endShape();
    }
  }
}

// 绘制极光的反射
function drawAuroraReflection() {
  let reflectionOpacity = auroraOpacity * 0.5;
  for (let i = 0; i < auroraLines; i++) {
    let c = auroraColors[i];
    for (let glow = 1; glow <= 15; glow++) {
      stroke(red(c), green(c), blue(c), reflectionOpacity - glow * 5);
      noFill();
      beginShape();
      for (let x = 0; x < width; x += 10) {
        let y = noise(x * 0.01, frameCount * 0.01 + i) * height / 2 - glow * 2;
        let reflectionY = height - y;
        vertex(x, reflectionY);
      }
      endShape();
    }
  }
}

// 初始化极光颜色
function initializeAuroraColors() {
  auroraColors = [];
  for (let i = 0; i < auroraLines; i++) {
    let choice = int(random(4));
    if (choice === 0) auroraColors.push(color(255, 255, 100));
    else if (choice === 1) auroraColors.push(color(200, 100, 255));
    else if (choice === 2) auroraColors.push(color(255, 100, 100));
    else auroraColors.push(color(100, 255, 100));
  }
}

// 绘制星星及其反射
function drawStars() {
  for (let star of stars) {
    let starSize = random(2, 5);
    fill(255, 255, 255, random(180, 255));
    noStroke();
    ellipse(star.x, star.y, starSize);

    let reflectionY = height - (star.y - height / 2);
    fill(255, 255, 255, random(50, 120));
    ellipse(star.x, reflectionY, starSize * 1.2);
  }
}

// 键盘输入控制
function keyPressed() {
  if (key === ' ') initializeAuroraColors();
  if (key === 'r' || key === 'R') auroraLines = initialAuroraLines;
  if (key === 'm' || key === 'M') auroraLines++;
  if (key === 'n' || key === 'N') auroraLines = max(1, auroraLines - 1);
  if (key === 'p' || key === 'P') celestialSpeed += 0.5;
  if (key === 'o' || key === 'O') celestialSpeed = max(0.1, celestialSpeed - 0.5);
  if ((key === 'e' || key === 'E') && isSun) isEclipse = true;
}
