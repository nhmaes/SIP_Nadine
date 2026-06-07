void setup() {
  size(800, 800);
  background(255);
  rectMode(CENTER);

}

void draw() {
  int spacing = 40;
  int count = 0;
  
  for (int x = spacing; x < width; x += spacing) {
    for (int y = spacing; y < height; y += spacing) {
      
      float r = map(x, 0, width, 50, 255); 
      float g = map(y, 0, height, 50, 200);
      float b = map(x + y, 0, width + height, 255, 100);
      
      fill(r, g, b, 200);
      noStroke();
      
      float size = map(x + y, 0, width + height, 10, 45);
      
      int shapeType = count % 3; // Modulo creates the 0, 1, 2 pattern
      
      pushMatrix();
      translate(x, y);
      
      rotate(dist(x, y, width/2, height/2) * 0.01);
      
      if (shapeType == 0) {
        ellipse(0, 0, size, size);
      } else if (shapeType == 1) { // Fixed 'T' in shapeType
        rect(0, 0, size * 0.8, size * 0.8);
      } else {
        triangle(-size/2, size/2, 0, -size/2, size/2, size/2); 
      }
      popMatrix();
        
      count++;
      
    }
  }
} 