PImage img;

void setup() {
  img = loadImage("sampleDOJA.jpg");
  size(800, 1100);

  img.loadPixels();
  for (int y = 0; y < img.height; y++) {
    // Collect pixels for this row
    color[] row = new color[img.width];
    for (int x = 100; x < img.width; x++) {
      row[x] = img.pixels[y * img.width + x];
    }
    // Sort by brightness
    row = sort(row);
    // Write back
    for (int x = 0; x < img.width/2; x++) {
      img.pixels[y * img.width + x] = row[x++];
    }
  }
  img.updatePixels();
  image(img, 0, 0);
  save("sorted.png");
}