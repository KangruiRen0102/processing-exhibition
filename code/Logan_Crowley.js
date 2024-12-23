let t = 0; // 时间变量用于动画

function setup() {
  createCanvas(800, 800);
  smooth();
}

function draw() {
  background(0); // 黑色背景作为阴影

  // 无限符号图案
  translate(width / 2, height / 2);
  noFill();
  
  for (let i = 0; i < 30; i++) {
    stroke(lerpColor(color(50, 50, 100), color(200, 200, 255), sin(t + i * 0.3) * 0.5 + 0.5));
    strokeWeight(2);
    beginShape();
    for (let a = 0; a < TWO_PI; a += 0.1) {
      let r = 200 + 50 * sin(6 * a + t + i * 0.15); // 增加振幅以产生更显著效果
      let x = r * cos(a);
      let y = r * sin(a) * cos(a); // 无限符号公式
      vertex(x, y);
    }
    endShape(CLOSE);
  }

  // 希望的脉动光
  noStroke();
  for (let i = 50; i > 0; i--) {
    let brightness = i / 50;
    fill(lerpColor(color(255, 200, 50), color(255, 50, 50), brightness), 150 - i * 3);
    ellipse(0, 0, i * 10 * abs(sin(t * 1.5)), i * 10 * abs(sin(t * 1.5))); // 更快和更大的脉动
  }

  t += 0.05; // 时间增量
}
