import processing.core.PApplet;

public class MatthewZiolkowski extends PApplet {

    public static void main(String[] args) {
        PApplet.main("MatthewZiolkowski");
    }

    public void settings() {
        size(800, 600); // Set the canvas size
    }

    public void setup() {
        background(30, 40, 80); // Night-sky-like background
        noStroke();
    }

    public void draw() {
        drawHometown(); // Draw the rooted hometown
        drawSun();      // Draw the nurturing sun (Mother)
        drawTree();     // Draw the growing tree
        noLoop();       // Stop continuous drawing
    }

    void drawHometown() {
        fill(100, 60, 40); // Brown for the ground
        rect(0, height - 100, width, 100); // Ground as foundation
        
        // Draw small houses to represent the hometown
        for (int i = 50; i < width; i += 150) {
            fill(200, 150, 100);
            rect(i, height - 140, 100, 40); // House base
            fill(150, 50, 50);
            triangle(i, height - 140, i + 50, height - 180, i + 100, height - 140); // Roof
        }
    }

    void drawSun() {
        fill(255, 200, 50, 150); // Warm yellow
        for (int r = 200; r > 0; r -= 20) {
            ellipse(width / 2, 100, r, r); // Concentric circles for the sun
        }
    }

    void drawTree() {
        // Draw the trunk
        fill(80, 50, 30);
        rect(width / 2 - 25, height - 300, 50, 200); // Tree trunk
        
        // Draw branches and leaves
        for (int i = 0; i < 200; i++) {
            float x = random(width / 2 - 100, width / 2 + 100);
            float y = random(height - 400, height - 300);
            float size = random(10, 20);
            fill(random(50, 150), random(200, 255), random(50, 150), 200); // Random green shades
            ellipse(x, y, size, size);
        }
    }
}
