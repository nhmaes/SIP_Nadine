void settings() {
  size(800, 600);
  pixelDensity(1);
 noLoop();
}

void draw() {

  color bottomLeft = color(249, 184, 16);
  color bottomRight = color(255,100,100);
  color topLeft = color(93, 155, 214);
  color topRight = color(255, 255, 255);
  color centerColor = color(255,255,255);
  float maxDist = 300;
  float centerX = width/2;
  float centerY = height/2;

  loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      float u = map(x,0, width,0,1);
      float v = map(y,0, height,0,1);
      color topSide = lerpColor(topLeft, topRight, v);
      color bottomSide = lerpColor(bottomLeft,bottomRight,u);
      color bgColor = lerpColor(topSide,bottomSide, v);
      
      //adding circula gradeint on top
      float d = dist(x,y, centerX,centerY);
      float circleAmount = map(d,0, maxDist, 1,0);
      circleAmount = constrain(circleAmount, 0, 1);
      
      pixels[x + y * width] = lerpColor(bgColor, centerColor, circleAmount);
    }
  }
  updatePixels();
}
