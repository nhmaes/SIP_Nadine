import processing.video.*;
import gifAnimation.*;
import processing.sound.*;

Capture cam;
PImage frameIMG;
PImage buttonIMG;

SinOsc bounceOsc;

char darkChar = '•';
char lightChar = ' ';

int resolution = 3;
float threshold = 120;

int btnSize;
float btnX, btnY;

float angle;


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

  bounceOsc = new SinOsc(this);
  bounceOsc.freq(880);
  bounceOsc.amp(0);
  bounceOsc.play();
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

    // Draw status box to show the camera is active, with no tracking enabled.
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
    text("you have a lovely smile!", bx + 12, by + 18);
    textSize(resolution * 5);
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
    playBounceSound();
  }
}

void playBounceSound() {
  float freq = random(650, 950);
  bounceOsc.freq(freq);
  bounceOsc.amp(0.7);
  delay(80);
  bounceOsc.amp(0);
}

