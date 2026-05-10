int gameScreen = 0;

Ball ball;
color racketColor = color(0);
float racketWidth = 100;
float racketHeight = 10;
int racketBounceRate = 20;

int maxHealth = 100;
float health = 100;
float healthDecrease = 1;
int healthBarWidth = 60;

int score = 0;

void setup() {
  size (500,500);  
  ball = new Ball(width/4, height/5, 20, color(0), 1, 0.0001, 0.1, 10);
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
  ball.update();
  ball.display();
  drawRacket();
  ball.bounceOffRacket(mouseY, racketHeight, mouseY - pmouseY);
  drawHealthBar();
}

void drawHealthBar() {
  noStroke();
  fill(236, 240, 241);
  rectMode(CORNER);
  rect(ball.x-(healthBarWidth/2), ball.y - 30, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  rect(ball.x-(healthBarWidth/2), ball.y - 30, healthBarWidth*(health/maxHealth), 5);
}
void decreaseHealth() {
  health -= healthDecrease;
  if (health <= 0) {
    health = 0;
    gameScreen = 2;
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
  ball.x = width/4;
  ball.y = height/5;
  ball.speedVert = 0;
  ball.speedHorizon = 10;
  gameScreen = 0;
}

class Ball {
  float x, y;
  int size;
  color ballColor;
  float gravity;
  float speedVert;
  float airFriction;
  float friction;
  float speedHorizon;

  Ball(float startX, float startY, int s, color c, float g, float af, float f, float sh) {
    x = startX;
    y = startY;
    size = s;
    ballColor = c;
    gravity = g;
    airFriction = af;
    friction = f;
    speedHorizon = sh;
    speedVert = 0;
  }

  void update() {
    applyGravity();
    applyHorizontalSpeed();
    keepInScreen();
  }

  void display() {
    fill(ballColor);
    ellipse(x, y, size, size);
  }

  void applyGravity() {
    speedVert += gravity;
    y += speedVert;
    speedVert -= (speedVert * airFriction);
  }

  void applyHorizontalSpeed() {
    x += speedHorizon;
    speedHorizon -= (speedHorizon * airFriction);
  }

  void keepInScreen() {
    if (y + size/2 > height) {
      makeBounceBottom(height);
      decreaseHealth();
    }

    if (y - size/2 < 0) {
      makeBounceTop(0);
    }

    if (x - size/2 < 0) {
      makeBounceLeft(0);
    }

    if (x + size/2 > width) {
      makeBounceRight(width);
    }
  }

  void makeBounceLeft(float surface){
    x = surface + size/2;
    speedHorizon *= -1;
    speedHorizon -= (speedHorizon * friction);
  }

  void makeBounceRight(float surface){
    x = surface - size/2;
    speedHorizon *= -1;
    speedHorizon -= (speedHorizon * friction);
  }

  void makeBounceBottom(float surface) {
    y = surface - size/2;
    speedVert *= -1;
    speedVert -= (speedVert * friction);
  }

  void makeBounceTop(float surface) {
    y = surface + size/2;
    speedVert *= -1;
    speedVert -= (speedVert * friction);
  }

  void bounceOffRacket(float racketY, float racketHeight, float mouseOverhead) {
    if (speedVert > 0 &&
        x + size/2 > mouseX - racketWidth/2 &&
        x - size/2 < mouseX + racketWidth/2 &&
        y + size/2 >= racketY - racketHeight/2 &&
        y + size/2 <= racketY + racketHeight/2 + abs(speedVert)) {
      makeBounceBottom(racketY - racketHeight/2);
      if (mouseOverhead < 0) {
        speedVert += mouseOverhead * 0.2;
      }
    }
  }
}