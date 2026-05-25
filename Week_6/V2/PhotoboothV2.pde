import processing.video.*;
import gifAnimation.*;

Capture cam;
PImage img, img2;
GifMaker gifExport;
int storyCounter = 1;

void setup() {
  pixelDensity(1);
  size(800, 600);
  frameRate(8);
  
  cam = new Capture(this, 320, 240);
  cam.start();
  
  img = loadImage("zendaya.png");
  img2 = loadImage("screenshot.png");
  
  gifExport = new GifMaker(this, "comic-story.gif");
  gifExport.setRepeat(0);
  gifExport.setQuality(10);
}

void draw() {
  background(0);
  image(img, 0, -300); // Background image

  if (cam.available()) {
    cam.read();
  }
  
  // Draw camera to the small preview and the main panel
  image(cam, 0, 0); 
  image(cam, 480, 360, 320, 360); 

  loadPixels();

  // 1. APPLY PIXEL SORTING (From your first snippet)
  // We apply this to the whole screen or specific rows
  applyPixelSort();

  // 2. APPLY DITHERING (Your current loop)
  for (int y = 0; y < height - 1; y++) {
    for (int x = 0; x < width - 1; x++) {
      int i = x + y * width; 
      color c = pixels[i];
      float greyValue = (red(c) + green(c) + blue(c)) / 3; // Better grayscale math
      float newPixelValue = (greyValue > 127) ? 255 : 0;
      
      pixels[i] = color(newPixelValue);
      float error = greyValue - newPixelValue;
      fsDither(i, error); // Note: changed from y to i to match your function logic
    }
  }

  updatePixels();
  
  // Overlay text and noise
  surface.setTitle("Mouse coords : X: " + mouseX + "  Y: " + mouseY);
  textSize(56);
  fill(138, 6, 6);
  text("Don't forget to smile! - ZENDAYA", 0, 250);
  
  addNoise();
  filter(POSTERIZE, 2);
}

// THE NEW PIXEL SORTING FUNCTION
void applyPixelSort() {
  for (int y = 0; y < height; y++) {
    // We only sort the width of the screen
    color[] row = new color[width];
    for (int x = 0; x < width; x++) {
      row[x] = pixels[y * width + x];
    }
    
    // Sort logic
    color[] sortedAsc = sort(row);
    
    // Apply sorted pixels back to half the screen for that 'glitch' look
    for (int x = 0; x < width / 2; x++) {
      pixels[y * width + x] = sortedAsc[x];
    }
  }
}

// --- DITHERING HELPER FUNCTIONS ---

void fsDither(int i, float error) {
  int[] offsets = { 1, width-1, width, width+1 };
  float[] ditherRatios = { 7/16.0, 3/16.0, 5/16.0, 1/16.0 };

  for (int j = 0; j < offsets.length; j++) {
    int neighbourIndex = i + offsets[j];
    if (neighbourIndex >= 0 && neighbourIndex < pixels.length) {
      float neighbourGrey = red(pixels[neighbourIndex]);
      pixels[neighbourIndex] = color(neighbourGrey + (error * ditherRatios[j]));
    }
  }
}

void addNoise() {
  for (int i = 0 ; i < 10000; i++) {
    float x = random(width);
    float y = random(height);
    stroke(random(255), 100);
    point(x, y);
  }
}

void keyPressed() {
  if (key == ENTER || key == RETURN) {
    if (storyCounter <= 10) {
      saveFrame("comic-panels/panel-" + nf(storyCounter, 2) + ".png");
      gifExport.setDelay(500); 
      gifExport.addFrame();
      println("Saved panel " + storyCounter + " of 10!");
      storyCounter++; 
    } 
    if (storyCounter > 10) {
      gifExport.finish(); 
      println("GIF Exported!");
    }
  }
}