import processing.video.*;
import gifAnimation.*;

Capture cam;
PImage img;
GifMaker gifExport;
int storyCounter = 1;

// Define your color palette
color scarlettRed = color(187, 10, 30);
color white = color(255, 255, 255);

void setup() {
  pixelDensity(1);
  size(800, 600);
  frameRate(8);
  
  // Camera Setup
  cam = new Capture(this, 320, 240);
  cam.start();
  
  // Load your background image (Ensure this file is in your /data folder)
  img = loadImage("zendaya.png");
  
  // GIF Setup
  gifExport = new GifMaker(this, "comic-story.gif");
  gifExport.setRepeat(0); 
  gifExport.setQuality(10);
}

void draw() {
  background(0);
  
  // 1. Draw Background and Camera feeds
  if (img != null) image(img, 0, -300);

  if (cam.available()) {
    cam.read();
  }
  
  // Place camera feeds
  image(cam, 0, 0); 
  image(cam, 480, 360, 320, 360); 

  // 2. Start Pixel Manipulation
  loadPixels();

  // Apply the Pixel Sorting Dither first
  applyPixelSort();

  // Apply the Scarlett & White Floyd-Steinberg Dithering
  for (int y = 0; y < height - 1; y++) {
    for (int x = 0; x < width - 1; x++) {
      int i = x + y * width; 
      color c = pixels[i];
      
      float greyValue = (red(c) + green(c) + blue(c)) / 3;
      
      color newColor;
      float bitValue; 
      
      // Map to Red and White
      if (greyValue > 127) {
        newColor = white;
        bitValue = 255;
      } else {
        newColor = scarlettRed;
        bitValue = 0;
      }
      
      pixels[i] = newColor;
      
      float error = greyValue - bitValue;
      fsDither(i, error); 
    }
  }

  updatePixels();
  
  // 3. UI Overlays
  surface.setTitle("Mouse coords : X: " + mouseX + "  Y: " + mouseY);
  textSize(56);
  fill(white); // Text in white to pop against red
  text("Don't forget to smile!", 20, 250);
  
  addNoise();
  
  // Note: Posterize is removed to keep your Scarlett Red vibrant
}

// --- PIXEL SORTING LOGIC ---
void applyPixelSort() {
  for (int y = 0; y < height; y++) {
    color[] row = new color[width/2];
    for (int x = 0; x < width/2; x++) {
      row[x] = pixels[y * width + x];
    }
    
    color[] sortedAsc = sort(row);
    
    for (int x = 0; x < width / 2; x++) {
      pixels[y * width + x] = sortedAsc[x];
    }
  }
}

// --- DITHERING MATH ---
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
  for (int i = 0 ; i < 5000; i++) {
    float x = random(width);
    float y = random(height);
    stroke(255, 80); 
    point(x, y);
  }
}

// --- CAPTURE & GIF LOGIC ---
void keyPressed() {
  if (key == ENTER || key == RETURN) {
    if (storyCounter <= 10) {
      // Save panel image
      saveFrame("comic-panels/panel-" + nf(storyCounter, 2) + ".png");
      
      // Add to GIF
      gifExport.setDelay(500); 
      gifExport.addFrame();
      
      println("Saved panel " + storyCounter + " of 10!");
      storyCounter++; 
    } 
    
    if (storyCounter > 10) {
      gifExport.finish(); 
      println("GIF Exported as comic-story.gif!");
    }
  }
}
