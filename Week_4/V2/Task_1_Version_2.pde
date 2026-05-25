PImage img;
PGraphics overlay;
float angle = 0;
float noiseTime = 0; 

void setup() {
  size(800, 800, P3D);
  img = loadImage("moon.jpg"); 
  
  textureMode(NORMAL); 
  
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
  fill(255, 200); 
  
  drawWarpedSphere(100, img, noiseTime);
  pop();

  angle += 0.01; 
  noiseTime += 0.02; 

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

void drawWarpedSphere(float baseRadius, PImage t, float time) {
  int detail = 40;         
  float noiseScale = 0.02; 
  float warpAmount = 25;   

  for (int i = 0; i < detail; i++) {
    float lat1 = map(i, 0, detail, 0, PI);
    float lat2 = map(i + 1, 0, detail, 0, PI);
    
    float v1 = map(i, 0, detail, 0, 1);
    float v2 = map(i + 1, 0, detail, 0, 1);

    beginShape(QUAD_STRIP);
    texture(t);

    for (int j = 0; j <= detail; j++) {
      float lon = map(j, 0, detail, 0, TWO_PI);
      
      float u = map(j, 0, detail, 0, 1);

      float x1 = sin(lat1) * cos(lon);
      float y1 = cos(lat1);
      float z1 = sin(lat1) * sin(lon);

      float n1 = noise(x1 * baseRadius * noiseScale, y1 * baseRadius * noiseScale, z1 * baseRadius * noiseScale + time);
      float r1 = baseRadius + map(n1, 0, 1, -warpAmount, warpAmount);

      vertex(x1 * r1, y1 * r1, z1 * r1, u, v1);

      float x2 = sin(lat2) * cos(lon);
      float y2 = cos(lat2);
      float z2 = sin(lat2) * sin(lon);

      float n2 = noise(x2 * baseRadius * noiseScale, y2 * baseRadius * noiseScale, z2 * baseRadius * noiseScale + time);
      float r2 = baseRadius + map(n2, 0, 1, -warpAmount, warpAmount);

      vertex(x2 * r2, y2 * r2, z2 * r2, u, v2);
    }
    endShape();
  }
}