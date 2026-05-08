import processing.sound.*;

SinOsc sine1;


float freqMod;

PImage img;

void setup() {
  pixelDensity(1);
  img = loadImage("sampleDOJA.jpg");
  size(800, 1100);
  sine1 = new SinOsc(this);
  sine1.amp(0.2);
  sine1.play();

  
  img.loadPixels();
  
  
   
  for (int y = 0; y < img.height; y++) {
    color[] row = new color[img.width];
    
    for (int x = 0; x < img.width/2; x++) {
      row[x] = img.pixels[y * img.width + x];
    }
    
    color[] sortedAsc = sort(row);
    
    color[] sortedDesc = reverse(sort(row));
    
    for (int x = 0; x < img.width / 2; x++) {
      img.pixels[y * img.width + x] = sortedAsc[x];
    }
    
    for (int x = img.width; x < img.width; x++) {
      img.pixels[y * img.width + x] = sortedDesc[x - img.width];
    }
  }
  
  img.updatePixels();
  image(img, 0, 0);
  save("sorted.png");
}

void draw() {
  
  freqMod = sin(float(frameCount) / 15.0) + 1.0;
  
  
  sine1.freq(440 * freqMod);

  img.updatePixels();
  image(img, freqMod*100*freqMod, freqMod*200*freqMod);
  save("sorted.png");

}