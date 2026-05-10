int gameScreen = 0;

float ballX, ballY;
int ballSize = 20;
int ballColor = color(0);
float gravity = 1;
float ballSpeedVert = 0;
float airFriction = 0.0001;
float friction = 0.1;

color racketColor = color(0);
float racketWidth = 100;
float racketHeight = 10;
int racketBounceRate = 20;
float ballSpeedHorizon = 10;

int maxHealth = 100;
float health = 100;
float healthDecrease = 1;
int healthBarWidth = 60;

int score = 0;

void setup() {
  size (500,500);  
  ballX=width/4;
  ballY=height/5;
  pixelDensity(1);
}

void draw() {
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    drawGameScreen();
  } else if (gameScreen == 2) {
    gameOverScreen();
  }
}

void initScreen() {
  background(0);
  fill(255);
  textAlign(CENTER);
  text("click to play the greatest game of all time y'all", width/2, height/2);
}
void drawGameScreen() {
  background(255);
  drawBall();
  applyGravity();
  keepInScreen();

  drawRacket();

  watchRacketBounce();

  applyHorizontalSpeed();

  drawHealthBar();
}

void drawHealthBar() {
  noStroke();
  fill(236, 240, 241);
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(ballX-(healthBarWidth/2), ballY - 30, healthBarWidth*(health/maxHealth), 5);
}
void decreaseHealth() {
  health -= healthDecrease;
  if (health <= 0) {
    health = 0;
    gameScreen = 2;
  }
}



void applyHorizontalSpeed() {
    ballX += ballSpeedHorizon;
    ballSpeedHorizon -= (ballSpeedHorizon * airFriction);
}

void makeBounceLeft(float surface){
  ballX = surface+(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}
void makeBounceRight(float surface){
  ballX = surface-(ballSize/2);
  ballSpeedHorizon*=-1;
  ballSpeedHorizon -= (ballSpeedHorizon * friction);
}

void watchRacketBounce() {
  if (ballSpeedVert > 0 &&
      ballX + ballSize/2 > mouseX - racketWidth/2 &&
      ballX - ballSize/2 < mouseX + racketWidth/2 &&
      ballY + ballSize/2 >= mouseY - racketHeight/2 &&
      ballY + ballSize/2 <= mouseY + racketHeight/2 + abs(ballSpeedVert)) {
    makeBounceBottom(mouseY - racketHeight/2);
    float overhead = mouseY - pmouseY;
    if (overhead < 0) {
      ballSpeedVert += overhead * 0.2;
    }
  }
}

void drawRacket(){
  fill(racketColor);
  rectMode(CENTER);
  rect(mouseX, mouseY, racketWidth, racketHeight);
}

void gameOverScreen() {
  background(0);
  textAlign(CENTER);
  fill(255);
  textSize(30);
  text("Game Over", width/2, height/2 - 20);
  textSize(15);
  text("Click to Restart", width/2, height/2 + 10);
}




void startGame() {
  gameScreen=1;
}

void drawBall() {
    fill(ballColor);
    ellipse(ballX, ballY, ballSize, ballSize);

}

void applyGravity() {
    ballSpeedVert += gravity;
    ballY += ballSpeedVert;
    ballSpeedVert -= (ballSpeedVert * airFriction);
}

void makeBounceBottom(float surface) {
  ballY = surface-(ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}
void makeBounceTop(float surface) {
  ballY = surface+(ballSize/2);
  ballSpeedVert*=-1;
  ballSpeedVert -= (ballSpeedVert * friction);
}

void keepInScreen() {
  if (ballY+(ballSize/2) > height) {
    makeBounceBottom(height);
    decreaseHealth();
  }

  if (ballY-(ballSize/2) < 0) {
    makeBounceTop(0);
  }

  if (ballX-(ballSize/2) < 0) {
    makeBounceLeft(0);
  }

  if (ballX+(ballSize/2) > width) {
    makeBounceRight(width);
  }
}

void mousePressed() {
  if (gameScreen == 0) {
    startGame();
  } else if (gameScreen == 2) {
    restart();
  }
}

void restart() {
  score = 0;
  health = maxHealth;
  ballX = width/4;
  ballY = height/5;
  ballSpeedVert = 0;
  ballSpeedHorizon = 10;
  gameScreen = 0;
}