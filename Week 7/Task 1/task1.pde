import processing.sound.*;

SinOsc sine1;

SinOsc sine2;

float freqMod;

float freqMod2;

SawOsc oscillator;

LowPass filter;

void setup() {
  size(640, 360);
  pixelDensity(1);
  sine1 = new SinOsc(this);
  sine2 = new SinOsc(this);
  oscillator = new SawOsc(this);
  filter = new LowPass(this);


  sine1.amp(0.2);
  sine2.amp(0.2);
  oscillator.amp(0.2);

  filter.process(oscillator);

  sine1.play();
  sine2.play();
  oscillator.play();
}

void draw() {
  background(freqMod * 100, 100, 200); 
  
  freqMod = sin(float(frameCount) / 15.0) + 1.0;
  
  
  sine1.freq(440 * freqMod);
  
  float cutoff = map(freqMod, 0, 2, 50, 2000); 
  filter.freq(cutoff);
}