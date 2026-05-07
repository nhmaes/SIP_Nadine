PImage sample;

void setup() {
  size(500, 667);
  sample = loadImage("sampleDOJA.jpg");
  pixelDensity(1);
  sample.loadPixels();
}

void draw() {
  image(sample, 0, 0, width, height);
  
  
  int[] histoRed   = new int[256];
  int[] histoGreen = new int[256];
  int[] histoBlue  = new int[256];

  for (int i = 0; i < sample.pixels.length; i++) {
    histoRed[int(red(sample.pixels[i]))]++;
    histoGreen[int(green(sample.pixels[i]))]++;
    histoBlue[int(blue(sample.pixels[i]))]++;
  }

  int highestCount = max(max(histoRed), max(max(histoGreen), max(histoBlue)));

// draw blue
  for (int i = 0; i < 256; i++) {
    stroke(0, 0, 255);
    float startHeight = map(histoBlue[i], 0, highestCount, height, height - (height / 3));
    line(i, startHeight, i, height);
  }

// draw green
  for (int i = 0; i < 256; i++) {
    stroke(0, 255, 0);
    float startHeight = map(histoGreen[i], 0, highestCount, height, height - (height / 3));
    line(i, startHeight, i, height);
  }

// draw red last (on top)
  for (int i = 0; i < 256; i++) {
    stroke(255, 0, 0);
    float startHeight = map(histoRed[i], 0, highestCount, height, height - (height / 3));
    line(i, startHeight, i, height);
  }
}
 