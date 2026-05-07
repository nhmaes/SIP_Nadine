let overlay; 
let img;
let angle = 0;

function preload() {
  img = loadImage('moon.jpg'); 
}

function setup() {
  createCanvas(800, 800, WEBGL);
  frameRate(60);
 
  overlay = createGraphics(800, 800);
  overlay.textFont('Arial');
  overlay.textSize(12);
}

function draw() {
  background(0)
  push();
  resetMatrix(); 
  translate(-width / 2, -height / 2); 


  noStroke();
  fill(137, 207, 240, 150); 
  circle(400, 0, 800);

  drawRadialGradient(400, 0, 400, color(137, 207, 240, 80), color(255, 255, 240, 50));

  fill(255, 60, 100, 200);
  stroke(0);
  noFill();
  pop();


  push();
  orbitControl(); 
  ambientLight(50); 
  directionalLight(255, 255, 200, 0, 400, 0); 

  translate(0, 200, 0); 
  rotateY(angle);

  
  fill(255, 255, 255, 200);
  noStroke();
  texture(img);
  sphere(100, 24, 24);
  pop();

  angle += 0.01; 

 
  overlay.clear();
  overlay.fill(255, 255, 100);
  overlay.stroke(0);
  overlay.text("(" + mouseX + ", " + mouseY + ")", mouseX, mouseY);
  image(overlay, -400, -400); 
}

function drawRadialGradient(x, y, radius, c1, c2) {
  noStroke();
  for (let r = radius; r > 0; --r) {
    let inter = map(r, 0, radius, 0, 1);
    let c = lerpColor(c1, c2, inter);
    fill(c);
    circle(x, y, r * 2);
  }
}