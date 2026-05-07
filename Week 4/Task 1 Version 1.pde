PImage img;
PGraphics overlay;
float angle = 0;

void setup() {
  size(800, 800, P3D);
  img = loadImage("moon.jpg"); 
  
  overlay = createGraphics(800, 800);
  overlay.beginDraw();
  overlay.textFont(createFont("Arial", 12));
  overlay.endDraw();
}

void draw() {
  background(0);
  
  hint(DISABLE_DEPTH_TEST);
  drawRadialGradient(400, 0, 400, color(137, 207, 240, 80), color(255, 255, 240, 50));
  hint(ENABLE_DEPTH_TEST);

  push();
  ambientLight(50, 50, 50);
  directionalLight(255, 255, 200, 0, 1, 0); 

  translate(width/2, height/2 + 200, 0); 
  rotateY(angle);
  
  noStroke();
  fill(255, 200); // Tint for the texture
  
  drawTexturedSphere(100, img);
  pop();

  angle += 0.01; 

  overlay.beginDraw();
  overlay.clear();
  overlay.fill(255, 255, 100);
  overlay.text("(" + mouseX + ", " + mouseY + ")", mouseX, mouseY);
  overlay.endDraw();
  
  hint(DISABLE_DEPTH_TEST);
  image(overlay, 0, 0);
  hint(ENABLE_DEPTH_TEST);
}

void drawRadialGradient(float x, float y, float radius, color c1, color c2) {
  noStroke();
  ellipseMode(RADIUS);
  for (float r = radius; r > 0; r -= 2) {
    float inter = map(r, 0, radius, 0, 1);
    color c = lerpColor(c1, c2, inter);
    fill(c);
    circle(x, y, r);
  }
}

void drawTexturedSphere(float r, PImage t) {
  PShape s = createShape(SPHERE, r);
  s.setTexture(t);
  s.setStroke(false);
  shape(s);
}