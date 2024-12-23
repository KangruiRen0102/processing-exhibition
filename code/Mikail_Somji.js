let hands = []; // 手臂对象列表
let particles = []; // 粒子列表，用于爆炸效果
let activeHand; // 当前活动的手臂
let maxHands = 5; // 最大手臂数量
let isExploding = false; // 是否正在进行爆炸动画
let scaleFactor = 1.0; // 爆炸动画的缩放因子
let particlesReleased = false; // 是否释放了粒子

function setup() {
  createCanvas(600, 600); // 创建画布
  resetDrawing(); // 初始化场景
}

function draw() {
  background(255); // 背景为白色

  if (isExploding) { // 如果处于爆炸动画状态
    if (scaleFactor < 5) { // 缩放因子小于 5 时继续放大
      scaleFactor += 0.04; // 加快缩放速度
      translate(width / 2, height / 2); // 平移到中心点
      scale(scaleFactor); // 应用缩放
      drawScene(); // 绘制场景
    } else {
      if (!particlesReleased) { // 如果粒子尚未释放
        releaseParticles(); // 释放粒子
        particlesReleased = true;
      }

      for (let i = particles.length - 1; i >= 0; i--) { // 更新和显示所有粒子
        let p = particles[i];
        p.update();
        p.display();
        if (p.isDead()) { // 如果粒子已消失，从列表中移除
          particles.splice(i, 1);
        }
      }

      if (particles.length === 0) { // 如果所有粒子都已消失，重置场景
        resetDrawing();
      }
    }
  } else { // 正常模式下绘制场景
    translate(width / 2, height / 2 - 50); // 调整手臂的显示位置
    drawScene();
  }

  if (!isExploding && activeHand.isMoving) { // 如果手臂正在移动，更新角度
    activeHand.angle = atan2(mouseY - height / 2 + 50, mouseX - width / 2);
  }
}

function drawScene() {
  // 黑色圆圈
  fill(0);
  noStroke();
  ellipse(0, 0, 180 * 2, 180 * 2);

  // 圆圈上的 "INFINITY"
  fill(255);
  textSize(14);
  let textRadius = 140;
  let repetitions = 6;
  let totalArc = TWO_PI / repetitions;

  for (let j = 0; j < repetitions; j++) {
    let startAngle = j * totalArc;
    for (let i = 0; i < 8; i++) {
      let letter = "INFINITY".charAt(i);
      let letterAngle = startAngle + i * (totalArc / 8);
      let x = cos(letterAngle) * textRadius;
      let y = sin(letterAngle) * textRadius;

      push();
      translate(x, y);
      rotate(letterAngle + HALF_PI);
      text(letter, 0, 0);
      pop();
    }
  }

  // 显示所有手臂
  for (let h of hands) {
    h.drawHand();
  }

  // 显示活动的手臂
  activeHand.drawHand();

  // 显示 "CHAOS" 文本，动态显示每个字母
  let visibleLetters = Math.min(hands.length + 1, "CHAOS".length);
  textSize(48);
  fill(255, 0, 0);
  textAlign(CENTER, CENTER);
  translate(0, 50); // 调整位置，使其在手臂下方显示
  text("CHAOS".substring(0, visibleLetters), 0, 0);

  if (!isExploding && visibleLetters === "CHAOS".length) {
    startExplosion();
  }
}

function mousePressed() {
  if (isExploding) return; // 爆炸期间忽略交互

  if (activeHand.isMoving) {
    activeHand.isMoving = false;
    hands.push(activeHand);

    if (hands.length > maxHands) {
      hands = [];
    }

    activeHand = new Hand(-HALF_PI, random(20, 100), color(random(255), random(255), random(255)));
  } else if (activeHand.isClicked(mouseX - width / 2, mouseY - height / 2 + 50)) {
    activeHand.isMoving = true;
  }
}

function resetDrawing() {
  hands = [];
  particles = [];
  activeHand = new Hand(-HALF_PI, 100, color(255));
  isExploding = false;
  scaleFactor = 1.0;
  particlesReleased = false;
}

function startExplosion() {
  isExploding = true;
  scaleFactor = 1.0;
}

function releaseParticles() {
  for (let i = 0; i < 900; i++) {
    let t = random(TWO_PI);
    let speed = random(0.01, 0.05);
    let size = random(3, 8);
    let c = color(random(100, 255), random(100, 255), random(100, 255));
    particles.push(new Particle(width / 2, height / 2, t, speed, c, size));
  }
}

class Hand {
  constructor(angle, length, col) {
    this.angle = angle;
    this.length = length;
    this.col = col;
    this.isMoving = true;
  }

  drawHand() {
    stroke(this.col);
    strokeWeight(6);
    let x = cos(this.angle) * this.length;
    let y = sin(this.angle) * this.length;
    line(0, 0, x, y);
  }

  isClicked(mouseX, mouseY) {
    let handX = cos(this.angle) * this.length;
    let handY = sin(this.angle) * this.length;
    let d = dist(mouseX, mouseY, handX, handY);
    return d < 10;
  }
}

class Particle {
  constructor(x, y, t, speed, col, size) {
    this.originX = x;
    this.originY = y;
    this.t = t;
    this.speed = speed;
    this.col = col;
    this.size = size;
    this.life = 255;
  }

  update() {
    this.t += this.speed;
    let a = 100;
    let x = a * cos(this.t);
    let y = a * sin(2 * this.t) / 2;
    this.originX = width / 2 + x;
    this.originY = height / 2 + y;
    this.life -= 2;
  }

  display() {
    fill(this.col, this.life);
    noStroke();
    ellipse(this.originX, this.originY, this.size, this.size);
  }

  isDead() {
    return this.life <= 0;
  }
}
