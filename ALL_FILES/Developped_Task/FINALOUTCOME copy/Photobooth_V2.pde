import processing.video.*;
import gifAnimation.*;
import processing.sound.*;
import gab.opencv.*;        
import java.awt.Rectangle;  

Capture cam;
OpenCV opencv;             
PImage frameIMG;
PImage buttonIMG;

SinOsc bounceOsc;

int btnSize;
float btnX, btnY;

float angle;

boolean facePresent = false;
boolean eyesPresent = false;
boolean lastEyesPresent = false;

int soundEndTime = 0;

void setup() {
  pixelDensity(1);
  size(841, 595);
  frameRate(15);

  cam = new Capture(this, 841, 595);
  cam.start();

  opencv = new OpenCV(this, 841, 595);

  frameIMG = loadImage("Photobooth_frame.png");
  frameIMG.resize(width, height);
  buttonIMG = loadImage("sewing_button.png");
  btnSize = 70;
  btnX = (width / 2) - 35;
  btnY = height - 80;

  bounceOsc = new SinOsc(this);
  bounceOsc.freq(880);
  bounceOsc.amp(0);
  bounceOsc.play();
}

void draw() {
  if (cam.available()) {
    cam.read();
  }
  
  background(255);

  imageMode(CORNER);
  image(cam, 0, 0);

  if (millis() > soundEndTime) {
    bounceOsc.amp(0);
  }

  // 3. Computer Vision Loop
  if (cam.width > 0 && cam.height > 0) {
    opencv.loadImage(cam);
    
    // Look for Face
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
    Rectangle[] faces = opencv.detect();
    facePresent = (faces.length > 0);
    
    eyesPresent = false; 
    
    if (facePresent) {
      int faceX = faces[0].x;
      int faceY = faces[0].y;
      int faceW = faces[0].width;
      int faceH = faces[0].height;
      
      opencv.setROI(faceX, faceY, faceW, int(faceH * 0.65));
      opencv.loadCascade(OpenCV.CASCADE_EYE);
      
      Rectangle[] eyes = opencv.detect();
      eyesPresent = (eyes.length > 0);
      
      opencv.releaseROI();
    }
    
    if (facePresent && lastEyesPresent && !eyesPresent) {
      triggerPhotoCapture();
    }
    
    lastEyesPresent = eyesPresent;

    int boxW = 240;
    int boxH = 48;
    int bx = width - boxW - 12;
    int by = 120;
    noStroke();
    fill(0, 160);
    rect(bx, by, boxW, boxH, 8);
    fill(255);
    textSize(14);
    textAlign(LEFT, TOP);
    
    if (facePresent) {
      text("Blink to snap a photo!", bx + 12, by + 18);
    } else {
      text("Look here & smile!", bx + 12, by + 18);
    }
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

void triggerPhotoCapture() {
  saveFrame("photobooth-####.png");
  println("Photo Saved Successfully to Sketch Folder!");
  playBounceSound();
}

void mousePressed() {
  float btnCenterX = btnX + (btnSize / 2);
  float btnCenterY = btnY + (btnSize / 2);
  if (dist(mouseX, mouseY, btnCenterX, btnCenterY) < btnSize / 2) {
    triggerPhotoCapture();
  }
}

void playBounceSound() {
  float freq = random(650, 950);
  bounceOsc.freq(freq);
  bounceOsc.amp(0.7);
  soundEndTime = millis() + 120; 
}
