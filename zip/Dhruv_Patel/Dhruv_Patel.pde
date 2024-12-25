void setup() {
  size(800, 800);
  noStroke();
  frameRate(30);
}

void draw() {
  background(0, 10); // Subtle fading effect for whispering aurora
  
  float time = millis() * 0.001; // Dynamic variable for smooth transitions
  for (int i = 0; i < 10; i++) {
    float x = width * noise(i * 0.1, time);
    float y = height * noise(i * 0.1, time + 100);
    float r = 150 + 100 * noise(i * 0.2, time + 200);
    
    int hue = (int)(time * 50 + i * 36) % 360; // Cycle through hues
    fill(colorFromHue(hue, 0.8, 0.9));
    ellipse(x, y, r, r);
  }
}

color colorFromHue(float h, float s, float b) {
  h = h % 360;
  s = constrain(s, 0, 1);
  b = constrain(b, 0, 1);
  float c = b * s;
  float x = c * (1 - abs((h / 60) % 2 - 1));
  float m = b - c;
  
  float r = 0, g = 0, bl = 0;
  if (h < 60)      { r = c; g = x; bl = 0; }
  else if (h < 120) { r = x; g = c; bl = 0; }
  else if (h < 180) { r = 0; g = c; bl = x; }
  else if (h < 240) { r = 0; g = x; bl = c; }
  else if (h < 300) { r = x; g = 0; bl = c; }
  else              { r = c; g = 0; bl = x; }
  
  return color((r + m) * 255, (g + m) * 255, (bl + m) * 255);
}
