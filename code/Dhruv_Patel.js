function setup() {
  createCanvas(800, 800);
  noStroke();
  frameRate(30);
}

function draw() {
  background(0, 10); // Subtle fading effect for whispering aurora

  let time = millis() * 0.001; // Dynamic variable for smooth transitions
  for (let i = 0; i < 10; i++) {
    let x = width * noise(i * 0.1, time);
    let y = height * noise(i * 0.1, time + 100);
    let r = 150 + 100 * noise(i * 0.2, time + 200);

    let hue = (time * 50 + i * 36) % 360; // Cycle through hues
    fill(colorFromHue(hue, 0.8, 0.9));
    ellipse(x, y, r, r);
  }
}

function colorFromHue(h, s, b) {
  h = h % 360;
  s = constrain(s, 0, 1);
  b = constrain(b, 0, 1);
  let c = b * s;
  let x = c * (1 - abs((h / 60) % 2 - 1));
  let m = b - c;

  let r = 0, g = 0, bl = 0;
  if (h < 60) {
    r = c; g = x; bl = 0;
  } else if (h < 120) {
    r = x; g = c; bl = 0;
  } else if (h < 180) {
    r = 0; g = c; bl = x;
  } else if (h < 240) {
    r = 0; g = x; bl = c;
  } else if (h < 300) {
    r = x; g = 0; bl = c;
  } else {
    r = c; g = 0; bl = x;
  }

  return color((r + m) * 255, (g + m) * 255, (bl + m) * 255);
}
