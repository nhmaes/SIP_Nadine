import processing.video.*;
PImage img;
PImage img2;
Capture cam;
PImage cam2;
import gifAnimation.*; // Import the library

GifMaker gifExport;    // Create the GIF object
int storyCounter = 1;

void setup() {
  pixelDensity(1);
  size (800 , 600);
  frameRate(8);
  cam = new Capture(this, 320, 240);
  cam.start();
  img = loadImage("zendaya.png");
  img2 = loadImage("screenshot.png");
  gifExport = new GifMaker(this, "comic-story.gif");
  gifExport.setRepeat(0); // 0 means loop forever
  gifExport.setQuality(10);
  


}

void draw() {
  image(img, 0, -300);
  push();

  pop();
  if (cam.available()) {
    cam.read();}
  image(cam,0, 0); 

  image(cam,480, 360, 320,360); 
 

  loadPixels();

  for (int y = 0; y < cam.height - 1; y++) {
    for (int x = 0; x < cam.width - 1; x++) {
      int i = x + y * width; 
      
      color c = pixels[i];
      float greyValue = (red(c) + green(c) + blue(c)) / 2;
      float newPixelValue = (greyValue > 127) ? 255 : 0;
      
      pixels[i] = color(newPixelValue);
      float error = greyValue - newPixelValue;

      fsDither(y, error); 
    
  }
  }



  updatePixels();

  
  
  
  surface.setTitle("Mouse coords : X: " + mouseX + "  Y: " + mouseY);
  textSize(56);
  fill(138,6,6);
  text("Don't forget to smile! - ZENDAYA", 0, 250);
  
  addNoise();
  filter(POSTERIZE,2);

}



void diffuseError(int i, float error) {
  if (i < pixels.length-1) {
    float nextGreyValue = red(pixels[i+1]);
    pixels[i+1] = color(nextGreyValue + error);
  }
}

void fsDither(int i, float error) {
 

  int[] offsets = {
    1, width-1, width, width+1
  };

  float[] ditherRatios = {
    7/16.0, 3/16.0, 5/16.0, 1/16.0
  };

  

  for (int j = 0; j < offsets.length; j++) {
    int neighbourIndex = i + offsets[j];
    if (neighbourIndex < pixels.length) {
      float neighbourGrey = red(pixels[neighbourIndex]);
      pixels[neighbourIndex] = color(neighbourGrey + (error*ditherRatios[j]));
    }
  }
}

void atkinsonDither(int i, float error) {



  int[] offsets = {
    1, 2, width-1, width, width+1, width*2
  };

  for (int j = 0; j < offsets.length; j++) {
    int neighbourIndex = i + offsets[j];
    if (neighbourIndex < pixels.length) {
      float neighbourGrey = red(pixels[neighbourIndex]);
      pixels[neighbourIndex] = color(neighbourGrey + (error/8.0));
    }
  }
}



void keyPressed() {

  if (key == ENTER || key == RETURN) {
    if (storyCounter <= 10) {
      // 1. Save the individual PNG (keep your current logic)
      saveFrame("comic-panels/panel-" + nf(storyCounter, 2) + ".png");
      
      // 2. Add the current screen to the GIF
      // setDelay(500) means half a second per frame
      gifExport.setDelay(500); 
      gifExport.addFrame();
      
      println("Saved panel " + storyCounter + " of 10!");
      storyCounter++; 
    } 
    
    if (storyCounter > 10) {
      // 3. Finalize the file once you hit the limit
      gifExport.finish(); 
      println("GIF Exported!");
    }
  }
}


void addNoise() {
  for (int i = 0 ; i < 10000; i++) { // Higher number = denser noise
    float x = random(width);
    float y = random(height);
    stroke(random(255), 100); // Random grey with low opacity (50)
    point(x, y);
  }
}

