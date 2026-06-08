import processing.sound.*;

SoundFile sample1;
SoundFile sample2;

float bpm = 120;

float myFrameRate = bpm / 60; 

void setup() {
    pixelDensity(1);
  size(640, 360);
  background(255);
  sample1 = new SoundFile(this, "sample_plucked_glass.wav");

  sample2 = new SoundFile(this, "YCC_by_CORTIS.mp3");
  frameRate(myFrameRate);
}

void draw() {
  background(random(255), random(255), random(255));
  sample1.play();
  sample2.amp(0.10);
  sample2.play();

  if (frameCount % 4 == 0) {
  sample2.play();
  }
}