
int window_height = 600;
int window_width  = 800; 
int score = 0;
int game_status;
int n_pillars = 4;
Circle player = new Circle();
Pillar[] pillar = new Pillar[n_pillars];

void setup() {
  size(window_width, window_height);
  for (int i =0; i < n_pillars; i++) {
    pillar[i] = new Pillar(i);
  }
  game_status = 0;
}

void draw() {
  background(#2980b9);
  switch(game_status) {
  case 0:
    initialScreen();
    break; 
  case 1:
    gameRun();
    break;
  case 2:
    gameOver();
    break;
  }
}

void initialScreen() {
  textSize(32);
  text("Flappy Ball", (window_width/2)-80, (window_height/2)-70);
  textSize(16);
  text("Press <SPACE> to play!", (window_width/2)-85, (window_height/2)-10);
  
}

void gameOver() {
  textSize(32);
  fill(#ecf0f1);
  text("Game Over", (window_width/2)-80, (window_height/2)-70);
  textSize(16);
  text("Score", (window_width/2)-15, (window_height/2)-25);
  ellipse((window_width/2)+8, (window_height/2)+30,50, 50);
  fill(#2c3e50);
  textSize(20);
  if(score < 10){
    text(score, (window_width/2)+2, (window_height/2)+38);
  } else {
    text(score, (window_width/2)-4, (window_height/2)+38);
  }
}

void gameRun() {
  player.move();
  player.render();
  player.collisionListener();
  for (int i = 0; i < n_pillars; i++) {
    pillar[i].render(); 
    pillar[i].checkLimits();
    pillar[i].setPoints();
  }
  renderScore();
}

void renderScore() {
  strokeWeight(2);
  stroke(#ecf0f1);
  fill(#2c3e50);
  ellipse(70, 70, 80, 80);
  stroke(#2c3e50);
  fill(#ecf0f1);
  ellipse(40, 35, 60, 60);
  textSize(18);
  fill(#2c3e50);
  text("Score", 17, 40);
  fill(#ecf0f1);
  textSize(24);
  text(score, 65, 85);
}

void again(){
  score = 0;
  player.yCoord = (window_height/2)-100;
  player.yTemp = 0;
  for(int i = 0; i < n_pillars; i++){
    pillar[i].xCoord = 600+(i*200);
    pillar[i].validate = false;
  }
  game_status--;
}

class Circle {
  float xCoord, yCoord, yTemp;

  Circle() {
    xCoord = window_width/4;
    yCoord = window_height/2;
  } 

  void render() {
    gravity();
    stroke(#2c3e50);
    fill(#ecf0f1);
    strokeWeight(3);
    ellipse(xCoord, yCoord, 30, 30);
  }

  void jump() {
    yTemp = -10;
  }

  void gravity() {
    yTemp += 0.45;
  }

  void move() {
    yCoord += yTemp;
    for (int i = 0; i < n_pillars; i++) {
      pillar[i].xCoord -= 3.25;
    }
  }

  void collisionListener() {
    if (yCoord > window_height) {
      game_status++;
    }
    for(int i = 0; i < n_pillars; i++){
      if((xCoord < pillar[i].xCoord+10 && xCoord > pillar[i].xCoord-10) && (yCoord < pillar[i].fissure-100 || yCoord > pillar[i].fissure+100)){
        game_status++;
      } 
    }
  }
}

class Pillar {
  float xCoord, fissure; 
  boolean validate = false;
  Pillar(int i) {
    xCoord = 600+(i*200);
    generateFissure(100);
  }

  void render() {
    line(xCoord, 0, xCoord, fissure-100);
    line(xCoord, fissure+100, xCoord, window_height);
  }

  void checkLimits() {
    if (xCoord < 0) {
      xCoord += 200*4;
      generateFissure(400); 
      validate = !validate;
    }
  }

  void setPoints() {
    if (xCoord < window_width/4 && !validate) {
      score++; 
      validate = !validate;
    }
  }

  void generateFissure(int i) {
    fissure = random(i)+100;
  }
}

void keyPressed() {
  if (game_status == 0) {
    game_status++;
  } else if(game_status == 2) {
    again();
  } else {
    player.jump();
  }
}

