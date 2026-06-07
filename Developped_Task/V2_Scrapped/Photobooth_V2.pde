import processing.video.*;
import gifAnimation.*;
import gab.opencv.*;
import java.awt.Rectangle;

Capture cam;
PImage frameIMG;
PImage buttonIMG;

char darkChar = '•';
char lightChar = ' ';

int resolution = 3;
float threshold = 120;

int btnSize;
float btnX, btnY;

float angle;

// OpenCV detector
OpenCV opencv;
boolean opencvReady = false;


void setup() {
  pixelDensity(1);
  size(841, 595);
  frameRate(15);

  cam = new Capture(this, 841, 595);
  cam.start();

  frameIMG = loadImage("Photobooth_frame.png");
  frameIMG.resize(width, height);
  buttonIMG = loadImage("sewing_button.png");
  btnSize = 70;
  btnX = (width / 2) - 35;
  btnY = height - 80;

  PFont mono = createFont("Helvetica", resolution);
  textFont(mono);
  textSize(resolution * 5);

  // initialize OpenCV detector using camera resolution
  String smileCascadePath = dataPath("haarcascade_smile.xml");
  boolean smileCascadeExists = new java.io.File(smileCascadePath).exists();

  if (!smileCascadeExists) {
    println("OpenCV cascade file is missing.");
    println("Put haarcascade_smile.xml into the sketch 'data' folder:");
    println("  " + smileCascadePath);
    println("Smile detection will be disabled.");
    opencvReady = false;
  } else {
    try {
      opencv = new OpenCV(this, cam.width, cam.height);

      // Use the data folder filename, not the absolute path, to ensure Processing resolves it correctly.
      opencv.loadCascade("haarcascade_smile.xml");
      println("Loaded smile cascade from sketch data folder: haarcascade_smile.xml");

      opencvReady = true;
      println("OpenCV ready");
    } catch (Exception e) {
      println("OpenCV smile cascade load error: " + e.getMessage());
      println("Trying built-in mouth cascade instead...");
      try {
        opencv.loadCascade(OpenCV.CASCADE_MOUTH);
        println("Loaded built-in mouth cascade for smile detection.");
        opencvReady = true;
      } catch (Exception ex) {
        println("Failed to load fallback mouth cascade: " + ex.getMessage());
        opencvReady = false;
      }
    }
  }
}

void draw() {
  if (cam.available()) cam.read();
  background(255);

  if (cam.pixels != null && cam.pixels.length > 0) {
    cam.loadPixels();

    for (int y = 0; y < cam.height; y += resolution) {
      for (int x = 0; x < cam.width; x += resolution) {
        int pixelIndex = x + (y * cam.width);
        color pixelColor = cam.pixels[pixelIndex];

        float r = red(pixelColor);
        float g = green(pixelColor);
        float b = blue(pixelColor);

        float brightness = (0.2126 * r) + (0.7152 * g) + (0.0722 * b);

        char ascii = brightness > threshold ? lightChar : darkChar;
        fill(0);
        text(ascii, x, y + resolution);
      }
    }

    boolean smiling = false;

    if (opencvReady) {
      try {
        opencv.loadImage(cam);
        Rectangle[] smiles = opencv.detect();

        if (smiles != null && smiles.length > 0) {
          smiling = true;
        }

        // Optionally draw detection rectangles around detected smiles
        stroke(255, 0, 0);
        noFill();
        if (smiles != null) {
          float sx = (float)width / cam.width;
          float sy = (float)height / cam.height;
          for (Rectangle s : smiles) {
            rect(s.x * sx, s.y * sy, s.width * sx, s.height * sy);
          }
        }
      } catch (Exception e) {
        println("OpenCV detection error: " + e.getMessage());
      }
    }

    // Draw status box on the side opposing the camera (lower right)
    int boxW = 220;
    int boxH = 48;
    int bx = width - boxW - 12;
    int by = 120;
    noStroke();
    fill(0, 160);
    rect(bx, by, boxW, boxH, 8);
    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    String smileStatus = smiling ? "Smiling: Yes" : "Smiling: No";
    text(smileStatus, bx + 12, by + 18);
    textSize(resolution*5);
    textAlign(LEFT, BASELINE);
  }

  imageMode(CORNER);
  image(frameIMG, 0, 0);

  float btnCenterX = btnX + (btnSize / 2);
  float btnCenterY = btnY + (btnSize / 2);

  pushMatrix();
  translate(btnCenterX, btnCenterY);
  rotate(angle);
  imageMode(CENTER);
  image(buttonIMG, 0, 0, btnSize, btnSize);
  popMatrix();

  angle += 0.05;
  if (dist(mouseX, mouseY, btnCenterX, btnCenterY) < btnSize / 2) {
    cursor(HAND);
  } else {
    cursor(ARROW);
  }
}

void mousePressed() {
  if (mouseX >= btnX && mouseX <= btnX + btnSize &&
      mouseY >= btnY && mouseY <= btnY + btnSize) {
    println("Photo Captured!");
    saveFrame("photobooth-####.png");
  }
}

