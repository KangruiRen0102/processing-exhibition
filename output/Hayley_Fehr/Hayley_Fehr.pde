int numStars = 500;
Star[] stars = new Star[numStars];

float t = 0;
int stopFrame = 200;
ArrayList<Circle> circles = new ArrayList<Circle>();
ArrayList<Circle2> circles2 = new ArrayList<Circle2>();
ArrayList<Circle3> circles3 = new ArrayList<Circle3>();

// Wave class to encapsulate properties and behavior of a single wave
class Wave {
  float amplitude;
  float wavelength;
  float speed;
  float phase;
  color waveColor;
  float yOffset;

  Wave(float amplitude, float wavelength, float speed, color waveColor, float yOffset) {
    this.amplitude = amplitude;
    this.wavelength = wavelength;
    this.speed = speed;
    this.waveColor = waveColor;
    this.yOffset = yOffset;
    this.phase = 0;
  }

  void update() {
    phase += speed;
  }

  float computeY(float x) {
    return amplitude * sin(TWO_PI * x / wavelength + phase);
  }

  void display() {
    noStroke();
    fill(waveColor);
    for (float x = 0; x < width; x += 2) {
      float y = yOffset + computeY(x);
      ellipse(x, y, 16, 16);
    }
  }
}

ArrayList<Wave> waves;

void setup() {
  size(1000, 1000);
  waves = new ArrayList<Wave>();
  for (int i = 0; i < numStars; i++) {
    stars[i] = new Star();
  }

  for(int i = 1; i < 7; i++) {
    waves.add(new Wave(10, 130, 0.05, color(0,74,130), 500 + i*75));
    waves.add(new Wave(15, 110, 0.03, color(0,102,179), 505 + i*75)); 
    waves.add(new Wave(10, 90, 0.05, color(0,130,228), 515 + i*75));
    waves.add(new Wave(25, 130, 0.02, color(22,155,255), 530 + i*75)); 
    waves.add(new Wave(20, 110, 0.03, color(71,176,255), 535 + i*75));
    waves.add(new Wave(15, 90, 0.05, color(120,197,255), 545 + i*75));
    waves.add(new Wave(15, 130, 0.02, color(169,218,255), 550 + i*75));
    waves.add(new Wave(10, 110, 0.03, color(218,239,254), 560 + i*75));
  }

  background(0);
}

void draw() {
  background(266);
  translate(width / 2, height / 2);


  if (t % 1 == 0 && t < stopFrame) {
    circles.add(new Circle(0));
    circles2.add(new Circle2(-width / 2));
    circles3.add(new Circle3(width / -4));
  }
  
    for (Circle3 circle3 : circles3) {
    circle3.move();
    circle3.display();
  }

  for (Circle circle : circles) {
    circle.move();
    circle.display();
  }

  for (Circle2 circle2 : circles2) {
    circle2.move();
    circle2.display();
  }

  t += 1;

  translate(-width / 2, -height / 2);
  for (Star s : stars) {
    s.display();
  }

  fill(0,46,81);
  rect(0, 650, 1000, 500);
  
  for (Wave wave : waves) {
    wave.update();
    wave.display();
  }

}

class Star {
  float x, y;
  float brightness;
  float size;
  
  Star() {
    x = random(width);
    y = random(height);
    brightness = random(100, 255);
    size = random(1, 3);
  }
  
  void display() {
    float d = dist(mouseX, mouseY, x, y);
    if (d < 50) {
      stroke(brightness);
      strokeWeight(size * 2);
    } else {
      stroke(150);
      strokeWeight(size);
    }
    point(x, y);
  }
}

class Circle {
  float d, f;
  float speed = 2;

  Circle(float startX) {
    this.d = startX;
    this.f = getYPosition1(startX);
  }

  void move() {
    d += speed;
    f = getYPosition1(d);
  }

  void display() {
    noStroke();
    fill(179, 253, 0, 230);
    ellipse(d, f, 10, 10);
    fill(97, 204, 0, 210);
    ellipse(d, f - 8, 10, 10);
    fill(97, 204, 0, 190);
    ellipse(d, f - 16, 10, 10);
    fill(97, 204, 0, 170);
    ellipse(d, f - 24, 10, 10);
    fill(59, 178, 10, 150);
    ellipse(d, f - 32, 10, 10);
    fill(59, 178, 10, 130);
    ellipse(d, f - 40, 10, 10);
    fill(59, 178, 10, 110);
    ellipse(d, f - 48, 10, 10);
    fill(59, 178, 10, 90);
    ellipse(d, f - 56, 10, 10);
    fill(0, 154, 0, 70);
    ellipse(d, f - 64, 10, 10);
    fill(0, 154, 0, 50);
    ellipse(d, f - 72, 10, 10);
  }
}

class Circle2 {
  float d, f;
  float speed = 2;

  Circle2(float startX) {
    this.d = startX;
    this.f = getYPosition2(startX);
  }

  void move() {
    d += speed;
    f = getYPosition2(d);
  }

  void display() {
    noStroke();
    fill(0, 223, 150, 230);
    ellipse(d, f, 10, 10);
    fill(0, 198, 144, 210);
    ellipse(d, f - 8, 10, 10);
    fill(0, 198, 144, 190);
    ellipse(d, f - 16, 10, 10);
    fill(0, 207, 82, 170);
    ellipse(d, f - 24, 10, 10);
    fill(0, 207, 82, 150);
    ellipse(d, f - 32, 10, 10);
    fill(0, 207, 82, 130);
    ellipse(d, f - 40, 10, 10);
    fill(25, 100, 106, 110);
    ellipse(d, f - 48, 10, 10);
    fill(25, 100, 106, 90);
    ellipse(d, f - 56, 10, 10);
    fill(25, 100, 106, 70);
    ellipse(d, f - 64, 10, 10);
    fill(3, 46, 62, 50);
    ellipse(d, f - 72, 10, 10);
  }
}

class Circle3 {
  float d, f;
  float speed = 2;

  Circle3(float startX) {
    this.d = startX;
    this.f = getYPosition3(startX);
  }

  void move() {
    d += speed;
    f = getYPosition3(d);
  }

  void display() {
    noStroke();
    fill(14, 243, 197, 230);
    ellipse(d, f, 10, 10);
    fill(4, 226, 183, 210);
    ellipse(d, f - 8, 10, 10);
    fill(4, 226, 183, 190);
    ellipse(d, f - 16, 10, 10);
    fill(3, 130, 152, 170);
    ellipse(d, f - 24, 10, 10);
    fill(3, 130, 152, 150);
    ellipse(d, f - 32, 10, 10);
    fill(3, 130, 152, 130);
    ellipse(d, f - 40, 10, 10);
    fill(1, 82, 104, 110);
    ellipse(d, f - 48, 10, 10);
    fill(1, 82, 104, 90);
    ellipse(d, f - 56, 10, 10);
    fill(3, 46, 62, 70);
    ellipse(d, f - 64, 10, 10);
    fill(3, 46, 62, 50);
    ellipse(d, f - 72, 10, 10);
  }
}

float getYPosition1(float d) {
  return 230 * sin((1.0 / 70) * d) -6.5 * sin((1.0 / 840) * 8 * d) + cos((1.0 / 500) * 2 * d) + 196 * cos((1.0 / 250) * 5 * d) -200;
}

float getYPosition2(float d) {
  return 345 * sin((1.0 / 234) * d) + 23 * cos((1.0 / 34) * d) -110;
}

float getYPosition3(float d) {
  return 345*\sin((1.0/2474)*d-23)+23*\cos((1.0/86)*d)-510;
}
