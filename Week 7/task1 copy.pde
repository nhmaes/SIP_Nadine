import processing.sound.*;
SinOsc sine1;
float freqMod;

void setup() {
  size(640, 360);
  background(255);
    
  // Create the sine oscillator.
  sine1 = new SinOsc(this);

  sine1.play();
}

void draw() {
  // this is another oscillator that we use to control the other one
  // We don't need a Processing Oscillator object for this as we won't play sound directly from it
  // it will periodically change the frequency
  freqMod = sin(float(frameCount) / 30.) + 1;
  println(freqMod);
  sine1.freq(440 * freqMod);
}